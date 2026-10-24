<?php
// KOO_BUS_ADAPT: Notifications routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/NotificationsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";

class Notifications extends NotificationsController
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
        if($res){ return array('status'=>200,'payload'=>$res); }
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        $res = parent::get($id);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>404,'payload'=>"Not found");
    }

    public function by_user($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $uid = isset($p->page) ? $p->page : '';
        $limit = isset($p->page1) ? intval($p->page1) : 50;
        $res = parent::get_by_user($uid, $limit);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function unread($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $uid = isset($p->page) ? $p->page : '';
        $res = parent::get_unread_by_user($uid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function mark_read(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->id) ? $this->data->id : '';
        $uid = isset($this->data->user_id) ? $this->data->user_id : '';
        $sql = parent::mark_read($id, $uid);
        if($sql) return array('status'=>200,'payload'=>"Marked read");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function mark_all_read(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $uid = isset($this->data->user_id) ? $this->data->user_id : '';
        $sql = parent::mark_all_read($uid);
        if($sql) return array('status'=>200,'payload'=>"All marked read");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->id) ? $this->data->id : '';
        $sql = parent::delete_notification($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
