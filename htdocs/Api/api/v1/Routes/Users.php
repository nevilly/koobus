<?php
// KOO_BUS_ADAPT: Rekebishwa kwa KooBus - inatumia role/phone/schema mpya

include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/UsersController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";

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
        $validate = Util::tokenValidate();

        if($this->clean->Method() !== "PUT" && !(array) $this->data || !$validate  && !(array) $this->data)
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 201;
        $message = 'File is required!';

        if(isset($this->data->avatar) && !empty($this->data->avatar)){
            $avatar = $this->data->avatar;
            $userObj = self::getUserIdByToken(Util::$token);
            $username = $userObj ? $userObj->username : '';

            if($username){
                $message = Util::base64_to_PNG($avatar, "/public/uploads/$username/data/");
                if($message && parent::add_avatar($message,$validate))
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
        $fn = isset($data->first_name)? ucfirst($this->clean->clean_input($data->first_name)) : '';
        $ln = isset($data->last_name)?ucfirst($this->clean->clean_input($data->last_name)) : '';
        $un = isset($data->username)?$this->clean->clean_input($data->username) : '';
        $e = isset($data->email) ? $data->email : '';
        $gn = isset($data->gender)?$this->clean->clean_input($data->gender) : '';
        $pwd = isset($data->password)?$this->clean->clean_input($data->password) : '';
        $bio = isset($data->bio)?$this->clean->clean_input($data->bio) : '';
        $role = isset($data->role)?$this->clean->clean_input($data->role) : 'parent';
        $pn = isset($data->phone)?$this->clean->clean_input($data->phone) : (isset($data->phone_number)?$this->clean->clean_input($data->phone_number):'');

        $status = 204;
        $res = http::message($status);

        if(!empty($pwd) && (!empty($pn) || !empty($e))){
            if(parent::get_user_by_email_or_username($e) || parent::get_user_by_email_or_username($pn) || (!empty($un) && parent::get_user_by_email_or_username($un))){
                $status = 401;
                $res = "Sorry a user with the same information exists on our system. Please login!";
                return array('status'=>$status, 'payload'=>$res);
            }

            $token = Util::encrypt_decrypt(Util::generateToken($this->encode(['username'=>$un ?: $pn]),$this->key));
            $sql =  parent::add($this->encode(array(
                'first_name'=>$fn,
                'last_name'=>$ln,
                'role'=>$role,
                'username'=>$un,
                'phone'=>$pn,
                'password'=>Util::Hash($pwd),
                'gender'=>$gn,
                'email'=>$e,
                'bio'=>$bio,
                'token'=>$token,
                'status'=>'1'
            )));
            if($sql){
                $status = 200;
                $res = "User registered successfully";
            } else {
                $status = 500;
                $res = "Sorry something went wrong. Please try again!";
            }
        }

        return array('status'=>$status, 'payload'=>$res);
    }

    /**
     * @param string $data
     * @return array
     * @throws Exception
     */
    public function update($data = ''){

        $user = Util::tokenValidate();
        if($this->clean->Method() !== "PUT" && !(array) $this->data && !$user )
            return array('status'=>403,'payload'=>"Unauthorized Access");

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
            'id'=>$user
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
        if($this->clean->Method() !== "GET" || !Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 204;
        $data = http::message($status);
        $datas =  parent::getUserIdByToken(Util::$token);

        if($datas) {
            $status = 200;
            $d = (array) $datas;
            $d['password'] = null;
            if(isset($d['username'])) $d['username'] = ucfirst($d['username']);
            $data = (object) $d;
        }

        return array('status'=>$status, 'payload'=>$data);
    }


    public function get_users_by_roles($value)
    {
        $sql = parent::get_users_by_roles($value);
        $status = 204;
        $data = http::message($status);
        if($sql){
            $status = 200;
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

        if($this->clean->Method() !== "POST" || !Util::tokenValidate() || empty($id))
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $usernameObj = parent::get($id);
        $username = $usernameObj && is_object($usernameObj) ? (isset($usernameObj->username)?$usernameObj->username : $id) : $id;

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

        $decoded = $this->decode($d);
        $username = isset($decoded->page) && !empty($decoded->page) ? $decoded->page : '';
        $data = "No record found!";
        $datas =  parent::users($username);
        $status = 204;
        if($datas) {
            $status = 200;
            if(empty($username) && is_array($datas))
                foreach ($datas as $key => $datum) {
                    if(isset($datas[$key]['password'])) $datas[$key]['password'] = '';
                    if(isset($datas[$key]['status'])) $datas[$key]['status'] = (int) $datas[$key]['status'];
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
