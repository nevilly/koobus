<?php
// KOO_BUS_ADAPT: Children controller
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/ChildrenModule.php";

class ChildrenController extends ChildrenModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){ return parent::add($data); }
    public function update_child($data){ return parent::update_child($data); }
    public function get($id = ''){
        $res = parent::get($id);
        $data = false;
        if($res && $res->num_rows > 0){
            if(!empty($id)) $data = $res->fetch_object();
            else $data = $res->fetch_all(MYSQLI_ASSOC);
        }
        return $data;
    }
    public function get_by_school($school_id){ $res=parent::get_by_school($school_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_by_route($route_id){ $res=parent::get_by_route($route_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function delete_child($id){ return parent::delete_child($id); }
}
