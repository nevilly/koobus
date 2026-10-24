<?php
// KOO_BUS_ADAPT: Locations routes (GPS)
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/LocationsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";

class Locations extends LocationsController
{
    private $data;
    private $clean;

    public function __construct()
    {
        parent::__construct();
        $this->clean = new Util();
        $this->data = parent::decode(file_get_contents("php://input"));
    }

    public function upload(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $res;
        $user = $res;
        // KOO_BUS_ADAPT: driver anaweza kupakia location ya trip yake
        if(isset($user->id) && isset($user->role) && $user->role == 'driver' && isset($this->data->trip_id)){
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
            $tc = new TripsController();
            $trip = $tc->get($this->data->trip_id);
            if($trip && is_object($trip)){
                if(isset($trip->driver_id) && intval($trip->driver_id) != intval($user->id)){
                    return array('status'=>403,'payload'=>"Forbidden");
                }
            }
        }
        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function latest($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : (isset($this->data->trip_id)?$this->data->trip_id:'');
        if($role == 'parent' && isset($user->id) && $tid !== ''){
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
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
            $tc = new TripsController();
            $trip = $tc->get($tid);
            if($trip){
                if(is_object($trip)){
                    if(isset($trip->route_id) && !in_array(intval($trip->route_id), $routeIds)){
                        return array('status'=>403,'payload'=>"Forbidden");
                    }
                }
            }
        }
        $res = parent::get_latest_by_trip($tid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function latest_many(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
        $ids = isset($this->data->trip_ids) ? $this->data->trip_ids : array();
        if(!is_array($ids)) $ids = array();
        if($role == 'parent' && isset($user->id) && !empty($ids)){
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
            include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
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
            $tc = new TripsController();
            $allowed = array();
            foreach($ids as $tid){
                $trip = $tc->get($tid);
                if($trip && is_object($trip)){
                    if(isset($trip->route_id) && in_array(intval($trip->route_id), $routeIds)){
                        $allowed[] = $tid;
                    }
                }
            }
            $ids = $allowed;
            if(empty($ids)){
                return array('status'=>200,'payload'=>array());
            }
        }
        $res = parent::get_latest_by_trips($ids);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function history($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        if(!Util::tokenValidate()) return array('status'=>403,'payload'=>"Unauthorized Access");
        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : '';
        $limit = isset($p->page1) ? intval($p->page1) : 50;
        $res = parent::get_by_trip($tid, $limit);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }
}
