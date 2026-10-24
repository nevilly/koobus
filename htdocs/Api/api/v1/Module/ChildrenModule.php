<?php
// KOO_BUS_ADAPT: Children module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class ChildrenModule extends Database
{
    private $table = "children";

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

    public function update_child($data){
        $data = (array) parent::decode($data);
        $status = false;
        $d = '';
        if(count($data) > 0){
            foreach ($data as $key=>$value) {
                if($key !== 'id' && $value !== null && $value !== '')
                  $d .= "$key='".$this->con->real_escape_string($value)."',";
            }
            $d = chop($d,',');
            if(empty($d)) return false;
            $id = intval($data['id']);
            $status = parent::update(parent::encode(array("table"=>$this->table,"data"=>"$d","where"=>"id='$id'")));
        }
        return $status;
    }

    public function get($id = ''){
        $str = '';
        if(!empty($id)){
            if(is_numeric($id)) $str = "id=".intval($id);
        }
        return parent::select(parent::encode(['table'=>$this->table,'where'=>$str]));
    }

    public function get_by_school($school_id){
        if(empty($school_id)) return false;
        $school_id = intval($school_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"school_id='$school_id'"]));
    }

    public function get_by_route($route_id){
        if(empty($route_id)) return false;
        $route_id = intval($route_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"route_id='$route_id'"]));
    }

    public function delete_child($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"id='$id'"]));
    }
}
