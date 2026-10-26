<?php
// KOO_BUS_ADAPT: Trips controller
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/TripsModule.php";

class TripsController extends TripsModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){ return parent::add($data); }
    public function update_trip($data){ return parent::update_trip($data); }
    public function get($id = ''){
        $res = parent::get($id);
        $data = false;
        if($res && $res->num_rows > 0){
            if(!empty($id)) $data = $res->fetch_object();
            else $data = $res->fetch_all(MYSQLI_ASSOC);
        }
        return $data;
    }
    public function get_by_driver($driver_id){ $res=parent::get_by_driver($driver_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_by_route($route_id){ $res=parent::get_by_route($route_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_active_by_driver($driver_id){ $res=parent::get_active_by_driver($driver_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_manifest($trip_id, $route_id, $trip_type){ return parent::get_manifest($trip_id, $route_id, $trip_type); }
    public function get_active(){ $res=parent::get_active(); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function start_trip($id, $started_early = false, $reason = null){ return parent::start_trip($id, $started_early, $reason); }
    public function end_trip($id){ return parent::end_trip($id); }
    public function cancel_trip($id){ return parent::cancel_trip($id); }
    public function delete_trip($id){ return parent::delete_trip($id); }
}
