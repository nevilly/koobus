<?php
// KOO_BUS_ADAPT: DeviceTokens module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class DeviceTokensModule extends Database
{
    private $table = "device_tokens";

    public function __construct()
    {
        parent::__construct();
    }

    public function register($data){
        $data = (array) $this->decode($data);
        $user_id = isset($data['user_id']) ? intval($data['user_id']) : 0;
        $token = isset($data['token']) ? $this->con->real_escape_string($data['token']) : '';
        $platform = isset($data['platform']) ? $this->con->real_escape_string($data['platform']) : 'android';
        if(empty($user_id) || empty($token)) return false;
        // try update if exists by token
        $check = $this->con->query("SELECT id FROM {$this->table} WHERE token='$token' LIMIT 1");
        if($check && $check->num_rows > 0){
            $row = $check->fetch_object();
            $now = date('Y-m-d H:i:s');
            return parent::update(parent::encode(array("table"=>$this->table,"data"=>"user_id='$user_id', platform='$platform', updated_at='$now'","where"=>"id='".$row->id."'")));
        }
        $vs = "user_id='$user_id', token='$token', platform='$platform'";
        return parent::insert($this->encode(['table'=>$this->table, 'data'=>$vs]));
    }

    public function get_by_user($user_id){
        if(empty($user_id)) return false;
        $user_id = intval($user_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"user_id='$user_id'"]));
    }

    public function remove_token($token){
        if(empty($token)) return false;
        $token = $this->con->real_escape_string($token);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"token='$token'"]));
    }

    public function remove_by_user($user_id){
        if(empty($user_id)) return false;
        $user_id = intval($user_id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"user_id='$user_id'"]));
    }
}
