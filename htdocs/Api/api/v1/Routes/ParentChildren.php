<?php
// KOO_BUS_ADAPT: ParentChildren routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class ParentChildren extends ParentChildrenController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    /**
     * KOO_BUS_ADAPT: msaidizi wa school scoping kwa admin.
     * Inarudisha school_id ya admin, au 0 kwa super_admin (bila kikomo).
     */
    private function adminScope($user)
    {
        if (Tenant::isSuperAdmin($user)) return 0;
        return Tenant::schoolIdOfUser($user);
    }

    /**
     * KOO_BUS_ADAPT: chuja mahusiano kwa shule ya mtoto.
     */
    private function filterLinksBySchool($links, $schoolId)
    {
        $out = array();
        if (is_array($links)) {
            foreach ($links as $l) {
                $childId = is_array($l) ? (isset($l['child_id'])?$l['child_id']:null) : (isset($l->child_id)?$l->child_id:null);
                if ($childId !== null && Tenant::childSchoolId($childId) === $schoolId) {
                    $out[] = $l;
                }
            }
        }
        return $out;
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: orodha yote ya mahusiano ni ya admin pekee.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser) && $scope <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        $res = parent::get('');
        if(!$res) return array('status'=>204,'payload'=>http::message(204));
        if($scope > 0) $res = $this->filterLinksBySchool($res, $scope);
        return array('status'=>200,'payload'=>$res);
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser) && $scope <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        $res = parent::get($id);
        if(!$res) return array('status'=>404,'payload'=>"Not found");

        if($scope > 0 && is_object($res) && isset($res->child_id)
            && Tenant::childSchoolId($res->child_id) !== $scope)
            return array('status'=>403,'payload'=>"Forbidden");

        return array('status'=>200,'payload'=>$res);
    }

    public function by_parent($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('parent','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');

        $p = parent::decode($params);
        $pid = isset($p->page) ? $p->page : '';

        // KOO_BUS_ADAPT: mzazi anaweza kuona mahusiano yake mwenyewe tu.
        if($role == 'parent' && isset($user->id)){
            $pid = $user->id;
        }

        $res = parent::get_by_parent($pid);

        // KOO_BUS_ADAPT: school_admin anaona mahusiano ya shule yake tu.
        if($role == 'school_admin' && $res){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $res = $this->filterLinksBySchool($res, $scope);
        }

        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_child($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: mahusiano ya mzazi/mtoto ni ya mzazi mwenyewe au admin.
        list($ok, $resUser) = AuthGuard::requireRole(array('parent','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');

        $p = parent::decode($params);
        $cid = isset($p->page) ? $p->page : '';

        if($role == 'parent' && isset($user->id)){
            // Mzazi anaweza kuuliza tu kuhusu mtoto aliyefungwa naye.
            $mine = parent::get_by_child($cid);
            $allowed = false;
            if(is_array($mine)){
                foreach($mine as $link){
                    $lpid = is_array($link) ? (isset($link['parent_id'])?$link['parent_id']:null) : (isset($link->parent_id)?$link->parent_id:null);
                    if($lpid !== null && intval($lpid) === intval($user->id)) $allowed = true;
                }
            }
            if(!$allowed) return array('status'=>403,'payload'=>"Forbidden");
        }

        if($role == 'school_admin'){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            if(Tenant::childSchoolId($cid) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_by_child($cid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add($data = ''){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser) && $scope <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        $cid = isset($this->data->child_id) ? $this->data->child_id : '';
        $pid = isset($this->data->parent_id) ? $this->data->parent_id : '';
        if($cid === '' || $pid === '')
            return array('status'=>400,'payload'=>"parent_id and child_id are required");

        // KOO_BUS_ADAPT: admin anaweza kuunganisha watoto wa shule yake tu.
        if($scope > 0){
            if(Tenant::childSchoolId($cid) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");

            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/UsersController.php';
            $uc = new UsersController();
            $parent = $uc->get($pid);
            if(!$parent || !is_object($parent) || !isset($parent->role) || $parent->role !== 'parent')
                return array('status'=>403,'payload'=>"Forbidden");

            // Mzazi asiye na shule bado hajazungwa; tunaweza kumfungamanisha.
            $parentSchool = Tenant::userSchoolId($pid);
            if($parentSchool > 0 && $parentSchool !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
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
        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser) && $scope <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        $id = isset($this->data->id) ? $this->data->id : '';
        $link = parent::get($id);
        if(!$link || !is_object($link))
            return array('status'=>404,'payload'=>"Not found");

        if($scope > 0){
            if(Tenant::parentChildSchoolId($id) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
            if(isset($this->data->child_id) && $this->data->child_id !== ''
                && Tenant::childSchoolId($this->data->child_id) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::update_link($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function unlink(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser) && $scope <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        $id = isset($this->data->id) ? $this->data->id : '';
        if($scope > 0 && Tenant::parentChildSchoolId($id) !== $scope)
            return array('status'=>403,'payload'=>"Forbidden");

        $sql = parent::unlink($id);
        if($sql) return array('status'=>200,'payload'=>"Unlinked");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function unlink_pair(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $scope = $this->adminScope($resUser);
        if(!Tenant::isSuperAdmin($resUser) && $scope <= 0)
            return array('status'=>403,'payload'=>"No school assigned to your account");

        $pid = isset($this->data->parent_id) ? $this->data->parent_id : '';
        $cid = isset($this->data->child_id) ? $this->data->child_id : '';
        if($scope > 0 && Tenant::childSchoolId($cid) !== $scope)
            return array('status'=>403,'payload'=>"Forbidden");

        $sql = parent::unlink_by_pair($pid, $cid);
        if($sql) return array('status'=>200,'payload'=>"Unlinked");
        return array('status'=>500,'payload'=>"Failed");
    }
}
