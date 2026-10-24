<?php

include_once __DIR__."/../Controller/SearchController.php";
include_once __DIR__."/../Util/Util.php";

class Search extends SearchController
{
    private $util;
    private $data;
    public function __construct()
    {
        parent::__construct();

        $this->util = new Util();
        $this->data = isset($_POST) && count($_POST) > 0 ? parent::decode(parent::encode($_POST)) : parent::decode(file_get_contents("php://input"));
    }


    public function search(){
        if($this->util->Method() !== "POST"  && !Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");



    }
}