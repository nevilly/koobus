<?php
// KOO_BUS_ADAPT: DeviceTokens routes (FCM push tokens)
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/DeviceTokensController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class DeviceTokens extends DeviceTokensController
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

    public function register(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $user) = AuthGuard::requireAny();
        if(!$ok) return $user;

        if(!is_object($this->data))
            return array('status'=>400,'payload'=>"Invalid data");

        // KOO_BUS_ADAPT: token ya kifaa inahusishwa na mtumiaji aliyeingia,
        // si `user_id` inayotumwa kwenye body.
        $this->data->user_id = $user->id;

        $sql = parent::register($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Registered");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function by_user($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $user) = AuthGuard::requireAny();
        if(!$ok) return $user;
        $role = $this->roleOf($user);

        $p = parent::decode($params);
        $uid = isset($p->page) ? $p->page : '';

        // Mtumiaji wa kawaida anaona tokens zake tu; admin anaweza yoyote.
        if(!in_array($role, array('school_admin','super_admin'))){
            $uid = $user->id;
        }

        // KOO_BUS_ADAPT: school_admin anaona tokens za watumiaji wa shule yake tu.
        if($role === 'school_admin'){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            if(Tenant::userSchoolId($uid) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_by_user($uid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function remove(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $user) = AuthGuard::requireAny();
        if(!$ok) return $user;
        $role = $this->roleOf($user);

        $token = isset($this->data->token) ? $this->data->token : '';
        if($token === '') return array('status'=>403,'payload'=>"Forbidden");

        // Isipokuwa super_admin, mtumiaji anaweza kuondoa token yake tu.
        // school_admin anatumia remove_by_user (iliyolindwa kwa shule) kwa watumiaji wengine.
        if($role !== 'super_admin'){
            $mine = parent::get_by_user($user->id);
            $owned = false;
            if(is_array($mine)){
                foreach($mine as $row){
                    $t = is_array($row) ? (isset($row['token'])?$row['token']:null) : (isset($row->token)?$row->token:null);
                    if($t !== null && $t === $token){ $owned = true; break; }
                }
            }
            if(!$owned) return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::remove_token($token);
        if($sql) return array('status'=>200,'payload'=>"Removed");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function remove_by_user(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $user) = AuthGuard::requireAny();
        if(!$ok) return $user;
        $role = $this->roleOf($user);

        $uid = isset($this->data->user_id) ? $this->data->user_id : '';
        if(!in_array($role, array('school_admin','super_admin'))){
            $uid = $user->id;
        }

        // KOO_BUS_ADAPT: school_admin anafuta tokens za watumiaji wa shule yake tu.
        if($role === 'school_admin'){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            if(Tenant::userSchoolId($uid) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::remove_by_user($uid);
        if($sql) return array('status'=>200,'payload'=>"Removed");
        return array('status'=>500,'payload'=>"Failed");
    }
}
