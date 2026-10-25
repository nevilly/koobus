<?php
// KOO_BUS_ADAPT
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";
class RoutesModule extends Database {
    private $table = "routes";
    public function __construct(){ parent::__construct(); }
    public function add($data){
        $data = (array) $this->decode($data); $vs='';
        if(is_array($data)){ foreach($data as $k=>$v){ $vs .= "$k='".$this->con->real_escape_string($v)."',"; } $vs=chop($vs,','); }
        $sql = parent::insert($this->encode(['table'=>$this->table,'data'=>$vs]));
        return ($sql)?$this->con->insert_id:$sql;
    }
    public function update_route($data){
        $data=(array)parent::decode($data); $d=''; if(count($data)){ foreach($data as $k=>$v){ if($k!=='id' && !empty($v)) $d .= "$k='".$this->con->real_escape_string($v)."',"; } $d=chop($d,','); if(empty($d)) return false; $id=intval($data['id']); return parent::update(parent::encode(['table'=>$this->table,'data'=>$d,'where'=>"id='$id'"])); }
        return false;
    }
    public function get($id=''){ $str=''; if(!empty($id)&&is_numeric($id)) $str="id=".intval($id); return parent::select(parent::encode(['table'=>$this->table,'where'=>$str])); }
    public function get_by_school($school_id){ if(empty($school_id)) return false; $school_id=intval($school_id); return parent::select(parent::encode(['table'=>$this->table,'where'=>"school_id='$school_id'"])); }
    // KOO_BUS_ADAPT: vituo vya route kwa mpangilio wa safari.
    public function get_stops($route_id){
        if(empty($route_id)) return false;
        $route_id = intval($route_id);
        return parent::select(parent::encode(['table'=>'route_stops','where'=>"route_id='$route_id' ORDER BY stop_order ASC, id ASC"]));
    }
    public function delete_route($id){ if(empty($id)) return false; $id=intval($id); return parent::delete(parent::encode(['table'=>$this->table,'where'=>"id='$id'"])); }
}
