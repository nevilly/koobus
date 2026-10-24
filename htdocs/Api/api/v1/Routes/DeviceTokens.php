<?php
// KOO_BUS_ADAPT: DeviceTokens routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/DeviceTokensController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";

class DeviceTokens extends DeviceTokensController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    public function register(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $sql = parent::register($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Registered");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function by_user($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $uid = isset($p->page) ? $p->page : '';
        $res = parent::get_by_user($uid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function remove(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $token = isset($this->data->token) ? $this->data->token : '';
        $sql = parent::remove_token($token);
        if($sql) return array('status'=>200,'payload'=>"Removed");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function remove_by_user(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $uid = isset($this->data->user_id) ? $this->data->user_id : '';
        $sql = parent::remove_by_user($uid);
        if($sql) return array('status'=>200,'payload'=>"Removed");
        return array('status'=>500,'payload'=>"Failed");
    }
}
