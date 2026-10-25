<?php
// KOO_BUS_ADAPT: Children routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class Children extends ChildrenController
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

    private function adminScope($user){
        if(Tenant::isSuperAdmin($user)) return 0;
        return Tenant::schoolIdOfUser($user);
    }

    /**
     * KOO_BUS_ADAPT: chuja watoto kwa shule.
     */
    private function filterBySchool($rows, $schoolId){
        $out = array();
        if(is_array($rows)){
            foreach($rows as $r){
                $sid = is_array($r) ? (isset($r['school_id'])?$r['school_id']:null) : (isset($r->school_id)?$r->school_id:null);
                if($sid !== null && intval($sid) === intval($schoolId)) $out[] = $r;
            }
        }
        return $out;
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
        if($role == 'parent' && isset($user->id)){
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
            $pcc = new ParentChildrenController();
            $links = $pcc->get_by_parent($user->id);
            $childIds = array();
            if(is_array($links)){
                foreach($links as $l){
                    if(isset($l['child_id'])) $childIds[] = intval($l['child_id']);
                }
            }
            if(empty($childIds)){
                return array('status'=>200,'payload'=>array());
            }
            $all = parent::get('');
            if($all && is_array($all)){
                $filtered = array();
                foreach($all as $c){
                    // get('') inarudisha arrays (fetch_all MYSQLI_ASSOC).
                    $cid = is_array($c) ? (isset($c['id'])?$c['id']:null) : (isset($c->id)?$c->id:null);
                    if($cid !== null && in_array(intval($cid), $childIds)){
                        $filtered[] = $c;
                    }
                }
                return array('status'=>200,'payload'=>$filtered);
            }
            return array('status'=>200,'payload'=>array());
        }
        $res = parent::get('');

        // KOO_BUS_ADAPT: wafanyakazi wa shule wanaona watoto wa shule yao tu.
        // (super_admin anaona wote)
        if(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $res = $this->filterBySchool($res, $scope);
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
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';

        // KOO_BUS_ADAPT: get() inahitaji id. Bila id -> tumia all().
        // Hii inazuia kurudisha watoto wote kwa mzazi/staff asiye na id.
        if($id === '') return array('status'=>403,'payload'=>"Forbidden");

        if($role == 'parent' && isset($user->id)){
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
            $pcc = new ParentChildrenController();
            $links = $pcc->get_by_parent($user->id);
            $childIds = array();
            if(is_array($links)){
                foreach($links as $l){
                    if(isset($l['child_id'])) $childIds[] = intval($l['child_id']);
                }
            }
            if(!in_array(intval($id), $childIds)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }
        $res = parent::get($id);

        // KOO_BUS_ADAPT: mtoto wa shule nyingine haonekani kwa staff wa shule hii.
        if($res && !Tenant::isSuperAdmin($user) && $role !== 'parent' && $id !== ''){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $childSchool = is_object($res) && isset($res->school_id) ? intval($res->school_id) : 0;
            if($childSchool !== $scope) return array('status'=>403,'payload'=>"Forbidden");
        }

        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>404,'payload'=>"Not found");
    }

    public function by_school($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: wazazi hawaorodheshi watoto wa shule nzima.
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

    public function by_route($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: wazazi wanapata watoto wao kupitia all()/get().
        list($ok, $resUser) = AuthGuard::requireRole(array('driver','matron','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $p = parent::decode($params);
        $rid = isset($p->page) ? $p->page : '';

        if(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            if(Tenant::routeSchoolId($rid) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_by_route($rid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $scope = $this->adminScope($resUser);

        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        if(!Tenant::isSuperAdmin($resUser)){
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            // school_admin hawezi kuweka mtoto kwenye shule nyingine.
            $this->data->school_id = $scope;
        }

        $schoolId = isset($this->data->school_id) ? intval($this->data->school_id) : 0;
        if($schoolId <= 0) return array('status'=>400,'payload'=>"school_id is required");
        if(!Tenant::schoolExists($schoolId)) return array('status'=>400,'payload'=>"Invalid school");

        // Route (kama ipo) lazima iwe ya shule hiyo hiyo.
        if(isset($this->data->route_id) && $this->data->route_id !== ''){
            if(Tenant::routeSchoolId($this->data->route_id) !== $schoolId)
                return array('status'=>403,'payload'=>"Forbidden");
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
        $child = parent::get($id);
        if(!$child || !is_object($child))
            return array('status'=>404,'payload'=>"Not found");

        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser)){
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $childSchool = isset($child->school_id) ? intval($child->school_id) : 0;
            if($childSchool !== $scope) return array('status'=>403,'payload'=>"Forbidden");
            // school_admin hawezi kuhamisha mtoto kwenda shule nyingine.
            if(isset($this->data->school_id)) $this->data->school_id = $scope;
        }

        if(isset($this->data->route_id) && $this->data->route_id !== ''){
            $schoolId = isset($this->data->school_id) ? intval($this->data->school_id)
                : (isset($child->school_id) ? intval($child->school_id) : 0);
            if(Tenant::routeSchoolId($this->data->route_id) !== $schoolId)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::update_child($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kufuta mtoto ni kazi ya admin.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;

        $id = isset($this->data->id) ? $this->data->id : '';
        $child = parent::get($id);
        if(!$child || !is_object($child))
            return array('status'=>404,'payload'=>"Not found");

        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser)){
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $childSchool = isset($child->school_id) ? intval($child->school_id) : 0;
            if($childSchool !== $scope) return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::delete_child($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
