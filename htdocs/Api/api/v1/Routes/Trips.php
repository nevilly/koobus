<?php
// KOO_BUS_ADAPT: Trips routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";

class Trips extends TripsController
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
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
            $pcc = new ParentChildrenController();
            $links = $pcc->get_by_parent($user->id);
            $routeIds = array();
            if(is_array($links)){
                foreach($links as $l){
                    if(isset($l->child_id)){
                        $cc = new ChildrenController();
                        $c = $cc->get($l->child_id);
                        if($c){
                            if(is_array($c)){
                                foreach($c as $child){
                                    if(isset($child->route_id)) $routeIds[] = intval($child->route_id);
                                }
                            } elseif(is_object($c)){
                                if(isset($c->route_id)) $routeIds[] = intval($c->route_id);
                            }
                        }
                    }
                }
            }
            $routeIds = array_values(array_unique($routeIds));
            if(empty($routeIds)){
                return array('status'=>200,'payload'=>array());
            }
            $all = parent::get('');
            if($all && is_array($all)){
                $filtered = array();
                foreach($all as $t){
                    if(isset($t->route_id) && in_array(intval($t->route_id), $routeIds)){
                        $filtered[] = $t;
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
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
            $pcc = new ParentChildrenController();
            $links = $pcc->get_by_parent($user->id);
            $routeIds = array();
            if(is_array($links)){
                foreach($links as $l){
                    if(isset($l->child_id)){
                        $cc = new ChildrenController();
                        $c = $cc->get($l->child_id);
                        if($c){
                            if(is_array($c)){
                                foreach($c as $child){
                                    if(isset($child->route_id)) $routeIds[] = intval($child->route_id);
                                }
                            } elseif(is_object($c)){
                                if(isset($c->route_id)) $routeIds[] = intval($c->route_id);
                            }
                        }
                    }
                }
            }
            $routeIds = array_values(array_unique($routeIds));
            $trip = parent::get($id);
            if($trip){
                if(is_object($trip)){
                    if(isset($trip->route_id) && !in_array(intval($trip->route_id), $routeIds)){
                        return array('status'=>403,'payload'=>"Forbidden");
                    }
                    return array('status'=>200,'payload'=>$trip);
                } elseif(is_array($trip)){
                    $filtered = array();
                    foreach($trip as $t){
                        if(isset($t->route_id) && in_array(intval($t->route_id), $routeIds)){
                            $filtered[] = $t;
                        }
                    }
                    if(empty($filtered)) return array('status'=>403,'payload'=>"Forbidden");
                    return array('status'=>200,'payload'=>$filtered);
                }
            }
            return array('status'=>404,'payload'=>"Not found");
        }
        $res = parent::get($id);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>404,'payload'=>"Not found");
    }

    public function by_driver($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $did = isset($p->page) ? $p->page : '';
        $res = parent::get_by_driver($did);
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

    public function active_by_driver($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $did = isset($p->page) ? $p->page : '';
        $res = parent::get_active_by_driver($did);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function active(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        $res = parent::get_active();
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','matron','school_admin','super_admin'));
        if(!$ok) return $res;
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function update(){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','matron','school_admin','super_admin'));
        if(!$ok) return $res;
        $sql = parent::update_trip($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function start(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $res;
        $user = $res;
        $id = isset($this->data->trip_id) ? $this->data->trip_id : (isset($this->data->id) ? $this->data->id : '');
        // KOO_BUS_ADAPT: ruhusu driver kuanza trip yake tu
        if(isset($user->id) && isset($user->role) && $user->role == 'driver'){
            $trip = parent::get($id);
            if($trip && $trip->num_rows > 0){
                $t = $trip->fetch_object();
                if(isset($t->driver_id) && intval($t->driver_id) != intval($user->id)){
                    return array('status'=>403,'payload'=>"Forbidden");
                }
            }
        }
        $sql = parent::start_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Trip started");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function end(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $res;
        $user = $res;
        $id = isset($this->data->trip_id) ? $this->data->trip_id : (isset($this->data->id) ? $this->data->id : '');
        if(isset($user->id) && isset($user->role) && $user->role == 'driver'){
            $trip = parent::get($id);
            if($trip && $trip->num_rows > 0){
                $t = $trip->fetch_object();
                if(isset($t->driver_id) && intval($t->driver_id) != intval($user->id)){
                    return array('status'=>403,'payload'=>"Forbidden");
                }
            }
        }
        $sql = parent::end_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Trip completed");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function cancel(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $res;
        $user = $res;
        $id = isset($this->data->trip_id) ? $this->data->trip_id : (isset($this->data->id) ? $this->data->id : '');
        if(isset($user->id) && isset($user->role) && $user->role == 'driver'){
            $trip = parent::get($id);
            if($trip && $trip->num_rows > 0){
                $t = $trip->fetch_object();
                if(isset($t->driver_id) && intval($t->driver_id) != intval($user->id)){
                    return array('status'=>403,'payload'=>"Forbidden");
                }
            }
        }
        $sql = parent::cancel_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Trip cancelled");
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete(){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $id = isset($this->data->id) ? $this->data->id : '';
        $sql = parent::delete_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
