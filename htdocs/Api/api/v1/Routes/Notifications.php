<?php
// KOO_BUS_ADAPT: Notifications routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/NotificationsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class Notifications extends NotificationsController
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

    private function isAdmin($user)
    {
        return in_array($this->roleOf($user), array('school_admin','super_admin'));
    }

    /**
     * KOO_BUS_ADAPT: school_admin anaweza kugusa taarifa za watumiaji wa shule yake tu.
     */
    private function userInAdminScope($user, $targetUid)
    {
        if (Tenant::isSuperAdmin($user)) return true;
        $scope = Tenant::schoolIdOfUser($user);
        return $scope > 0 && $targetUid !== '' && Tenant::userSchoolId($targetUid) === $scope;
    }

    private function notificationUserId($id)
    {
        $n = parent::get($id);
        return ($n && is_object($n) && isset($n->user_id)) ? intval($n->user_id) : 0;
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: orodha yote ya notifications ni ya admin pekee.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;

        $res = parent::get('');

        // KOO_BUS_ADAPT: school_admin anaona notifications za shule yake tu.
        if(!Tenant::isSuperAdmin($resUser)){
            $scope = Tenant::schoolIdOfUser($resUser);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            $filtered = array();
            if(is_array($res)){
                foreach($res as $n){
                    $uid = is_array($n) ? (isset($n['user_id'])?$n['user_id']:null) : (isset($n->user_id)?$n->user_id:null);
                    if($uid !== null && Tenant::userSchoolId($uid) === $scope) $filtered[] = $n;
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
        // KOO_BUS_ADAPT: mtumiaji anaona notifications zake kupitia by_user.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        $res = parent::get($id);

        if($res && !Tenant::isSuperAdmin($resUser)){
            $uid = is_object($res) && isset($res->user_id) ? $res->user_id : 0;
            if(!$this->userInAdminScope($resUser, $uid))
                return array('status'=>403,'payload'=>"Forbidden");
        }

        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>404,'payload'=>"Not found");
    }

    public function by_user($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $p = parent::decode($params);
        $uid = isset($p->page) ? $p->page : '';
        $limit = isset($p->page1) ? intval($p->page1) : 50;

        // KOO_BUS_ADAPT: mtumiaji wa kawaida anaona zake tu.
        if(!$this->isAdmin($user)){
            $uid = $user->id;
        } elseif(!$this->userInAdminScope($user, $uid)){
            return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_by_user($uid, $limit);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function unread($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $p = parent::decode($params);
        $uid = isset($p->page) ? $p->page : '';

        if(!$this->isAdmin($user)){
            $uid = $user->id;
        } elseif(!$this->userInAdminScope($user, $uid)){
            return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_unread_by_user($uid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kutuma notification ni kazi ya admin.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        $targetUid = isset($this->data->user_id) ? $this->data->user_id : '';
        if($targetUid === '') return array('status'=>400,'payload'=>"user_id is required");

        // KOO_BUS_ADAPT: school_admin anatuma kwa watumiaji wa shule yake tu.
        if(!$this->userInAdminScope($resUser, $targetUid))
            return array('status'=>403,'payload'=>"Forbidden");

        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function mark_read(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $id = isset($this->data->id) ? $this->data->id : '';
        $uid = isset($this->data->user_id) ? $this->data->user_id : '';

        // KOO_BUS_ADAPT: mtu anaweza ku-mark notification yake tu.
        // Hii pia inazuia ku-mark notification ya mtu mwingine.
        if(!$this->isAdmin($user)){
            $uid = $user->id;
        } elseif(!Tenant::isSuperAdmin($user)){
            // school_admin: notification lazima iwe ya mtumiaji wa shule yake.
            $ownerUid = $this->notificationUserId($id);
            if($ownerUid <= 0 || !$this->userInAdminScope($user, $ownerUid))
                return array('status'=>403,'payload'=>"Forbidden");
            $uid = $ownerUid;
        }

        $sql = parent::mark_read($id, $uid);
        if($sql) return array('status'=>200,'payload'=>"Marked read");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function mark_all_read(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $uid = isset($this->data->user_id) ? $this->data->user_id : '';

        if(!$this->isAdmin($user)){
            $uid = $user->id;
        } elseif(!$this->userInAdminScope($user, $uid)){
            return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::mark_all_read($uid);
        if($sql) return array('status'=>200,'payload'=>"All marked read");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kufuta notification ni kazi ya admin.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        $id = isset($this->data->id) ? $this->data->id : '';

        // KOO_BUS_ADAPT: school_admin anafuta notifications za shule yake tu.
        if(!Tenant::isSuperAdmin($resUser)){
            $ownerUid = $this->notificationUserId($id);
            if($ownerUid <= 0 || !$this->userInAdminScope($resUser, $ownerUid))
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::delete_notification($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
