<?php
// KOO_BUS_ADAPT
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/BusesModule.php";
class BusesController extends BusesModule {
    public function __construct(){ parent::__construct(); }
    public function add($data){ return parent::add($data); }
    public function update_bus($data){ return parent::update_bus($data); }
    public function get($id=''){ $res=parent::get($id); $data=false; if($res&&$res->num_rows>0){ if(!empty($id)) $data=$res->fetch_object(); else $data=$res->fetch_all(MYSQLI_ASSOC); } return $data; }
    public function delete_bus($id){ return parent::delete_bus($id); }
}
