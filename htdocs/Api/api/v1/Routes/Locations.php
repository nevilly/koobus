<?php
// KOO_BUS_ADAPT: Locations routes (GPS)
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/LocationsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";

class Locations extends LocationsController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    public function upload(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: driver anaweza kupakia location ya trip yake
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function latest($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : (isset($this->data->trip_id)?$this->data->trip_id:'');
        $res = parent::get_latest_by_trip($tid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function latest_many(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $ids = isset($this->data->trip_ids) ? $this->data->trip_ids : array();
        if(!is_array($ids)) $ids = array();
        $res = parent::get_latest_by_trips($ids);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function history($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : '';
        $limit = isset($p->page1) ? intval($p->page1) : 50;
        $res = parent::get_by_trip($tid, $limit);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }
}
