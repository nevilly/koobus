<?php
// KOO_BUS_ADAPT: TripEvents controller
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/TripEventsModule.php";

class TripEventsController extends TripEventsModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){ return parent::add($data); }
    public function get($id = ''){
        $res = parent::get($id);
        $data = false;
        if($res && $res->num_rows > 0){
            if(!empty($id)) $data = $res->fetch_object();
            else $data = $res->fetch_all(MYSQLI_ASSOC);
        }
        return $data;
    }
    public function get_by_trip($trip_id){ $res=parent::get_by_trip($trip_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_by_child($child_id){ $res=parent::get_by_child($child_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_by_trip_child($trip_id, $child_id){ $res=parent::get_by_trip_child($trip_id, $child_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function delete_event($id){ return parent::delete_event($id); }
}
