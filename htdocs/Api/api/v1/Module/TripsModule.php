<?php
// KOO_BUS_ADAPT: Trips module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class TripsModule extends Database
{
    private $table = "trips";

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
                // allow datetime strings as-is
                $vs .= "$key='".$this->con->real_escape_string($value)."',";
            }
            $vs = chop($vs, ',');
        }
        if(empty($vs)) return false;
        $sql = parent::insert($this->encode(['table'=>$this->table, 'data'=>$vs]));
        return ($sql) ? $this->con->insert_id : $sql;
    }

    public function update_trip($data){
        $data = (array) parent::decode($data);
        $d = '';
        if(count($data) > 0){
            foreach ($data as $key=>$value) {
                if($key !== 'id' && $value !== null && $value !== ''){
                    $d .= "$key='".$this->con->real_escape_string($value)."',";
                }
            }
            $d = chop($d,',');
            if(empty($d)) return false;
            $id = intval($data['id']);
            $status = parent::update(parent::encode(array("table"=>$this->table,"data"=>"$d","where"=>"id='$id'")));
            return $status;
        }
        return false;
    }

    public function get($id = ''){
        $str = '';
        if(!empty($id)){
            if(is_numeric($id)) $str = "id=".intval($id);
        }
        return parent::select(parent::encode(['table'=>$this->table,'where'=>$str]));
    }

    public function get_by_driver($driver_id){
        if(empty($driver_id)) return false;
        $driver_id = intval($driver_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"driver_id='$driver_id' ORDER BY id DESC"]));
    }

    public function get_by_route($route_id){
        if(empty($route_id)) return false;
        $route_id = intval($route_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"route_id='$route_id' ORDER BY id DESC"]));
    }

    public function get_active_by_driver($driver_id){
        if(empty($driver_id)) return false;
        $driver_id = intval($driver_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"driver_id='$driver_id' AND status='active'"]));
    }

    public function get_active(){
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"status='active' ORDER BY started_at DESC"]));
    }

    public function start_trip($id){
        if(empty($id)) return false;
        $id = intval($id);
        $now = date('Y-m-d H:i:s');
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>"status='active', started_at='$now'","where"=>"id='$id' AND status='pending'")));
    }

    public function end_trip($id){
        if(empty($id)) return false;
        $id = intval($id);
        $now = date('Y-m-d H:i:s');
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>"status='completed', ended_at='$now'","where"=>"id='$id' AND status='active'")));
    }

    public function cancel_trip($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>"status='cancelled'","where"=>"id='$id'")));
    }

    public function delete_trip($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"id='$id'"]));
    }
}
