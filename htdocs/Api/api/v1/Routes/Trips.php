<?php
// KOO_BUS_ADAPT: Trips routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";

class Trips extends TripsController
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

    public function by_driver($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $did = isset($p->page) ? $p->page : '';
        $res = parent::get_by_driver($did);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_route($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $rid = isset($p->page) ? $p->page : '';
        $res = parent::get_by_route($rid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function active_by_driver($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $did = isset($p->page) ? $p->page : '';
        $res = parent::get_active_by_driver($did);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function active(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $res = parent::get_active();
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

    public function update(){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $sql = parent::update_trip($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function start(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->trip_id) ? $this->data->trip_id : (isset($this->data->id) ? $this->data->id : '');
        $sql = parent::start_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Trip started");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function end(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->trip_id) ? $this->data->trip_id : (isset($this->data->id) ? $this->data->id : '');
        $sql = parent::end_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Trip completed");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function cancel(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->trip_id) ? $this->data->trip_id : (isset($this->data->id) ? $this->data->id : '');
        $sql = parent::cancel_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Trip cancelled");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->id) ? $this->data->id : '';
        $sql = parent::delete_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
