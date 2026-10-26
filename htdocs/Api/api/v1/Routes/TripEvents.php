<?php
// KOO_BUS_ADAPT: TripEvents routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripEventsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class TripEvents extends TripEventsController
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

    private function fieldOf($row, $name)
    {
        return is_array($row)
            ? (isset($row[$name]) ? $row[$name] : null)
            : (isset($row->$name) ? $row->$name : null);
    }

    private function tripById($tripId)
    {
        if (empty($tripId)) return false;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
        $tc = new TripsController();
        $t = $tc->get($tripId);
        return ($t && is_object($t)) ? $t : false;
    }

    private function parentChildIds($parentId)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
        $pcc = new ParentChildrenController();
        $links = $pcc->get_by_parent($parentId);
        $ids = array();
        if (is_array($links)) {
            foreach ($links as $l) {
                if (isset($l['child_id'])) $ids[] = intval($l['child_id']);
            }
        }
        return $ids;
    }

    private function parentRouteIds($childIds)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
        $cc = new ChildrenController();
        $ids = array();
        foreach ($childIds as $cid) {
            $c = $cc->get($cid);
            if (is_object($c) && isset($c->route_id)) $ids[] = intval($c->route_id);
        }
        return array_values(array_unique($ids));
    }

    /**
     * KOO_BUS_ADAPT: je, mtumiaji anaweza kuona/kufanya kazi na trip hii?
     */
    private function canAccessTrip($trip, $user)
    {
        if (!$trip || !is_object($trip)) return false;
        $role = $this->roleOf($user);

        if ($role === 'super_admin') return true;

        $rid = isset($trip->route_id) ? intval($trip->route_id) : 0;

        if ($role === 'school_admin') {
            $scope = Tenant::schoolIdOfUser($user);
            return $scope > 0 && $rid > 0 && Tenant::routeSchoolId($rid) === $scope;
        }
        if ($role === 'driver') {
            return isset($trip->driver_id) && intval($trip->driver_id) === intval($user->id);
        }
        if ($role === 'matron') {
            return isset($trip->matron_id) && intval($trip->matron_id) === intval($user->id);
        }
        if ($role === 'parent') {
            $childIds = $this->parentChildIds($user->id);
            return $rid > 0 && in_array($rid, $this->parentRouteIds($childIds));
        }

        return false;
    }

    private function canViewChild($childId, $user)
    {
        $role = $this->roleOf($user);
        if ($role === 'super_admin') return true;

        if ($role === 'parent') {
            return in_array(intval($childId), $this->parentChildIds($user->id));
        }
        if ($role === 'driver' || $role === 'matron' || $role === 'school_admin') {
            $scope = Tenant::schoolIdOfUser($user);
            return $scope > 0 && Tenant::childSchoolId($childId) === $scope;
        }
        return false;
    }

    private function filterForUser($events, $user)
    {
        if (!is_array($events)) return array();
        $role = $this->roleOf($user);
        if ($role === 'super_admin') return $events;

        $out = array();
        if ($role === 'parent') {
            $childIds = $this->parentChildIds($user->id);
            foreach ($events as $e) {
                $cid = $this->fieldOf($e, 'child_id');
                if ($cid !== null && in_array(intval($cid), $childIds)) $out[] = $e;
            }
            return $out;
        }

        $scope = Tenant::schoolIdOfUser($user);
        foreach ($events as $e) {
            $tid = $this->fieldOf($e, 'trip_id');
            $trip = $tid !== null ? $this->tripById($tid) : false;
            if (!$trip) continue;

            if ($role === 'school_admin') {
                $rid = isset($trip->route_id) ? intval($trip->route_id) : 0;
                if ($scope > 0 && $rid > 0 && Tenant::routeSchoolId($rid) === $scope) $out[] = $e;
            } elseif ($role === 'driver') {
                if (isset($trip->driver_id) && intval($trip->driver_id) === intval($user->id)) $out[] = $e;
            } elseif ($role === 'matron') {
                if (isset($trip->matron_id) && intval($trip->matron_id) === intval($user->id)) $out[] = $e;
            }
        }
        return $out;
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;

        $res = parent::get('');
        $res = $this->filterForUser($res, $resUser);
        return array('status'=>200,'payload'=>$res);
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;

        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        if($id === '') return array('status'=>403,'payload'=>"Forbidden");

        $event = parent::get($id);
        if(!$event || !is_object($event))
            return array('status'=>404,'payload'=>"Not found");

        $role = $this->roleOf($resUser);
        $allowed = false;
        if($role === 'super_admin'){
            $allowed = true;
        } elseif($role === 'parent'){
            $allowed = isset($event->child_id) && in_array(intval($event->child_id), $this->parentChildIds($resUser->id));
        } elseif(isset($event->trip_id)){
            $allowed = $this->canAccessTrip($this->tripById($event->trip_id), $resUser);
        }

        if(!$allowed) return array('status'=>403,'payload'=>"Forbidden");
        return array('status'=>200,'payload'=>$event);
    }

    public function by_trip($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;

        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : '';
        if($tid === '') return array('status'=>403,'payload'=>"Forbidden");

        $trip = $this->tripById($tid);
        if(!$trip) return array('status'=>404,'payload'=>"Not found");
        if(!$this->canAccessTrip($trip, $resUser))
            return array('status'=>403,'payload'=>"Forbidden");

        $res = parent::get_by_trip($tid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_child($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;

        $p = parent::decode($params);
        $cid = isset($p->page) ? $p->page : '';
        if($cid === '') return array('status'=>403,'payload'=>"Forbidden");
        if(!$this->canViewChild($cid, $resUser))
            return array('status'=>403,'payload'=>"Forbidden");

        $res = parent::get_by_child($cid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_trip_child($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;

        $p = parent::decode($params);
        $tid = isset($p->page) ? $p->page : (isset($this->data->trip_id)?$this->data->trip_id:'');
        $cid = isset($p->page1) ? $p->page1 : (isset($this->data->child_id)?$this->data->child_id:'');

        if($tid !== ''){
            $trip = $this->tripById($tid);
            if(!$trip) return array('status'=>404,'payload'=>"Not found");
            if(!$this->canAccessTrip($trip, $resUser))
                return array('status'=>403,'payload'=>"Forbidden");
        }
        if($cid !== '' && !$this->canViewChild($cid, $resUser))
            return array('status'=>403,'payload'=>"Forbidden");

        $res = parent::get_by_trip_child($tid, $cid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function add($data = ''){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('driver','matron','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        if(!is_object($this->data))
            return array('status'=>400,'payload'=>"Invalid data");

        $tripId = isset($this->data->trip_id) ? $this->data->trip_id : '';
        $childId = isset($this->data->child_id) ? $this->data->child_id : '';
        if($tripId === '' || $childId === '')
            return array('status'=>400,'payload'=>"trip_id and child_id are required");

        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';

        $trip = $this->tripById($tripId);
        if(!$trip)
            return array('status'=>404,'payload'=>"Trip not found");

        // KOO_BUS_ADAPT: dereva na matron wanarekodi events za trips zao tu.
        if($role == 'driver'){
            if(!isset($trip->driver_id) || intval($trip->driver_id) !== intval($user->id))
                return array('status'=>403,'payload'=>"Forbidden");
        } elseif($role == 'matron'){
            if(!isset($trip->matron_id) || intval($trip->matron_id) !== intval($user->id))
                return array('status'=>403,'payload'=>"Forbidden");
        } else {
            // KOO_BUS_ADAPT: admin anaandika event ya trip ya shule yake tu.
            if(!$this->canAccessTrip($trip, $user))
                return array('status'=>403,'payload'=>"Forbidden");
        }

        // Mtoto lazima awe wa route ya trip — hakuna kuandika event ya mtoto wa route nyingine.
        $cc = new ChildrenController();
        $child = $cc->get($childId);
        if(!$child || !is_object($child))
            return array('status'=>404,'payload'=>"Child not found");
        if(isset($trip->route_id) && isset($child->route_id)
            && intval($trip->route_id) !== intval($child->route_id))
            return array('status'=>403,'payload'=>"Forbidden");

        // KOO_BUS_ADAPT: event_type lazima iwe halali, na stop_id (kama ipo)
        // lazima iwe kituo cha route ya trip hii.
        $eventType = isset($this->data->event_type) ? $this->data->event_type : '';
        if(!in_array($eventType, array('board','alight','absent','excused'), true))
            return array('status'=>400,'payload'=>"Invalid event_type");

        if(isset($this->data->stop_id) && $this->data->stop_id !== ''){
            if(intval($this->data->stop_id) <= 0){
                unset($this->data->stop_id);
            } elseif(Tenant::stopRouteId($this->data->stop_id) !== intval($trip->route_id)){
                return array('status'=>400,'payload'=>"Stop does not belong to this trip's route");
            }
        }

        // KOO_BUS_ADAPT: recorded_by inatoka kwenye token (si kwenye body).
        // Hii inahakikisha matron anarekodiwa kwa jina lake halisi.
        $this->data->recorded_by = $user->id;

        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function delete($data = ''){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kufuta event ni kazi ya admin.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;

        $id = isset($this->data->id) ? $this->data->id : '';
        $event = parent::get($id);
        if(!$event || !is_object($event))
            return array('status'=>404,'payload'=>"Not found");

        if(!Tenant::isSuperAdmin($resUser)){
            $scope = Tenant::schoolIdOfUser($resUser);
            if($scope <= 0 || !isset($event->trip_id)
                || Tenant::tripSchoolId($event->trip_id) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $sql = parent::delete_event($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
