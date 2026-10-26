<?php
// KOO_BUS_ADAPT
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/RoutesModule.php";
class RoutesController extends RoutesModule {
    public function __construct(){ parent::__construct(); }
    public function add($data){ return parent::add($data); }
    public function update_route($data){ return parent::update_route($data); }
    public function get($id=''){ $res=parent::get($id); $data=false; if($res&&$res->num_rows>0){ if(!empty($id)) $data=$res->fetch_object(); else $data=$res->fetch_all(MYSQLI_ASSOC); } return $data; }
    public function get_by_school($school_id){ $res=parent::get_by_school($school_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_stops($route_id){ $res=parent::get_stops($route_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_stop($id){ $res=parent::get_stop($id); return ($res && $res->num_rows>0) ? $res->fetch_object() : false; }
    public function delete_route($id){ return parent::delete_route($id); }
}
