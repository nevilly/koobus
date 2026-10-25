<?php
// KOO_BUS_ADAPT: Schools routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/SchoolsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class Schools extends SchoolsController
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
        // KOO_BUS_ADAPT: taarifa za shule zinahitaji mtumiaji aliyeingia.
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $res = parent::get('');
        if($res){
            $status = 200; $data = $res;
        } else {
            $status = 204; $data = http::message(204);
        }
        return array('status'=>$status,'payload'=>$data);
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        $res = parent::get($id);
        if($res){
            $status = 200; $data = $res;
        } else {
            $status = 404; $data = "Not found";
        }
        return array('status'=>$status,'payload'=>$data);
    }

    public function add($data = ''){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kuunda shule mpya ni kazi ya super_admin pekee.
        list($ok, $resUser) = AuthGuard::requireRole(array('super_admin'));
        if(!$ok) return $resUser;
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function update($data = ''){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        $id = isset($this->data->id) ? $this->data->id : '';
        $school = parent::get($id);
        if(!$school || !is_object($school))
            return array('status'=>404,'payload'=>"Not found");

        // KOO_BUS_ADAPT: school_admin anabadilisha shule yake tu.
        if(!Tenant::isSuperAdmin($resUser) && !Tenant::canAccess($resUser, $id))
            return array('status'=>403,'payload'=>"Forbidden");

        $sql = parent::update_school($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete($data = ''){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kufuta shule ni kazi ya super_admin pekee.
        list($ok, $resUser) = AuthGuard::requireRole(array('super_admin'));
        if(!$ok) return $resUser;
        $id = isset($this->data->id) ? $this->data->id : '';
        $sql = parent::delete_school($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
