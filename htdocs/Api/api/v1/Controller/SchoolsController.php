<?php
// KOO_BUS_ADAPT: Schools controller
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/SchoolsModule.php";

class SchoolsController extends SchoolsModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){
        return parent::add($data);
    }

    public function update_school($data){
        return parent::update_school($data);
    }

    public function get($id = ''){
        $res = parent::get($id);
        $data = false;
        if($res && $res->num_rows > 0){
            if(!empty($id)) $data = $res->fetch_object();
            else $data = $res->fetch_all(MYSQLI_ASSOC);
        }
        return $data;
    }

    public function delete_school($id){
        return parent::delete_school($id);
    }
}
