<?php
error_reporting(1);
include_once __DIR__."/Util/DotRD.php";

include_once __DIR__."/HTTP/http.php";
include_once __DIR__."/Util/Util.php";

use DotRD\DotRD;
(new DotRD(__DIR__ . '/.rd'))->load();


class Config extends HTTP {
    public $routes = array(); // number of pages captured on the url
    public $route = '';
    public $route1 = '';
    public $route2 = '';
    public $route3 = '';
    public $route4 = '';
    public $route5 = '';
    public $route6 = '';

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

        if(strpos($this->route, "password") !== false){
            $this->route1 = $this->route;
            $this->route = "Users";
        }

        if(strpos($this->route, "install") !== false){
            $this->route1 = $this->route;
            $this->route = "Table";
        }

        if(strpos($this->route, "users") !== false && empty($this->route1)){
            $this->route2 = $this->route1;
            $this->route1 = $this->route;
            $this->route = "Users";
        }

        if(strpos($this->route, "user") !== false && empty($this->route1)){
            $this->route2 = $this->route1;
            $this->route1 = $this->route;
            $this->route = "Users";
        }

        if(strpos($this->route, "posts") !== false && empty($this->route1)){
            $this->route2 = $this->route1;
            $this->route1 = $this->route;
            //$this->route = "posts";
        }

        if(strpos($this->route, "activate") !== false){
            $this->route2 = $this->route1;
            $this->route1 = $this->route;
            $this->route = "Users";
            include_once __DIR__ . "/Routes/$this->route.php";
            $class = new $this->route();

            $r = str_replace("-","_", $this->route1);
            $params = parent::encode(array(
                'page'=>$this->route2,
                'page1'=>$this->route3,
                'page2'=>$this->route4,
                'page3'=>$this->route5,
                'page4'=>$this->route6
            ));

            return  parent::response($class->$r($params));
        }

        if(strpos($this->route, "login") !== false){
            $this->route1 = $this->route;
            $this->route = "Users";
        }

        if(strpos($this->route, "search") !== false){
            $this->route1 = $this->route;
            $this->route = "Search";
        }

        $this->route = ucfirst($this->route1);
    

 
        if(file_exists(__DIR__."/Routes/$this->route.php")) {
        
            include_once __DIR__ . "/Routes/$this->route.php";

             $class = new $this->route();
           

            $r = str_replace("-","_", $this->route2);
             $params = parent::encode(array(
                 'page'=>$this->route2,
                 'page1'=>$this->route3,
                 'page2'=>$this->route4,
                 'page3'=>$this->route5,
                 'page4'=>$this->route6
             ));

             if (method_exists($class,$r))
                return print_r(parent::response($class->$r($params))); /// This method should only return array data
            return print_r(parent::response(["status"=>403,"payload"=>"Unauthorised Access"]));
        }elseif (file_exists(__DIR__."/$this->route.php")){
            return include_once __DIR__ . "/$this->route.php";
        }

        return print_r(parent::response(["status"=>403,"payload"=>"Unauthorised Accessz"]));
    }

}

new Config();
