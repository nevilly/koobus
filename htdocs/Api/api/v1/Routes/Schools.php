<?php
// KOO_BUS_ADAPT: Schools routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/SchoolsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";

class Schools extends SchoolsController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $res = parent::get('');
        if($res){
            $status = 200; $data = $res;
        } else {
            $status = 204; $data = http::message(204);
        }
        return array('status'=>$status,'payload'=>$data);
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        $res = parent::get($id);
        if($res){
            $status = 200; $data = $res;
        } else {
            $status = 404; $data = "Not found";
        }
        return array('status'=>$status,'payload'=>$data);
    }

    public function add(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $token = Util::tokenValidate();
        if(!$token) return array('status'=>403,'payload'=>"Unauthorized Access");
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function update(){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $token = Util::tokenValidate();
        if(!$token) return array('status'=>403,'payload'=>"Unauthorized Access");
        $sql = parent::update_school($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $token = Util::tokenValidate();
        if(!$token) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->id) ? $this->data->id : '';
        $sql = parent::delete_school($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
