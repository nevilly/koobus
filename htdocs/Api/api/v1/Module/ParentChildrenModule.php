<?php
// KOO_BUS_ADAPT: ParentChildren module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class ParentChildrenModule extends Database
{
    private $table = "parent_children";

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

    public function update_link($data){
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

    public function get_by_parent($parent_id){
        if(empty($parent_id)) return false;
        $parent_id = intval($parent_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"parent_id='$parent_id'"]));
    }

    public function get_by_child($child_id){
        if(empty($child_id)) return false;
        $child_id = intval($child_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"child_id='$child_id'"]));
    }

    public function unlink($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"id='$id'"]));
    }

    public function unlink_by_pair($parent_id, $child_id){
        if(empty($parent_id) || empty($child_id)) return false;
        $parent_id = intval($parent_id);
        $child_id = intval($child_id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"parent_id='$parent_id' AND child_id='$child_id'"]));
    }
}
