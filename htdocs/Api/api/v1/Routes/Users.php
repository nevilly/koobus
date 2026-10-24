<?php

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
        $this->data =parent::decode(file_get_contents("php://input"));

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
            $username = (self::getUserIdByToken(Util::$token))->username;

            if($username){
                $message = Util::base64_to_PNG($avatar, "/public/uploads/$username/data/");
                if($message && parent::add_avatar($message,$validate))
                    $status = 200;
            }
        }

        return array('status'=>$status, 'payload'=>$message);
    }

    /**
     * @param string $data
     * @return array
     * @throws Exception
     */
    public function add($data = ''){

        if($this->clean->Method() !== "POST" &&  !Util::tokenValidate()  && !(array) $this->data)
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = $this->data;
        $fn = isset($data->first_name)? ucfirst($this->clean->clean_input($data->first_name)) : '';
        $ln = isset($data->last_name)?ucfirst($this->clean->clean_input($data->last_name)) : '';
        $un = isset($data->username)?$this->clean->clean_input($data->username) : '';
        $e = isset($data->email) ? $data->email : '';
        $addr = isset($data->address)?$this->clean->clean_input($data->address) : '';
        $gn = isset($data->gender)?$this->clean->clean_input($data->gender) : '';
        $ag = isset($data->age)?$this->clean->clean_input($data->age) : '';
        $pwd = isset($data->password)?$this->clean->clean_input($data->password) : '';
        $bio = isset($data->bio)?$this->clean->clean_input($data->bio) : '';
        $role = isset($data->role)?$this->clean->clean_input($data->role) : '';
        //$pwd1 = isset($data->confirm_password)??$this->clean->clean_input($data->confirm_password);
        $pn = isset($data->phone)?$this->clean->clean_input($data->phone) : '';

        $status = 204;
        $data = http::message($status);

        if(!empty($fn) && !empty($ln) && !empty($un) && !empty($e) &&  !empty($pwd) && !empty($pn)){

            $status = 401;

            $data = "Sorry a user with the same information exists on our system. Please login!";

            if(!parent::get_user_by_email_or_username($e) &&
                !parent::get_user_by_email_or_username($un)){

                $data = "Sorry something went wrong. Please try again!";


                //User data
                // Token
                $token = Util::encrypt_decrypt(Util::generateToken($this->encode(['username'=>$un]),$this->key));

                $sql =  parent::add($this->encode(array(
                    'first_name'=>$fn,
                    'last_name'=>$ln,
                    'privilege'=>$role,
                    'username'=>$un,
                    'phone_number'=>$pn,
                    'password'=>Util::Hash($pwd),
                    'birth'=>$ag,
                    'gender'=>$gn,
                    'address'=>$addr,
                    'email'=>$e,
                    'bio'=>$bio,
                    'token'=>$token,
                )));

                if($sql){
                    $appName = isset($_ENV['mail_user']) ? getenv("mail_user"): '';
                    $from = isset($_ENV['mail']) ? getenv("mail") :'';
                    $host = isset($_ENV['smtp_host']) ?getenv("smtp_host") :'';
                    $port = isset($_ENV['smtp_port']) ?getenv("smtp_port"):'';
                    $url = Util::Url();

                    // get user data for token generation
                    $user = parent::check_user($un, Util::Hash($pwd));

                    $status = 200;
                    $data = "User #$un was added successful!";
                    // mail
                    $sub = "Account Registration!";
                    $msg = "Hello <b>$un</b>, <br> Thank you for creating an account with us, 
from <b>$appName</b> a while ago!<br> Your username is <b>$un</b> <br> passwords are <b>$pwd</b><br>
<a href='$url/activate/$token'>Click here to activate your account</a>";

                    Util::Mailer($from,$e,$sub,$msg,$un);
                }
            }

        }

        return array('status'=>$status, 'payload'=>$data);
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
        $addr = isset($data->address)?$this->clean->clean_input($data->address) : '';
        $gn = isset($data->gender)?$this->clean->clean_input($data->gender) : '';
        $ag = isset($data->age)? date("Y-m-d", strtotime($data->age)): '';
        $pwd = isset($data->password)?$this->clean->clean_input($data->password) : '';
        $bio = isset($data->bio)?$this->clean->clean_input($data->bio) : '';
        $role = isset($data->position)?$this->clean->clean_input($data->position) : '';
        //$pwd1 = isset($data->confirm_password)??$this->clean->clean_input($data->confirm_password);
        $pn = isset($data->phone)?$this->clean->clean_input($data->phone) : '';

        $status = 403;

        $data = "Sorry something went wrong. Please try again!";

        $dd = array(
            'first_name'=>$fn,
            'last_name'=>$ln,
            'position'=>$role,
            'phone_number'=>$pn,
            'password'=>Util::Hash($pwd),
            'birth'=>$ag,
            'gender'=>strtolower($gn),
            'address'=>$addr,
            'email'=>$e,
            'bio'=>$bio,
            'id'=>$user
        );

        if(!$this->get_user_by_email_or_username($un))
            $dd["username"] = $un;

        $sql =  parent::update_user($this->encode($dd));

        if($sql){
            $appName = isset($_ENV['mail_user']) ?getenv("mail_user"): '';
            $from = isset($_ENV['mail']) ? getenv("mail") :'';
            $host = isset($_ENV['smtp_host']) ?getenv("smtp_host") :'';
            $port = isset($_ENV['smtp_port']) ?getenv("smtp_port"):'';
            $url = Util::Url();

            //User data
            // Token
            $token = Util::encrypt_decrypt(Util::generateToken($user,$this->key));

            $status = 200;
            $data = "User #$un was updated successful!";
            // mail
            $sub = "Account updating!";
            $msg = "Hello <b>$un</b>, <br> Thank you for updating your account with us, 
from <b>$appName</b> a while ago!";

            Util::Mailer($from,$e,$sub,$msg,$appName);
        }

        return array('status'=>$status, 'payload'=>$data);
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
//        print_r($t);
        if(Util::tokenValidate($t) && parent::activate_user_by_token(Util::$token))
            print("
        <h1 style='color: green;font-size: 2rem;text-align: center'>Thank you for trusting us</h1>
        
        ");

        exit();
    }

    /**
     * @return array
     * @throws Exception
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
            $d['username'] = ucfirst($d['username']);

            $data = (object) $d;
        }

        return array('status'=>$status, 'payload'=>$data);
    }


    public function get_users_by_roles($value)
    {
        $sql = parent::get_users_by_roles($value); // TODO: Change the autogenerated stub
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

        $id = !empty($this->data->user_id) ? $this->data->user_id : '';
        $message = "User with #$id ID. does not exists!";
        $status = false;

        if($this->clean->Method() !== "POST" || !Util::tokenValidate() || empty($id))
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $username = parent::get($id);
        if(is_object($username))
            $username = $username->name;

        $data =  parent::delete_user($id); //returns bool
        if($data){
            $status = ($data);
            $message = "User was #$username deleted!";
        }

        return array('status'=>200, 'payload'=>array('status'=>$status,'message'=>$message));
    }

    /**
     * @return array
     */
    public function users($d = ''){

        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $d = $this->decode($d);
        $username = isset($d->page) && !empty($d->page) ? $d->page : '';
        $data = "No record found!";
        $datas =  parent::users($username);
        $status = 204;
        if($datas) {
            $status = 200;
            if(empty($username))
                foreach ($datas as $key => $datum) {
                    $datas[$key]['password'] = '';
                    $datas[$key]['status'] = (int) $datas[$key]['status'];
                }

            $data = $datas;
        }

        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * @return array
     */
    public function login(){
        if($this->clean->Method() !== "POST" || !is_object($this->data))
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $device_type = strtolower(Util::RequestType());

        $allowed_devices = preg_match("(desktop|mobile web)", $device_type);
        $isApp = !isset(apache_request_headers()["Request_type"]);

        $status = 406;
        $message = http::message($status);
        if(isset($this->data->username,$this->data->password)
        && !empty($this->data->password) && !empty($this->data->username)){
            $u = $this->clean->clean_input($this->data->username);
            $p = $this->data->password;

            if(strlen($u) >= 5 && strlen($p) >= 6 ) {

               $p = Util::Hash($p);

               $token = Util::generateToken((object)$this->encode(["username" => $u]), $this->key);
               $token = Util::encrypt_decrypt($token);

                $message = "Invalid username or password";
                $user = parent::check_user($token, $p);
                $user = !is_object($user) ? parent::check_user($u, $p) : $user;

                if($allowed_devices && preg_match("(1|2)",$user->privilege) && $user->status == '1') {

                    include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Session.php";
                    if ($user->token) {

                        if($user->privilege == '1')
                            $role = "Administrator";
                        elseif ($user->privilege == '2')
                            $role = "Super Admin" ;
                        else
                            $role = 'User';

                        $session = new Session();
                        $session->add("name", $user->username);
                        $session->add("role", $role);
                        $session->add("token", $user->token);

                        $status = 200;
                        // get token
                        $message = $user->token; /// return token
                    }
                }elseif ($isApp && $user->status == '1') {

                    if ($user->token) {
                        //                    print_r($user);
                        $status = 200;
                        // get token
                        $message = $user->token; /// return token
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
                $to = $user->email;
                $username = $user->username;
                $id = $user->id;

                try {
                    $new_password = substr(Util::generate_key(),0,8);
                    $appName = isset($_ENV['mail_user']) ??getenv("mail_user");
                    $from = isset($_ENV['mail']) ??getenv("mail");
                    $host = isset($_ENV['smtp_host']) ??getenv("smtp_host");
                    $port = isset($_ENV['smtp_port']) ??getenv("smtp_port");
                    $message = "Sorry user with provided details does not exists!";

                    if(parent::reset_password(parent::encode(array('p'=>$this->clean->Hash($new_password),'u'=>$id)))){
                        // mail
                        $sub = "Password reset request!";
                        $msg = "Hello <b>$username</b>, <br> Here the new password you've request 
from <b>$appName</b> a while ago!<br> <b>$new_password</b>";
                        $status = 200;
                        $message = "Password rest was successful!";
                        Util::Mailer($from,$to,$sub,$msg,$appName);
                    }

                } catch (Exception $e) {
                    $message = $e;
                }
            }
        }


        return array('status'=>$status,'payload'=>$message);
    }

}

//$class = new Users();