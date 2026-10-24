<?php
// KOO_BUS_ADAPT: Notifications controller
include_once$_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/NotificationsModule.php";

class NotificationsController extends NotificationsModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){ return parent::add($data); }
    public function get($id = ''){
        $res = parent::get($id);
        $data = false;
        if($res && $res->num_rows > 0){
            if(!empty($id)) $data = $res->fetch_object();
            else $data = $res->fetch_all(MYSQLI_ASSOC);
        }
        return $data;
    }
    public function get_by_user($user_id, $limit=50){ $res=parent::get_by_user($user_id, $limit); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function get_unread_by_user($user_id){ $res=parent::get_unread_by_user($user_id); if($res&&$res->num_rows>0) return $res->fetch_all(MYSQLI_ASSOC); return false; }
    public function mark_read($id, $user_id=''){ return parent::mark_read($id, $user_id); }
    public function mark_all_read($user_id){ return parent::mark_all_read($user_id); }
    public function delete_notification($id){ return parent::delete_notification($id); }
}
