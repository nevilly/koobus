
<?php
error_reporting(1);
include_once __DIR__ . "./Module/Database.php";

class Session extends Database {

    public $loggedIn = false;
    public $user;
    public $token;
    public $role;

    public function __construct()
    {
        parent::__construct();
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        $this->session_state();
        $this->cookies_state();
    }

    public function add($str, $value){

        if(!isset($_SESSION[$str]) || !isset($_COOKIE[$str])) {
            $_SESSION[$str] = $value;
            setcookie($str, $value, strtotime("+3 days"), $_SERVER["DOCUMENT_ROOT"].'/', '', '', TRUE);
        }

        return true;
    }

    public function session_state(){
        if(isset($_SESSION['name']) && !empty($_SESSION['token']) && !empty($_SESSION['role'])){

            $this->user = isset($_SESSION['name']) ? preg_replace("#[^a-z0-9-_@. ]#i",'',$_SESSION['name']) : '';
            $this->token = isset($_SESSION['token']) ? $_SESSION['token'] : '';
            $this->role = isset($_SESSION['role']) ? preg_replace("#[^a-z0-9]#i",'',$_SESSION['role']) : '';
            if(!empty($this->token) && !empty($this->user)){
                $this->loggedIn = $this->is_logged_in();
            }
        }
    }

    public function cookies_state(){
        if(isset($_COOKIE['name']) && !empty($_COOKIE['token'])  && !empty($_COOKIE['role'])){

            $this->user = preg_replace("#[^a-z0-9-@_. ]#i",'',$_COOKIE['name']);
            $this->token = $_COOKIE['token'];
            $this->role = preg_replace("#[^a-z0-9]#i",'',$_COOKIE['role']);

            if(!empty($this->user) && !empty($this->token)){
                $this->loggedIn = $this->is_logged_in();
                if($this->loggedIn){
                    $this->update_user_state();
                }
            }
        }
    }

    public function is_logged_in(){
        $user = $this->user;
       $id = $this->token;
        $sql = array('table'=>'users','cols'=>'token,username,privilege','where'=>"username = '$user' AND token = '$id'");
        $sql = $this->select($this->encode($sql));
        $state = false;

        if($sql->num_rows > 0){
            $state = true;
            while ($row = $sql->fetch_array(MYSQLI_ASSOC)){
                 if($row['privilege'] == '1')
                     $this->role = "Administrator";
                elseif ($row['privilege'] == '2')
                     $this->role = "Super" ;
                else
                    $this->role = 'User';
                $this->user = $row['username'];
            }
        }
        return $state;
    }


    public function update_user_state(){
        $user = $this->user;
        $id = $this->token;
        $this->update($this->encode(array('table'=>'users',
            'data'=> 'last_login = now()',
            'where'=>"token = '$id' AND username = '$user' LIMIT 1")));
    }

    public function logout(){

        $_SESSION = array();

        if(isset($_SESSION['token'], $_SESSION['name'])) {
            session_destroy();
        }

        setcookie('token', '', time() - 3600, $_SERVER["DOCUMENT_ROOT"].'/','', '', TRUE);
        setcookie('name', '', time() - 3600, $_SERVER["DOCUMENT_ROOT"].'/','', '', TRUE);
        setcookie('role', '', time() - 3600, $_SERVER["DOCUMENT_ROOT"].'/','', '', TRUE);

        if(isset($_SESSION['token'], $_SESSION['user'])) {
            $state = false;
        }else {
            $state = true;
        }

        return $state;
    }
}

?>
