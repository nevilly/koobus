<?php
// KOO_BUS_ADAPT
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/RoutesController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
class Routes extends RoutesController {
    private $data; private $clean;
    public function __construct(){ parent::__construct(); $this->clean=new Util(); $this->data=parent::decode(file_get_contents("php://input")); }
    public function all(){ if($this->clean->Method()!=="GET") return array('status'=>403,'payload'=>"Unauthorized Access"); $res=parent::get(''); if($res) return array('status'=>200,'payload'=>$res); return array('status'=>204,'payload'=>http::message(204)); }
    public function get($params=''){ if($this->clean->Method()!=="GET") return array('status'=>403,'payload'=>"Unauthorized Access"); $p=parent::decode($params); $id=isset($p->page)?$p->page:''; $res=parent::get($id); if($res) return array('status'=>200,'payload'=>$res); return array('status'=>404,'payload'=>"Not found"); }
    public function by_school($params=''){ if($this->clean->Method()!=="GET") return array('status'=>403,'payload'=>"Unauthorized Access"); $p=parent::decode($params); $sid=isset($p->page)?$p->page:''; $res=parent::get_by_school($sid); if($res) return array('status'=>200,'payload'=>$res); return array('status'=>204,'payload'=>http::message(204)); }
    public function add(){ if($this->clean->Method()!=="POST") return array('status'=>403,'payload'=>"Unauthorized Access"); if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access"); $sql=parent::add($this->encode($this->data)); if($sql) return array('status'=>201,'payload'=>array('id'=>$sql)); return array('status'=>500,'payload'=>"Failed"); }
    public function update(){ if($this->clean->Method()!=="PUT") return array('status'=>403,'payload'=>"Unauthorized Access"); if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access"); $sql=parent::update_route($this->encode($this->data)); if($sql) return array('status'=>200,'payload'=>"Updated"); return array('status'=>500,'payload'=>"Failed"); }
    public function delete(){ if($this->clean->Method()!=="POST"&&$this->clean->Method()!=="DELETE") return array('status'=>403,'payload'=>"Unauthorized Access"); if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access"); $id=isset($this->data->id)?$this->data->id:''; $sql=parent::delete_route($id); if($sql) return array('status'=>200,'payload'=>"Deleted"); return array('status'=>500,'payload'=>"Failed"); }
}
