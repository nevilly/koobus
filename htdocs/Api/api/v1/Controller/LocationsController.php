<?php
// KOO_BUS_ADAPT: Locations controller
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/LocationsModule.php";

class LocationsController extends LocationsModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){ return parent::add($data); }
    public function get_latest_by_trip($trip_id){ $res=parent::get_latest_by_trip($trip_id); if($res&&$res->num_rows>0) return $res->fetch_object(); return false; }
    public function get_latest_by_trips($trip_ids){ $res=parent::get_latest_by_trips($trip_ids); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_by_trip($trip_id, $limit=50){ $res=parent::get_by_trip($trip_id, $limit); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
}
