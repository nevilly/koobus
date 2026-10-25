<?php
// KOO_BUS_ADAPT: Rekebishwa kwa KooBus - inatumia role/phone/schema mpya

include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/UsersController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class Users extends UsersController
{
    private $data;
    private $clean;
    private $key;

    /**
     * Users constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));

        $this->key = getenv("SECRET");
    }

    /**
     * @return array
     * @throws Exception
     */
    public function update_avatar(){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");

        // KOO_BUS_ADAPT: avatar ni ya mtumiaji aliyeingia tu.
        list($ok, $authUser) = AuthGuard::requireAny();
        if(!$ok) return $authUser;

        $status = 201;
        $message = 'File is required!';

        if(isset($this->data->avatar) && !empty($this->data->avatar)){
            $avatar = $this->data->avatar;
            $username = isset($authUser->username) ? $authUser->username : '';

            if($username){
                $message = Util::base64_to_PNG($avatar, "/public/uploads/$username/data/");
                if($message && parent::add_avatar($message, $authUser->id))
                    $status = 200;
            }
        }

        return array('status'=>$status, 'payload'=>$message);
    }

    /**
     * KOO_BUS_ADAPT: Register user kwa KooBus
     */
    public function add($data = ''){

        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = $this->data;
        if(!is_object($data))
            return array('status'=>400,'payload'=>"Invalid data");

        // KOO_BUS_ADAPT: Usajili wa wazi unaruhusiwa kwa `parent` pekee.
        // Akaunti za wafanyakazi wa shule (driver/matron/school_admin)
        // huundwa na school_admin au super_admin aliyeingia.
        $requestedRole = isset($data->role) ? $this->clean->clean_input($data->role) : 'parent';
        $allowedRoles = array('parent','driver','matron','school_admin','super_admin');
        if(!in_array($requestedRole, $allowedRoles, true))
            return array('status'=>403,'payload'=>"Invalid role");

        $caller = AuthGuard::user();
        $callerRole = $caller && isset($caller->role) ? $caller->role : '';
        $isSuperAdmin = $callerRole === 'super_admin';
        $isSchoolAdmin = $callerRole === 'school_admin';

        // KOO_BUS_ADAPT: Bootstrap ya super_admin wa kwanza.
        // Kama hakuna super_admin hata mmoja, mtu wa kwanza anaweza kuunda
        // super_admin (hii inaondoa mzunguko wa "nani aanzishe admin?").
        // Baada ya hapo endpoint hii inahitaji super_admin aliyeingia.
        $bootstrapSuper = false;
        if($requestedRole === 'super_admin' && !$isSuperAdmin && !$isSchoolAdmin){
            if(parent::get_users_by_roles('super_admin')){
                return array('status'=>403,'payload'=>"Forbidden");
            }
            // Hakuna super_admin bado: ruhusu usajili huu mmoja.
            $bootstrapSuper = true;
        }

        if($requestedRole !== 'parent'){
            if(!$isSuperAdmin && !$isSchoolAdmin && !$bootstrapSuper)
                return array('status'=>403,'payload'=>"Forbidden");
            // school_admin hawezi kuunda admin mwingine
            if($isSchoolAdmin && ($requestedRole === 'school_admin' || $requestedRole === 'super_admin'))
                return array('status'=>403,'payload'=>"Forbidden");
        }

        // KOO_BUS_ADAPT: school_id — kutenganisha data kwa shule.
        //  - super_admin: hana shule (0)
        //  - school_admin: analazimishwa shule yake; asiwe na shule -> 403
        //  - wengine: school_id kutoka body (ikithibitishwa ipo)
        $schoolId = 0;
        if($requestedRole !== 'super_admin'){
            if($isSchoolAdmin){
                $schoolId = Tenant::schoolIdOfUser($caller);
                if($schoolId <= 0)
                    return array('status'=>403,'payload'=>"No school assigned to your account");
            } elseif(isset($data->school_id) && intval($data->school_id) > 0){
                $schoolId = intval($data->school_id);
            }

            // Hakikisha shule ipo kabla ya kuunganisha mtumiaji.
            if($schoolId > 0){
                include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/SchoolsController.php';
                $sc = new SchoolsController();
                $school = $sc->get($schoolId);
                if(!$school || !is_object($school)) $schoolId = 0;
            }
        }

        $role = $requestedRole;
        $fn = isset($data->first_name)? ucfirst($this->clean->clean_input($data->first_name)) : '';
        $ln = isset($data->last_name)?ucfirst($this->clean->clean_input($data->last_name)) : '';
        $un = isset($data->username)?$this->clean->clean_input($data->username) : '';
        $e = isset($data->email) ? $data->email : '';
        $gn = isset($data->gender)?$this->clean->clean_input($data->gender) : '';
        $pwd = isset($data->password)?$this->clean->clean_input($data->password) : '';
        $bio = isset($data->bio)?$this->clean->clean_input($data->bio) : '';
        $pn = isset($data->phone)?$this->clean->clean_input($data->phone) : (isset($data->phone_number)?$this->clean->clean_input($data->phone_number):'');

        $status = 204;
        $res = http::message($status);

        // KOO_BUS_ADAPT: phone ni lazima (DB ina NOT NULL + unique).
        if(empty($pwd) || empty($pn)){
            return array('status'=>400,'payload'=>"phone and password are required");
        }

        // KOO_BUS_ADAPT: `get_user_by_email_or_username('')` hurudisha
        // watumiaji WOTE (WHERE tupu), hivyo ni lazima kukagua tu
        // thamani zisizo tupu. Bila hivi, usajili bila email ungezuiwa.
        $duplicate = false;
        if($pn !== '' && parent::get_user_by_email_or_username($pn)) $duplicate = true;
        if(!$duplicate && $e !== '' && parent::get_user_by_email_or_username($e)) $duplicate = true;
        if(!$duplicate && $un !== '' && parent::get_user_by_email_or_username($un)) $duplicate = true;

        if($duplicate){
            $status = 401;
            $res = "Sorry a user with the same information exists on our system. Please login!";
            return array('status'=>$status, 'payload'=>$res);
        }

        $token = Util::encrypt_decrypt(Util::generateToken($this->encode(['username'=>$un ?: $pn]),$this->key));

        // KOO_BUS_ADAPT: usiingize thamani tupu kwenye unique/FK columns.
        //  - school_id=0 ingevunja FK (hakuna shule id 0)
        //  - email='' ingevunja unique_email kwa mtumiaji wa pili
        //  - phone='' ingevunja unique_phone
        $fields = array(
            'role'=>$role,
            'phone'=>$pn,
            'password'=>Util::Hash($pwd),
            'token'=>$token,
            'status'=>'1'
        );
        if($schoolId > 0) $fields['school_id'] = $schoolId;
        if($fn !== '') $fields['first_name'] = $fn;
        if($ln !== '') $fields['last_name'] = $ln;
        if($un !== '') $fields['username'] = $un;
        if($e !== '') $fields['email'] = $e;
        if($gn !== '') $fields['gender'] = $gn;
        if($bio !== '') $fields['bio'] = $bio;

        $sql = parent::add($this->encode($fields));
        if($sql){
            $status = 200;
            $res = "User registered successfully";
        } else {
            $status = 500;
            $res = "Sorry something went wrong. Please try again!";
        }

        return array('status'=>$status, 'payload'=>$res);
    }

    /**
     * @param string $data
     * @return array
     * @throws Exception
     */
    public function update($data = ''){

        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");

        // KOO_BUS_ADAPT: mtumiaji anaweza kubadilisha taarifa ZAKE tu.
        // `id` inatoka kwenye token, si kwenye body (kuzuia ID tampering).
        list($ok, $authUser) = AuthGuard::requireAuth();
        if(!$ok) return $authUser;
        $uid = isset($authUser->id) ? $authUser->id : '';

        $data = $this->data;
        $fn = isset($data->first_name)? ucfirst($this->clean->clean_input($data->first_name)) : '';
        $ln = isset($data->last_name)? ucfirst($this->clean->clean_input($data->last_name)) : '';
        $un = isset($data->username)?$this->clean->clean_input($data->username) : '';
        $e = isset($data->email)?$data->email : '';
        $gn = isset($data->gender)?$this->clean->clean_input($data->gender) : '';
        $pwd = isset($data->password)?$this->clean->clean_input($data->password) : '';
        $bio = isset($data->bio)?$this->clean->clean_input($data->bio) : '';
        $pn = isset($data->phone)?$this->clean->clean_input($data->phone) : '';

        $status = 403;
        $res = "Sorry something went wrong. Please try again!";

        $dd = array(
            'first_name'=>$fn,
            'last_name'=>$ln,
            'phone'=>$pn,
            'gender'=>strtolower($gn),
            'email'=>$e,
            'bio'=>$bio,
            'id'=>$uid
        );
        if(!empty($pwd)) $dd['password'] = Util::Hash($pwd);
        if(!empty($un) && !$this->get_user_by_email_or_username($un)) $dd["username"] = $un;

        $sql =  parent::update_user($this->encode($dd));
        if($sql){
            $status = 200;
            $res = "User updated successfully";
        }

        return array('status'=>$status, 'payload'=>$res);
    }

    /**
     * @param string $params
     * @return array
     * @throws Exception
     */
    public function activate($params = ''){

        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $params = parent::decode($params);
        $t = isset($params->page) && !empty($params->page) ? Util::encrypt_decrypt($params->page,'decrypt') : '';
        if(Util::tokenValidate($t) && parent::activate_user_by_token(Util::$token))
            print("<h1 style='color: green;font-size: 2rem;text-align: center'>Thank you for trusting us</h1>");
        exit();
    }

    /**
     * KOO_BUS_ADAPT: Get current user profile
     */
    public function user(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireAuth();
        if(!$ok) return $res;

        $status = 200;
        $d = (array) $res;
        // KOO_BUS_ADAPT: usirudishe siri yoyote kwenye profile.
        unset($d['password'], $d['token']);
        if(isset($d['username'])) $d['username'] = ucfirst($d['username']);
        $data = (object) $d;

        return array('status'=>$status, 'payload'=>$data);
    }


    public function get_users_by_roles($value)
    {
        list($ok, $res) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $res;
        $authUser = $res;

        // KOO_BUS_ADAPT: school_admin anaona watumiaji wa shule yake tu.
        $isSuper = Tenant::isSuperAdmin($authUser);
        $scopeSchool = Tenant::schoolIdOfUser($authUser);
        if(!$isSuper && $scopeSchool <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        $sql = parent::get_users_by_roles($value);
        $status = 204;
        $data = http::message($status);
        if($sql){
            $status = 200;
            // KOO_BUS_ADAPT: chuja kwa shule na usirudishe token/password.
            if(is_array($sql)){
                $out = array();
                foreach ($sql as $row) {
                    $rowArr = (array) $row;
                    if(!$isSuper){
                        $rowSchool = isset($rowArr['school_id']) ? intval($rowArr['school_id']) : 0;
                        if($rowSchool !== $scopeSchool) continue;
                    }
                    unset($rowArr['password'], $rowArr['token']);
                    $out[] = (object) $rowArr;
                }
                $sql = $out;
            }
            $data = $sql;
        }

        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * @return array
     * @throws Exception
     */
    public function delete($id = ''){

        $id = !empty($this->data->user_id) ? $this->data->user_id : $id;
        $message = "User with #$id ID. does not exists!";
        $status = false;

        if($this->clean->Method() !== "POST" || empty($id))
            return array('status'=>403,'payload'=>"Unauthorized Access");

        list($ok, $authUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $authUser;
        // Mtu hawezi kujifuta mwenyewe kupitia endpoint hii
        if(isset($authUser->id) && intval($authUser->id) === intval($id))
            return array('status'=>403,'payload'=>"Forbidden");

        $usernameObj = parent::get($id);
        if(!$usernameObj || !is_object($usernameObj))
            return array('status'=>404,'payload'=>"Not found");

        // KOO_BUS_ADAPT: school_admin anafuta watumiaji wa shule yake tu,
        // na hawezi kufuta admin mwingine.
        if(Tenant::isSchoolAdmin($authUser)){
            $mine = Tenant::schoolIdOfUser($authUser);
            $targetSchool = isset($usernameObj->school_id) ? intval($usernameObj->school_id) : 0;
            $targetRole = isset($usernameObj->role) ? $usernameObj->role : '';
            if($mine <= 0 || $targetSchool !== $mine)
                return array('status'=>403,'payload'=>"Forbidden");
            if(in_array($targetRole, array('school_admin','super_admin'), true))
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $username = isset($usernameObj->username) ? $usernameObj->username : $id;

        $dataRes =  parent::delete_user($id);
        if($dataRes){
            $status = true;
            $message = "User was deleted!";
        }

        return array('status'=>200, 'payload'=>array('status'=>$status,'message'=>$message));
    }

    /**
     * @return array
     */
    public function users($d = ''){

        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");

        // KOO_BUS_ADAPT: orodha ya watumiaji ni ya admin pekee.
        list($ok, $authUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $authUser;

        $decoded = $this->decode($d);
        $username = isset($decoded->page) && !empty($decoded->page) ? $decoded->page : '';
        $data = "No record found!";
        $datas =  parent::users($username);
        $status = 204;

        // KOO_BUS_ADAPT: school_admin anaona watumiaji wa shule yake tu.
        $isSuper = Tenant::isSuperAdmin($authUser);
        $scopeSchool = Tenant::schoolIdOfUser($authUser);
        if(!$isSuper && $scopeSchool <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        if($datas) {
            $status = 200;

            if(is_array($datas)){
                $out = array();
                foreach ($datas as $row) {
                    $rowArr = (array) $row;
                    if(!$isSuper){
                        $rowSchool = isset($rowArr['school_id']) ? intval($rowArr['school_id']) : 0;
                        if($rowSchool !== $scopeSchool) continue;
                    }
                    // KOO_BUS_ADAPT: password/token ni siri — kamwe zisionekane.
                    unset($rowArr['password'], $rowArr['token']);
                    if(isset($rowArr['status'])) $rowArr['status'] = (int) $rowArr['status'];
                    $out[] = $rowArr;
                }
                $datas = $out;
            } elseif(is_object($datas)){
                $rowArr = (array) $datas;
                if(!$isSuper){
                    $rowSchool = isset($rowArr['school_id']) ? intval($rowArr['school_id']) : 0;
                    if($rowSchool !== $scopeSchool)
                        return array('status'=>403,'payload'=>"Forbidden");
                }
                unset($rowArr['password'], $rowArr['token']);
                if(isset($rowArr['status'])) $rowArr['status'] = (int) $rowArr['status'];
                $datas = (object) $rowArr;
            }

            $data = $datas;
        }

        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * KOO_BUS_ADAPT: Login for KooBus app (mobile first)
     */
    public function login(){
        if($this->clean->Method() !== "POST" || !is_object($this->data))
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 406;
        $message = http::message($status);
        if(isset($this->data->username,$this->data->password)
        && !empty($this->data->password) && !empty($this->data->username)){
            $u = $this->clean->clean_input($this->data->username);
            $p = $this->data->password;

            if(strlen($u) >= 3 && strlen($p) >= 4 ) {
               $ph = Util::Hash($p);
               $token_gen = Util::generateToken((object)$this->encode(array("username" => $u)), $this->key);
               $token_enc = Util::encrypt_decrypt($token_gen);

                $message = "Invalid username or password";
                $user = parent::check_user($token_enc, $ph);
                if(!is_object($user)) $user = parent::check_user($u, $ph);

                if($user && $user->status == '1') {
                    if (isset($user->token) && $user->token) {
                        $status = 200;
                        $message = $user->token;
                    }
                }
            }
        }

        return array('status'=>$status,'payload'=>$message);
    }

    /**
     * @return array
     */
    public function pass(){
        if($this->clean->Method() !== "POST" || !is_object($this->data))
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 403;
        $message = "Something went wrong, please try again!";

        if(isset($this->data->username)
            && !empty($this->data->username)) {
            $u = $this->clean->clean_input($this->data->username);
            if($user = parent::get_user_by_email_or_username($u)){
                $to = isset($user->email) ? $user->email : '';
                $username = isset($user->username) ? $user->username : $u;
                $id = isset($user->id) ? $user->id : '';

                try {
                    $new_password = substr(Util::generate_key(),0,8);
                    $appName = getenv("APP_NAME") ?: 'KooBus';
                    $from = getenv("mail") ?: '';

                    if(parent::reset_password(parent::encode(array('p'=>Util::Hash($new_password),'u'=>$id)))){
                        $sub = "Password reset request!";
                        $msg = "Hello <b>$username</b>, <br> Here the new password you've request from <b>$appName</b> a while ago!<br> <b>$new_password</b>";
                        $status = 200;
                        $message = "Password reset was successful!";
                        if(!empty($from) && !empty($to)) Util::Mailer($from,$to,$sub,$msg,$appName);
                    }
                } catch (Exception $e) {
                    $message = $e;
                }
            }
        }

        return array('status'=>$status,'payload'=>$message);
    }

}
