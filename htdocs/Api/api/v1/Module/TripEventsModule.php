<?php
// KOO_BUS_ADAPT: TripEvents module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class TripEventsModule extends Database
{
    private $table = "trip_events";

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

    public function get_by_trip($trip_id){
        if(empty($trip_id)) return false;
        $trip_id = intval($trip_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"trip_id='$trip_id' ORDER BY created_at ASC, id ASC"]));
    }

    public function get_by_child($child_id){
        if(empty($child_id)) return false;
        $child_id = intval($child_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"child_id='$child_id' ORDER BY created_at DESC"]));
    }

    public function get_by_trip_child($trip_id, $child_id){
        if(empty($trip_id) || empty($child_id)) return false;
        $trip_id = intval($trip_id);
        $child_id = intval($child_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"trip_id='$trip_id' AND child_id='$child_id'"]));
    }

    public function delete_event($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"id='$id'"]));
    }
}
