<?php
// KOO_BUS_ADAPT: Routes routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/RoutesController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class Routes extends RoutesController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    private function roleOf($user)
    {
        return isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
    }

    /**
     * KOO_BUS_ADAPT: route_id za watoto wa mzazi aliyeingia.
     */
    private function parentRouteIds($parentId)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';

        $pcc = new ParentChildrenController();
        $links = $pcc->get_by_parent($parentId);
        $routeIds = array();

        if (is_array($links)) {
            foreach ($links as $l) {
                if (isset($l['child_id'])) {
                    $cc = new ChildrenController();
                    $c = $cc->get($l['child_id']);
                    if (is_object($c) && isset($c->route_id)) {
                        $routeIds[] = intval($c->route_id);
                    }
                }
            }
        }

        return array_values(array_unique($routeIds));
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $res = parent::get('');

        // KOO_BUS_ADAPT: mzazi anaona routes za watoto wake tu.
        if($this->roleOf($user) == 'parent' && isset($user->id)){
            $routeIds = $this->parentRouteIds($user->id);
            $filtered = array();
            if(is_array($res)){
                foreach($res as $r){
                    $rid = is_array($r) ? (isset($r['id'])?$r['id']:null) : (isset($r->id)?$r->id:null);
                    if($rid !== null && in_array(intval($rid), $routeIds)) $filtered[] = $r;
                }
            }
            return array('status'=>200,'payload'=>$filtered);
        }

        // KOO_BUS_ADAPT: staff anaona routes za shule yake tu.
        if(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            $filtered = array();
            if($scope > 0 && is_array($res)){
                foreach($res as $r){
                    $sid = is_array($r) ? (isset($r['school_id'])?$r['school_id']:null) : (isset($r->school_id)?$r->school_id:null);
                    if($sid !== null && intval($sid) === $scope) $filtered[] = $r;
                }
            }
            return array('status'=>200,'payload'=>$filtered);
        }

        if($res) return array('status'=>200,'payload'=>$res);
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

        if($this->roleOf($user) == 'parent' && isset($user->id)){
            $routeIds = $this->parentRouteIds($user->id);
            if(!in_array(intval($id), $routeIds)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        } elseif(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0 || Tenant::routeSchoolId($id) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get($id);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>404,'payload'=>"Not found");
    }

    /**
     * KOO_BUS_ADAPT: vituo vya route (route_stops) kwa dereva/mzazi.
     * URL: /api/v1/routes/stops/{route_id}
     */
    public function stops($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        if($id === '' || !is_numeric($id))
            return array('status'=>400,'payload'=>"route_id is required");

        if($this->roleOf($user) == 'parent' && isset($user->id)){
            $routeIds = $this->parentRouteIds($user->id);
            if(!in_array(intval($id), $routeIds)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        } elseif(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0 || Tenant::routeSchoolId($id) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_stops($id);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_school($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: wazazi hawatafuti routes za shule nzima.
        list($ok, $resUser) = AuthGuard::requireRole(array('driver','matron','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $p = parent::decode($params);
        $sid = isset($p->page) ? $p->page : '';

        if(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $sid = $scope;
        }

        $res = parent::get_by_school($sid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add(){
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

    public function update(){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        $id = isset($this->data->id) ? $this->data->id : '';
        $route = parent::get($id);
        if(!$route || !is_object($route))
            return array('status'=>404,'payload'=>"Not found");

        if(!Tenant::isSuperAdmin($resUser)){
            $scope = Tenant::schoolIdOfUser($resUser);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $routeSchool = isset($route->school_id) ? intval($route->school_id) : 0;
            if($routeSchool !== $scope) return array('status'=>403,'payload'=>"Forbidden");
            $this->data->school_id = $scope;
        }

        $sql = parent::update_route($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;

        $id = isset($this->data->id) ? $this->data->id : '';
        $route = parent::get($id);
        if(!$route || !is_object($route))
            return array('status'=>404,'payload'=>"Not found");

        if(!Tenant::isSuperAdmin($resUser)){
            $scope = Tenant::schoolIdOfUser($resUser);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $routeSchool = isset($route->school_id) ? intval($route->school_id) : 0;
            if($routeSchool !== $scope) return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::delete_route($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
