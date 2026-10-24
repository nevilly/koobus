<?php

include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/UsersController.php";
include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Util/Util.php";

class Users extends  UsersController
{
    static  $APP;
    static $page;
    static $view;
    public $UTIL;

    public function __construct()
    {
        parent::__construct();
        self::$APP = getenv("App");
        $this->UTIL = new Util();
    }

    public function render($params = ''){
        $p = json_decode($params);

        $data = [];
        if(!empty($p->page))
            $data = self::user($p->token);
        else
            $data = self::all_users();

        if(file_exists(__DIR__."/../Views/$p->view.php")) {
            include_once __DIR__ . "/../Views/$p->view.php";
        }elseif (file_exists(__DIR__."/../Views/$p->view/$p->page.php"))
            include_once (__DIR__."/../Views/$p->view/$p->page.php");
        elseif (file_exists(__DIR__."/../Views/$p->view/$p->view.php"))
            include_once (__DIR__."/../Views/$p->view/$p->view.php");
        return;
    }  

    public function all_users(){
        return parent::users();
    }

    public function user($token){
        return parent::users($token);
    }

    public function team_member(){
        return $this->UTIL->team_members();
    }

}