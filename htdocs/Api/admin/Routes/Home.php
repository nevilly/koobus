<?php

class Home {
    static  $APP;
    static $page;
    static $view;

    public function __construct()
    {
        self::$APP = getenv("App");
    }

    public function render($params = ''){
        $p = json_decode($params);

    

        if(file_exists(__DIR__."/../Views/$p->view.php")) {
            return include_once __DIR__ . "/../Views/$p->view.php";
        }elseif (file_exists(__DIR__."/../Views/$p->view/$p->page.php"))
           return include_once (__DIR__."/../Views/$p->view/$p->page.php");
        elseif (file_exists(__DIR__."/../Views/$p->view/$p->view.php"))
            return include_once (__DIR__."/../Views/$p->view/$p->view.php");
        return print_r("No veiw was found!");
    }
}
