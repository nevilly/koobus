<?php
// KOO_BUS_ADAPT: Children routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";

class Children extends ChildrenController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
        if($role == 'parent' && isset($user->id)){
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
            $pcc = new ParentChildrenController();
            $links = $pcc->get_by_parent($user->id);
            $childIds = array();
            if(is_array($links)){
                foreach($links as $l){
                    if(isset($l->child_id)) $childIds[] = intval($l->child_id);
                }
            }
            if(empty($childIds)){
                return array('status'=>200,'payload'=>array());
            }
            $all = parent::get('');
            if($all && is_array($all)){
                $filtered = array();
                foreach($all as $c){
                    if(isset($c->id) && in_array(intval($c->id), $childIds)){
                        $filtered[] = $c;
                    }
                }
                return array('status'=>200,'payload'=>$filtered);
            }
            return array('status'=>200,'payload'=>array());
        }
        $res = parent::get('');
        if($res){ return array('status'=>200,'payload'=>$res); }
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        if($role == 'parent' && isset($user->id) && $id !== ''){
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
            $pcc = new ParentChildrenController();
            $links = $pcc->get_by_parent($user->id);
            $childIds = array();
            if(is_array($links)){
                foreach($links as $l){
                    if(isset($l->child_id)) $childIds[] = intval($l->child_id);
                }
            }
            if(!in_array(intval($id), $childIds)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }
        $res = parent::get($id);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>404,'payload'=>"Not found");
    }

    public function by_school($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $sid = isset($p->page) ? $p->page : '';
        $res = parent::get_by_school($sid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_route($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $rid = isset($p->page) ? $p->page : '';
        $res = parent::get_by_route($rid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $res;
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function update(){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $res;
        $sql = parent::update_child($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->id) ? $this->data->id : '';
        $sql = parent::delete_child($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
