<?php
error_reporting(1);
include_once __DIR__."/../api/v1/Util/DotRD.php";

use DotRD\DotRD;
(new DotRD(__DIR__ . '/../api/v1/.rd'))->load();

include_once __DIR__."/../api/v1/HTTP/http.php";
include_once __DIR__."/../api/v1/Util/Util.php";
include_once __DIR__."/../api/v1/Session.php";


class Config extends HTTP {
    public $routes = array(); // number of pages captured on the url
    public $route  = '';
    public $route1 = '';
    public $route2 = '';
    public $route3 = '';
    public $route4 = '';
    public $route5 = '';
    public $route6 = '';
    public $view = '';
    public static $APP;
    public $token = '';
    public $username = '';
    public  $isLogin = false;
    public  $role = "";
    public  $avatar = "";

    public function __construct()
    {
        parent::__construct();

        $routes = explode('/',$_SERVER["REQUEST_URI"]);
        $this->routes = $routes;

        // routes
        $this->route = strtolower($routes[count($routes) - (count($routes) - 1)]);
        $this->route1 = @$routes[count($routes) - (count($routes) - 2)];
        $this->route2 = @$routes[count($routes) - (count($routes) - 3)];
        $this->route3 = @$routes[count($routes) - (count($routes) - 4)];
        $this->route4 = @$routes[count($routes) - (count($routes) - 5)];
        $this->route5 = @$routes[count($routes) - (count($routes) - 6)];
        $this->route6 = @$routes[count($routes) - (count($routes) - 7)];

        self::$APP = getenv('App');

        $session = new Session();

        $this->isLogin = $session->loggedIn;
        if($this->isLogin){
   
            $this->token = $session->token;

            require_once __DIR__."/Routes/Users.php";
            $__user = new Users();

            $_user = $__user->user($this->token);
            if($__user){
                $this->username = $_user->first_name.' '.$_user->last_name;
                $this->avatar = !empty($_user->avatar)
                    ? Util::Url().'/public/uploads/'.strtolower($_user->username).'/data/'.$_user->avatar
                    : Util::Url().'/public/assets/images/user.png';

                if($_user->privilege == '1')
                    $role = "Administrator";
                elseif ($_user->privilege == '2')
                    $role = "Super Admin" ;
                else
                    $role = 'Subscriber';

                $this->role = $role;
            }
        }


        # if it's locally change to this piece of code
        if(in_array("api", $this->routes)){

            $this->route = strtolower($routes[count($routes) - (count($routes) - 3)]);
            $this->route1 = @$routes[count($routes) - (count($routes) - 4)];
            $this->route2 = @$routes[count($routes) - (count($routes) - 5)];
            $this->route3 = @$routes[count($routes) - (count($routes) - 6)];
            $this->route4 = @$routes[count($routes) - (count($routes) - 7)];
            $this->route5 = @$routes[count($routes) - (count($routes) - 8)];
            $this->route6 = @$routes[count($routes) - (count($routes) - 9)];
        }

        $this->route = ucfirst($this->route);
     

        if($this->route === 'Admin') {

            if(!$this->isLogin) {
                $this->route1 = 'auth';
                $this->view = 'login';
                $this->route2 = $this->view;
            }

            $this->route = "Home";
               

            if(!empty($this->route1) && $this->route1 !== 'auth')
                $this->route = ucfirst($this->route1);

            $this->view = $this->route;

            if(!empty($this->route1))
                $this->view = $this->route1;

            $this->route1 = "render";
        }

        if(file_exists(__DIR__."/Routes/$this->route.php")) {

            if($this->view === 'auth')
                include_once __DIR__ . "./head.php";
            else
                include_once __DIR__ . "./header.php";

            include_once __DIR__ . "/Routes/$this->route.php";


            $r = str_replace("-","_", $this->route1);
        
            $params = parent::encode(array(
                'view'=>ucfirst($this->view),
                'page'=>ucfirst($this->route2),
                'page1'=>ucfirst($this->route3),
                'page2'=>ucfirst($this->route4),
                'page3'=>ucfirst($this->route5),
                'page4'=>ucfirst($this->route6),
                'token'=>ucfirst($this->token),
            ));
            
            $class = new $this->route($params);


           $class->$r($params);

            return include_once __DIR__ ."./footer.php";
       
        }elseif (file_exists(__DIR__."/$this->route.php")){

            include_once __DIR__ . "./$this->route.php";

            return;
        }

        return print_r(parent::response(["status"=>403,"payload"=>"Unauthorised Access"]));
    }


}

new Config();
