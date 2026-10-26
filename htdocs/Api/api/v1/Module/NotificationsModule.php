<?php
// KOO_BUS_ADAPT: Notifications module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class NotificationsModule extends Database
{
    private $table = "notifications";

    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){
        $data = (array) $this->decode($data);
        $vs = '';
        if(is_array($data)){
            foreach ($data as $key => $value) {
                if($value === null || $value === '') continue;
                $vs .= "$key='".$this->con->real_escape_string($value)."',";
            }
            $vs = chop($vs, ',');
        }
        if(empty($vs)) return false;
        $sql = parent::insert($this->encode(['table'=>$this->table, 'data'=>$vs]));
        return ($sql) ? $this->con->insert_id : $sql;
    }

    public function get($id = ''){
        $str = '';
        if(!empty($id)){
            if(is_numeric($id)) $str = "id=".intval($id);
        }
        return parent::select(parent::encode(['table'=>$this->table,'where'=>$str]));
    }

    public function get_by_user($user_id, $limit=50){
        if(empty($user_id)) return false;
        $user_id = intval($user_id);
        $limit = intval($limit);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"user_id='$user_id' ORDER BY id DESC LIMIT $limit"]));
    }

    public function get_unread_by_user($user_id){
        if(empty($user_id)) return false;
        $user_id = intval($user_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"user_id='$user_id' AND read_at IS NULL ORDER BY id DESC"]));
    }

    public function mark_read($id, $user_id=''){
        if(empty($id)) return false;
        $id = intval($id);
        $now = date('Y-m-d H:i:s');
        $where = "id='$id'";
        if(!empty($user_id)){
            $where .= " AND user_id='".intval($user_id)."'";
        }
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>"read_at='$now'","where"=>$where)));
    }

    public function mark_all_read($user_id){
        if(empty($user_id)) return false;
        $user_id = intval($user_id);
        $now = date('Y-m-d H:i:s');
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>"read_at='$now'","where"=>"user_id='$user_id' AND read_at IS NULL")));
    }

    public function delete_notification($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"id='$id'"]));
    }
}
