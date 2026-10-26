<?php
// KOO_BUS_ADAPT: Locations routes (GPS)
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/LocationsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

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

    private function roleOf($user)
    {
        return isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
    }

    /**
     * KOO_BUS_ADAPT: rudi route_id za watoto wa mzazi aliyeingia.
     */
    private function parentRouteIds($parentId)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';

        $pcc = new ParentChildrenController();
        $links = $pcc->get_by_parent($parentId);
        $routeIds = array();

        if (is_array($links)) {
            foreach ($links as $l) {
                if (isset($l['child_id'])) {
                    $cc = new ChildrenController();
                    $c = $cc->get($l['child_id']);
                    if (is_object($c) && isset($c->route_id)) {
                        $routeIds[] = intval($c->route_id);
                    }
                }
            }
        }

        return array_values(array_unique($routeIds));
    }

    /**
     * KOO_BUS_ADAPT: trip ipo na inaruhusiwa kwa mzazi?
     */
    private function parentAllowedTrip($parentId, $tripId)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
        $tc = new TripsController();
        $trip = $tc->get($tripId);
        if (!$trip || !is_object($trip)) return false;

        $routeIds = $this->parentRouteIds($parentId);
        return isset($trip->route_id) && in_array(intval($trip->route_id), $routeIds);
    }

    /**
     * KOO_BUS_ADAPT: trip ni ya dereva huyu?
     */
    private function driverAllowedTrip($driverId, $tripId)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
        $tc = new TripsController();
        $trip = $tc->get($tripId);
        if (!$trip || !is_object($trip)) return false;
        return isset($trip->driver_id) && intval($trip->driver_id) === intval($driverId);
    }

    /**
     * KOO_BUS_ADAPT: trip imepangiwa matron huyu?
     */
    private function matronAllowedTrip($matronId, $tripId)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
        $tc = new TripsController();
        $trip = $tc->get($tripId);
        if (!$trip || !is_object($trip)) return false;
        return isset($trip->matron_id) && intval($trip->matron_id) === intval($matronId);
    }

    /**
     * KOO_BUS_ADAPT: trip ni ya shule ya admin huyu?
     */
    private function schoolAdminAllowedTrip($user, $tripId)
    {
        $scope = Tenant::schoolIdOfUser($user);
        return $scope > 0 && Tenant::tripSchoolId($tripId) === $scope;
    }

    public function upload(){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $res) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $res;
        $user = $res;
        $role = $this->roleOf($user);

        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        $tripId = isset($this->data->trip_id) ? $this->data->trip_id : '';
        if($tripId === '' || !is_numeric($tripId))
            return array('status'=>400,'payload'=>"trip_id is required");
        $tripId = intval($tripId);

        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
        $tc = new TripsController();
        $trip = $tc->get($tripId);
        if(!$trip || !is_object($trip))
            return array('status'=>404,'payload'=>"Trip not found");

        // KOO_BUS_ADAPT: dereva anapakia location ya trip Yake tu.
        if($role == 'driver'){
            if(intval($trip->driver_id) !== intval($user->id))
                return array('status'=>403,'payload'=>"Forbidden");
        } elseif($role == 'school_admin'){
            // school_admin anapakia location ya trip ya shule yake tu.
            if(!$this->schoolAdminAllowedTrip($user, $tripId))
                return array('status'=>403,'payload'=>"Forbidden");
        }

        // KOO_BUS_ADAPT: location inakubalika kwa safari inayoendelea tu.
        // Hii inazuia pointi za safari ambayo haijaanza au imekwisha.
        if(!isset($trip->status) || $trip->status !== 'active')
            return array('status'=>409,'payload'=>"Trip is not active");

        $lat = isset($this->data->latitude) ? $this->data->latitude : null;
        $lng = isset($this->data->longitude) ? $this->data->longitude : null;
        if(!is_numeric($lat) || !is_numeric($lng))
            return array('status'=>400,'payload'=>"latitude and longitude are required");
        $lat = floatval($lat);
        $lng = floatval($lng);
        if($lat < -90 || $lat > 90 || $lng < -180 || $lng > 180)
            return array('status'=>400,'payload'=>"Invalid coordinates");
        if(abs($lat) < 0.0000001 && abs($lng) < 0.0000001)
            return array('status'=>400,'payload'=>"Invalid coordinates");

        $speed = isset($this->data->speed) ? $this->data->speed : null;
        if($speed !== null && $speed !== ''){
            if(!is_numeric($speed) || floatval($speed) < 0 || floatval($speed) > 300)
                return array('status'=>400,'payload'=>"Invalid speed");
            $speed = floatval($speed);
        } else {
            $speed = null;
        }

        $accuracy = isset($this->data->accuracy) ? $this->data->accuracy : null;
        if($accuracy !== null && $accuracy !== ''){
            if(!is_numeric($accuracy) || floatval($accuracy) < 0 || floatval($accuracy) > 10000)
                return array('status'=>400,'payload'=>"Invalid accuracy");
            $accuracy = floatval($accuracy);
        } else {
            $accuracy = null;
        }

        // Server ndiyo inaamua driver_id; client hawezi kujitengenezea.
        $this->data->trip_id = $tripId;
        $this->data->driver_id = intval($trip->driver_id);
        $this->data->latitude = $lat;
        $this->data->longitude = $lng;
        if($speed === null) unset($this->data->speed); else $this->data->speed = $speed;
        if($accuracy === null) unset($this->data->accuracy); else $this->data->accuracy = $accuracy;

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
        $role = $this->roleOf($user);

        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : (isset($this->data->trip_id)?$this->data->trip_id:'');

        if($tid === ''){
            return array('status'=>403,'payload'=>"Forbidden");
        }

        if($role == 'parent' && isset($user->id)){
            if(!$this->parentAllowedTrip($user->id, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }

        if($role == 'driver' && isset($user->id)){
            if(!$this->driverAllowedTrip($user->id, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }

        // KOO_BUS_ADAPT: matron anaona locations za trips zake tu.
        if($role == 'matron' && isset($user->id)){
            if(!$this->matronAllowedTrip($user->id, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }

        // KOO_BUS_ADAPT: school_admin anaona locations za shule yake tu.
        if($role == 'school_admin'){
            if(!$this->schoolAdminAllowedTrip($user, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
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
        $role = $this->roleOf($user);

        $ids = isset($this->data->trip_ids) ? $this->data->trip_ids : array();
        if(!is_array($ids)) $ids = array();

        if($role == 'parent' && isset($user->id)){
            $allowed = array();
            foreach($ids as $tid){
                if($this->parentAllowedTrip($user->id, $tid)){
                    $allowed[] = $tid;
                }
            }
            $ids = $allowed;
        }

        if($role == 'driver' && isset($user->id)){
            $allowed = array();
            foreach($ids as $tid){
                if($this->driverAllowedTrip($user->id, $tid)){
                    $allowed[] = $tid;
                }
            }
            $ids = $allowed;
        }

        // KOO_BUS_ADAPT: matron anaona locations za trips zake tu.
        if($role == 'matron' && isset($user->id)){
            $allowed = array();
            foreach($ids as $tid){
                if($this->matronAllowedTrip($user->id, $tid)){
                    $allowed[] = $tid;
                }
            }
            $ids = $allowed;
        }

        // KOO_BUS_ADAPT: school_admin anaona locations za shule yake tu.
        if($role == 'school_admin'){
            $allowed = array();
            foreach($ids as $tid){
                if($this->schoolAdminAllowedTrip($user, $tid)){
                    $allowed[] = $tid;
                }
            }
            $ids = $allowed;
        }

        if(empty($ids)){
            return array('status'=>200,'payload'=>array());
        }

        $res = parent::get_latest_by_trips($ids);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function history($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : '';
        $limit = isset($p->page1) ? intval($p->page1) : 50;

        if($tid === ''){
            return array('status'=>403,'payload'=>"Forbidden");
        }

        if($role == 'parent' && isset($user->id)){
            if(!$this->parentAllowedTrip($user->id, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }

        if($role == 'driver' && isset($user->id)){
            if(!$this->driverAllowedTrip($user->id, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }

        // KOO_BUS_ADAPT: matron anaona locations za trips zake tu.
        if($role == 'matron' && isset($user->id)){
            if(!$this->matronAllowedTrip($user->id, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }

        // KOO_BUS_ADAPT: school_admin anaona locations za shule yake tu.
        if($role == 'school_admin'){
            if(!$this->schoolAdminAllowedTrip($user, $tid)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        }

        $res = parent::get_by_trip($tid, $limit);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }
}
