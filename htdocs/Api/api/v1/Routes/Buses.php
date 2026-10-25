<?php
// KOO_BUS_ADAPT: Buses routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/BusesController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class Buses extends BusesController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    private function roleOf($user){
        return isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $res = parent::get('');

        // KOO_BUS_ADAPT: kila mtumiaji aliye na shule anaona buses za shule yake.
        // super_admin anaona zote.
        if(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            $filtered = array();
            if($scope > 0 && is_array($res)){
                foreach($res as $b){
                    $sid = is_array($b) ? (isset($b['school_id'])?$b['school_id']:null) : (isset($b->school_id)?$b->school_id:null);
                    if($sid !== null && intval($sid) === $scope) $filtered[] = $b;
                }
            }
            $res = $filtered;
        }

        if($res){ return array('status'=>200,'payload'=>$res); }
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        $res = parent::get($id);

        if($res && !Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            $sid = is_object($res) && isset($res->school_id) ? intval($res->school_id) : 0;
            if($scope <= 0 || $sid !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>404,'payload'=>"Not found");
    }

    public function add($data = ''){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        if(!Tenant::isSuperAdmin($resUser)){
            $scope = Tenant::schoolIdOfUser($resUser);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $this->data->school_id = $scope;
        } else {
            $sid = isset($this->data->school_id) ? intval($this->data->school_id) : 0;
            if($sid <= 0) return array('status'=>400,'payload'=>"school_id is required");
            if(!Tenant::schoolExists($sid)) return array('status'=>400,'payload'=>"Invalid school");
            $this->data->school_id = $sid;
        }

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
        $bus = parent::get($id);
        if(!$bus || !is_object($bus))
            return array('status'=>404,'payload'=>"Not found");

        if(!Tenant::isSuperAdmin($resUser)){
            $scope = Tenant::schoolIdOfUser($resUser);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $busSchool = isset($bus->school_id) ? intval($bus->school_id) : 0;
            if($busSchool !== $scope) return array('status'=>403,'payload'=>"Forbidden");
            $this->data->school_id = $scope;
        }

        $sql = parent::update_bus($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete($data = ''){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;

        $id = isset($this->data->id) ? $this->data->id : '';
        $bus = parent::get($id);
        if(!$bus || !is_object($bus))
            return array('status'=>404,'payload'=>"Not found");

        if(!Tenant::isSuperAdmin($resUser)){
            $scope = Tenant::schoolIdOfUser($resUser);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $busSchool = isset($bus->school_id) ? intval($bus->school_id) : 0;
            if($busSchool !== $scope) return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::delete_bus($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
