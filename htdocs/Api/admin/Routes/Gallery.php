<?php
include_once ($_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/GalleryController.php");

class Gallery extends GalleryController {
    static  $APP;
    static $page;
    static $view;
    static $title;

    public function __construct()
    {
        parent::__construct();
        self::$APP = getenv("App");
    }

    public function render($params = ''){
        $p = json_decode($params);
        $r = !empty($p->page) ? $p->page : $p->view;

        $users = new Users();

        $data = false;

        if(method_exists($this,$r)) {
            $data = $this->$r();
        }

        self::$title = $p->page1 != $p->token ? $p->page1 : '';

        if(file_exists(__DIR__."/../Views/$p->view.php")) {
            include_once __DIR__ . "/../Views/$p->view.php";
        }elseif (file_exists(__DIR__."/../Views/$p->view/$p->page.php"))
            include_once (__DIR__."/../Views/$p->view/$p->page.php");
        elseif (file_exists(__DIR__."/../Views/$p->view/$p->view.php"))
            include_once (__DIR__."/../Views/$p->view/$p->view.php");
        return;
    }

    private function Gallery(){
        return parent::get();
    }
}
