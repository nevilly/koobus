<?php
// KOO_BUS_ADAPT: Schools module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class SchoolsModule extends Database
{
    private $table = "schools";

    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){
        $data = (array) $this->decode($data);
        $vs = '';
        if(is_array($data)){
            foreach ($data as $key => $value) {
                $vs .= "$key='".$this->con->real_escape_string($value)."',";
            }
            $vs = chop($vs, ',');
        }
        $sql = parent::insert($this->encode(['table'=>$this->table, 'data'=>$vs]));
        return ($sql) ? $this->con->insert_id : $sql;
    }

    public function update_school($data){
        $data = (array) parent::decode($data);
        $status = false;
        $d = '';
        if(count($data) > 0){
            foreach ($data as $key=>$value) {
                if($key !== 'id' && !empty($value))
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

    public function delete_school($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"id='$id'"]));
    }
}
