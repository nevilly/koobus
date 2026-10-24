<?php
// KOO_BUS_ADAPT: TripEvents routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripEventsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";

class TripEvents extends TripEventsController
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

    public function by_trip($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : '';
        $res = parent::get_by_trip($tid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_child($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $cid = isset($p->page) ? $p->page : '';
        $res = parent::get_by_child($cid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_trip_child($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : (isset($this->data->trip_id)?$this->data->trip_id:'');
        $cid = isset($p->page1) ? $p->page1 : (isset($this->data->child_id)?$this->data->child_id:'');
        $res = parent::get_by_trip_child($tid, $cid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','matron','school_admin','super_admin'));
        if(!$ok) return $res;
        // KOO_BUS_ADAPT: matron/driver huweza kurekodi board/alight/absent/excused
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->id) ? $this->data->id : '';
        $sql = parent::delete_event($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
