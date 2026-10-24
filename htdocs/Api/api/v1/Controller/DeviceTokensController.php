<?php
// KOO_BUS_ADAPT: DeviceTokens controller
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/DeviceTokensModule.php";

class DeviceTokensController extends DeviceTokensModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function register($data){ return parent::register($data); }
    public function get_by_user($user_id){ $res=parent::get_by_user($user_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function remove_token($token){ return parent::remove_token($token); }
    public function remove_by_user($user_id){ return parent::remove_by_user($user_id); }
}
