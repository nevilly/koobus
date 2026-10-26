<?php
// KOO_BUS_ADAPT: Trips routes
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
include_once  $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

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

    /**
     * KOO_BUS_ADAPT: ratiba inakubali datetime ya ISO au `Y-m-d H:i:s`.
     * Tunarudisha muda wa app (Africa/Dar_es_Salaam) tayari kwa MySQL.
     */
    private function normalizeScheduledAt($raw)
    {
        if($raw === null || trim((string) $raw) === '') return false;
        try {
            $date = new DateTime((string) $raw);
            return $date->format('Y-m-d H:i:s');
        } catch (Exception $e) {
            return false;
        }
    }

    private function scheduledAtOf($trip)
    {
        $raw = $this->fieldOf($trip, 'scheduled_at');
        if($raw === null || trim((string) $raw) === '') return null;
        try {
            return new DateTime((string) $raw);
        } catch (Exception $e) {
            return null;
        }
    }

    /**
     * KOO_BUS_ADAPT: kanuni ya muda wa kuanza.
     *
     * Safari ya kawaida inafunguka saa moja kabla ya muda uliopangwa.
     * Kabla ya hapo dereva anaweza kuanza kwa dharura tu, na ni safari
     * ya siku hiyo. Sababu ya dharura ni lazima ili ikarekodiwe.
     */
    private function checkStartWindow($trip, &$startedEarly, &$reason)
    {
        $startedEarly = false;
        $reason = '';
        $scheduled = $this->scheduledAtOf($trip);
        if($scheduled === null) return array(true, null);

        $now = new DateTime('now');
        $window = clone $scheduled;
        $window->modify('-60 minutes');

        if($now < $window){
            $emergency = isset($this->data->emergency) ? $this->data->emergency : false;
            if(!$emergency){
                return array(false, array(
                    'status'=>409,
                    'payload'=>"Route start window opens at ".$window->format('H:i')." on ".$window->format('Y-m-d')
                ));
            }

            if($scheduled->format('Y-m-d') !== $now->format('Y-m-d')){
                return array(false, array(
                    'status'=>409,
                    'payload'=>"Emergency start is only allowed on the scheduled day"
                ));
            }

            $reasonText = isset($this->data->reason) ? trim((string) $this->data->reason) : '';
            if($reasonText === ''){
                return array(false, array(
                    'status'=>400,
                    'payload'=>"A reason is required for an emergency start"
                ));
            }

            $startedEarly = true;
            $reason = $reasonText;
        }

        return array(true, null);
    }

    /**
     * KOO_BUS_ADAPT: taarifa halisi kwa wazazi, shule na matron.
     */
    private function notifyTripStarted($trip, $startedEarly, $reason)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/NotificationsController.php';

        $routeId = isset($trip->route_id) ? intval($trip->route_id) : 0;
        $schoolId = $routeId > 0 ? Tenant::routeSchoolId($routeId) : 0;
        $matronId = isset($trip->matron_id) ? intval($trip->matron_id) : 0;
        $recipients = parent::get_start_recipients($routeId, $schoolId, $matronId);
        if(empty($recipients)) return 0;

        $routeName = parent::get_route_name($routeId);
        if($routeName === '') $routeName = 'Route';
        $tripType = isset($trip->trip_type) ? $trip->trip_type : '';
        $typeLabel = $tripType === 'afternoon' ? 'mchana' : 'asubuhi';
        $type = $startedEarly ? 'trip_started_early' : 'trip_started';

        $title = $startedEarly ? 'Safari imeanza mapema' : 'Safari imeanza';
        $body = $startedEarly
            ? "Safari ya $typeLabel ya $routeName imeanzishwa mapema kwa dharura."
            : "Safari ya $typeLabel ya $routeName imeanza.";

        $data = json_encode(array(
            'trip_id'=>intval($trip->id),
            'route_id'=>$routeId,
            'route_name'=>$routeName,
            'trip_type'=>$tripType,
            'scheduled_at'=>isset($trip->scheduled_at) ? $trip->scheduled_at : null,
            'started_at'=>isset($trip->started_at) ? $trip->started_at : null,
            'early'=>$startedEarly ? 1 : 0,
            'reason'=>$startedEarly ? $reason : null,
        ));

        $notifications = new NotificationsController();
        $sent = 0;
        foreach($recipients as $uid){
            $n = array(
                'user_id'=>intval($uid),
                'title'=>$title,
                'body'=>$body,
                'type'=>$type,
                'data'=>$data,
            );
            if($notifications->add($this->encode($n))) $sent++;
        }
        return $sent;
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
            // get_by_parent inarudisha arrays (fetch_all MYSQLI_ASSOC).
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

    private function fieldOf($trip, $name)
    {
        $v = is_array($trip)
            ? (isset($trip[$name]) ? $trip[$name] : null)
            : (isset($trip->$name) ? $trip->$name : null);
        return $v;
    }

    /**
     * KOO_BUS_ADAPT: chuja trips kwa route zilizoruhusiwa.
     */
    private function filterTripsByRoutes($trips, $routeIds)
    {
        $filtered = array();
        if (is_array($trips)) {
            foreach ($trips as $t) {
                $rid = $this->fieldOf($t, 'route_id');
                if ($rid !== null && in_array(intval($rid), $routeIds)) {
                    $filtered[] = $t;
                }
            }
        }
        return $filtered;
    }

    /**
     * KOO_BUS_ADAPT: chuja trips kulingana na role/shule.
     *  - super_admin: zote
     *  - school_admin: za shule yake
     *  - driver: alizopangiwa yeye
     *  - matron: alizopangiwa yeye
     */
    private function filterTripsForUser($trips, $user)
    {
        if (!is_array($trips)) return array();

        $role = $this->roleOf($user);
        if ($role === 'super_admin') return $trips;

        $out = array();
        $scope = Tenant::schoolIdOfUser($user);

        foreach ($trips as $t) {
            $rid = $this->fieldOf($t, 'route_id');
            $did = $this->fieldOf($t, 'driver_id');
            $mid = $this->fieldOf($t, 'matron_id');

            if ($role === 'school_admin') {
                if ($scope > 0 && $rid !== null && Tenant::routeSchoolId($rid) === $scope) {
                    $out[] = $t;
                }
            } elseif ($role === 'driver') {
                if ($did !== null && intval($did) === intval($user->id)) {
                    $out[] = $t;
                }
            } elseif ($role === 'matron') {
                if ($mid !== null && intval($mid) === intval($user->id)) {
                    $out[] = $t;
                }
            }
        }

        return $out;
    }

    /**
     * KOO_BUS_ADAPT: je, mtumiaji anaweza kuona trip hii?
     */
    private function canViewTrip($trip, $user)
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
            return $rid > 0 && in_array($rid, $this->parentRouteIds($user->id));
        }

        return false;
    }

    /**
     * KOO_BUS_ADAPT: je, mtumiaji anaweza kusimamia (kuunda/kubadilisha/kufuta) trip?
     *  - super_admin: ndiyo
     *  - school_admin: trip ya shule yake tu
     */
    private function canManageTrip($trip, $user)
    {
        if (Tenant::isSuperAdmin($user)) return true;
        if (Tenant::isSchoolAdmin($user) && $trip && is_object($trip)) {
            $scope = Tenant::schoolIdOfUser($user);
            $rid = isset($trip->route_id) ? intval($trip->route_id) : 0;
            return $scope > 0 && $rid > 0 && Tenant::routeSchoolId($rid) === $scope;
        }
        return false;
    }

    /**
     * KOO_BUS_ADAPT: hakikisha trip ni ya dereva aliyeingia.
     */
    private function requireDriverOwnedTrip($trip, $driverId)
    {
        if (!$trip || !is_object($trip)) {
            return array(false, array('status' => 404, 'payload' => "Not found"));
        }
        if (!isset($trip->driver_id) || intval($trip->driver_id) !== intval($driverId)) {
            return array(false, array('status' => 403, 'payload' => "Forbidden"));
        }
        return array(true, $trip);
    }

    /**
     * KOO_BUS_ADAPT: dereva/matron ni wa shule hii na ana role sahihi?
     */
    private function isStaffOfSchool($userId, $expectedRole, $schoolId)
    {
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/UsersController.php';
        $uc = new UsersController();
        $u = $uc->get($userId);
        if (!$u || !is_object($u)) return false;
        if (!isset($u->role) || $u->role !== $expectedRole) return false;
        $uSchool = isset($u->school_id) ? intval($u->school_id) : 0;
        return $uSchool === intval($schoolId);
    }

    /**
     * KOO_BUS_ADAPT: ondoa FK ids zisizo sahihi (0) kwenye body.
     */
    private function cleanOptionalIds()
    {
        foreach (array('bus_id', 'driver_id', 'matron_id') as $k) {
            if (isset($this->data->$k) && intval($this->data->$k) <= 0) {
                unset($this->data->$k);
            }
        }
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        $res = parent::get('');

        if($role == 'parent' && isset($user->id)){
            $routeIds = $this->parentRouteIds($user->id);
            if(empty($routeIds)) return array('status'=>200,'payload'=>array());
            return array('status'=>200,'payload'=>$this->filterTripsByRoutes($res, $routeIds));
        }

        $res = $this->filterTripsForUser($res, $user);
        return array('status'=>200,'payload'=>$res);
    }

    public function get($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;

        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        if($id === '') return array('status'=>403,'payload'=>"Forbidden");
        if(!is_numeric($id)) return array('status'=>400,'payload'=>"Invalid trip id");

        $trip = parent::get($id);
        if(!$trip || !is_object($trip))
            return array('status'=>404,'payload'=>"Not found");

        if(!$this->canViewTrip($trip, $user))
            return array('status'=>403,'payload'=>"Forbidden");

        return array('status'=>200,'payload'=>$trip);
    }

    public function by_driver($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        $p = parent::decode($params);
        $did = isset($p->page) ? $p->page : '';

        // Dereva anaweza kuona trips zake tu.
        if($role == 'driver' && isset($user->id)){
            $did = $user->id;
        }

        // school_admin anaweza kuona dereva wa shule yake tu.
        if($role == 'school_admin'){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            if(Tenant::userSchoolId($did) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_by_driver($did);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function by_route($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        $p = parent::decode($params);
        $rid = isset($p->page) ? $p->page : '';

        if($role == 'parent' && isset($user->id)){
            $routeIds = $this->parentRouteIds($user->id);
            if(!in_array(intval($rid), $routeIds)){
                return array('status'=>403,'payload'=>"Forbidden");
            }
        } elseif(!Tenant::isSuperAdmin($user)){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0 || Tenant::routeSchoolId($rid) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_by_route($rid);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    /**
     * KOO_BUS_ADAPT: manifest ya wanafunzi kwa trip.
     * URL: /api/v1/trips/manifest/{trip_id}
     *
     * Dereva/matron wanaona trip yao tu; school_admin wa shule moja;
     * super_admin wote. Wazazi hawaorodheshi wanafunzi wote wa basi.
     */
    public function manifest($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('driver','matron','school_admin','super_admin'));
        if(!$ok) return $resUser;

        $p = parent::decode($params);
        $id = isset($p->page) ? $p->page : '';
        if($id === '' || !is_numeric($id))
            return array('status'=>400,'payload'=>"Invalid trip id");

        $trip = parent::get($id);
        if(!$trip || !is_object($trip))
            return array('status'=>404,'payload'=>"Not found");
        if(!$this->canViewTrip($trip, $resUser))
            return array('status'=>403,'payload'=>"Forbidden");

        $routeId = isset($trip->route_id) ? intval($trip->route_id) : 0;
        $tripType = isset($trip->trip_type) ? $trip->trip_type : '';
        $rows = parent::get_manifest($trip->id, $routeId, $tripType);
        if($rows === false)
            return array('status'=>500,'payload'=>"Failed");

        return array('status'=>200,'payload'=>$rows);
    }

    public function active_by_driver($params=''){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        $p = parent::decode($params);
        $did = isset($p->page) ? $p->page : '';

        if($role == 'driver' && isset($user->id)){
            $did = $user->id;
        }

        if($role == 'school_admin'){
            $scope = Tenant::schoolIdOfUser($user);
            if($scope <= 0) return array('status'=>403,'payload'=>"No school assigned to your account");
            if(Tenant::userSchoolId($did) !== $scope)
                return array('status'=>403,'payload'=>"Forbidden");
        }

        $res = parent::get_active_by_driver($did);
        if($res) return array('status'=>200,'payload'=>$res);
        return array('status'=>204,'payload'=>http::message(204));
    }

    public function active(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireAny();
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        $res = parent::get_active();

        if($role == 'parent' && isset($user->id)){
            $routeIds = $this->parentRouteIds($user->id);
            return array('status'=>200,'payload'=>$this->filterTripsByRoutes($res, $routeIds));
        }

        $res = $this->filterTripsForUser($res, $user);
        return array('status'=>200,'payload'=>$res);
    }

    public function add($data = ''){
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: trips zinaundwa na admin wa shule pekee.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        $rid = isset($this->data->route_id) ? $this->data->route_id : '';
        if($rid === '') return array('status'=>400,'payload'=>"route_id is required");

        $busId = isset($this->data->bus_id) ? intval($this->data->bus_id) : 0;
        $driverId = isset($this->data->driver_id) ? intval($this->data->driver_id) : 0;
        $tripType = isset($this->data->trip_type) ? $this->data->trip_type : '';
        if($busId <= 0 || $driverId <= 0 || $tripType === '')
            return array('status'=>400,'payload'=>"bus_id, driver_id and trip_type are required");
        if(!in_array($tripType, array('morning','afternoon'), true))
            return array('status'=>400,'payload'=>"Invalid trip_type");

        // KOO_BUS_ADAPT: kila safari mpya inapaswa kuwa na muda uliopangwa.
        $scheduledAt = $this->normalizeScheduledAt(isset($this->data->scheduled_at) ? $this->data->scheduled_at : null);
        if($scheduledAt === false)
            return array('status'=>400,'payload'=>"scheduled_at is required and must be a valid date/time");
        $this->data->scheduled_at = $scheduledAt;

        $schoolId = Tenant::routeSchoolId($rid);
        if($schoolId <= 0) return array('status'=>400,'payload'=>"Invalid route");

        // school_admin anaunda trip ya shule yake tu.
        if(!Tenant::isSuperAdmin($resUser) && Tenant::schoolIdOfUser($resUser) !== $schoolId)
            return array('status'=>403,'payload'=>"Forbidden");

        // Bus na route lazima ziwe za shule moja.
        if(Tenant::busSchoolId($busId) !== $schoolId)
            return array('status'=>403,'payload'=>"Bus is not in the same school");

        // Dereva (na matron kama yupo) lazima wawe wa shule hiyo.
        if(!$this->isStaffOfSchool($driverId, 'driver', $schoolId))
            return array('status'=>403,'payload'=>"Driver is not in the same school");

        if(isset($this->data->matron_id) && intval($this->data->matron_id) > 0){
            if(!$this->isStaffOfSchool(intval($this->data->matron_id), 'matron', $schoolId))
                return array('status'=>403,'payload'=>"Matron is not in the same school");
        } else {
            unset($this->data->matron_id);
        }

        $sql = parent::add($this->encode($this->data));
        if($sql) return array('status'=>201,'payload'=>array('id'=>$sql));
        return array('status'=>500,'payload'=>"Failed");
    }

    public function update($data = ''){
        if($this->clean->Method() !== "PUT")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kubadilisha trip ni kazi ya admin.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;
        if(!is_object($this->data)) return array('status'=>400,'payload'=>"Invalid data");

        $id = isset($this->data->id) ? $this->data->id : '';
        $trip = parent::get($id);
        if(!$trip || !is_object($trip))
            return array('status'=>404,'payload'=>"Not found");

        if(!$this->canManageTrip($trip, $resUser))
            return array('status'=>403,'payload'=>"Forbidden");

        // Safari inayoendelea/iliyokamilika hairuhusiwi kubadilishwa ratiba
        // au rasilimali zake; hii inalinda historia na taarifa za wazazi.
        $lockedFields = array('route_id','bus_id','driver_id','matron_id','trip_type','scheduled_at');
        if(isset($trip->status) && $trip->status !== 'pending'){
            foreach($lockedFields as $field){
                if(property_exists($this->data, $field))
                    return array('status'=>409,'payload'=>"Only a pending trip can be rescheduled or reassigned");
            }
        }

        if(property_exists($this->data, 'trip_type') && !in_array($this->data->trip_type, array('morning','afternoon'), true))
            return array('status'=>400,'payload'=>"Invalid trip_type");

        if(property_exists($this->data, 'scheduled_at')){
            $scheduledAt = $this->normalizeScheduledAt($this->data->scheduled_at);
            if($scheduledAt === false)
                return array('status'=>400,'payload'=>"scheduled_at must be a valid date/time");
            $this->data->scheduled_at = $scheduledAt;
        }

        // Route mpya (kama ipo) lazima iwe ya shule hiyo hiyo.
        $rid = isset($this->data->route_id) && $this->data->route_id !== ''
            ? $this->data->route_id
            : (isset($trip->route_id) ? $trip->route_id : '');
        $schoolId = Tenant::routeSchoolId($rid);
        if($schoolId <= 0) return array('status'=>400,'payload'=>"Invalid route");

        if(!Tenant::isSuperAdmin($resUser) && Tenant::schoolIdOfUser($resUser) !== $schoolId)
            return array('status'=>403,'payload'=>"Forbidden");

        $this->cleanOptionalIds();

        if(isset($this->data->bus_id) && Tenant::busSchoolId($this->data->bus_id) !== $schoolId)
            return array('status'=>403,'payload'=>"Bus is not in the same school");

        if(isset($this->data->driver_id) && !$this->isStaffOfSchool($this->data->driver_id, 'driver', $schoolId))
            return array('status'=>403,'payload'=>"Driver is not in the same school");

        if(isset($this->data->matron_id) && !$this->isStaffOfSchool($this->data->matron_id, 'matron', $schoolId))
            return array('status'=>403,'payload'=>"Matron is not in the same school");

        $sql = parent::update_trip($this->encode($this->data));
        if($sql) return array('status'=>200,'payload'=>"Updated");
        return array('status'=>500,'payload'=>"Failed");
    }

    private function transition($newStatus)
    {
        if($this->clean->Method() !== "POST")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        list($ok, $resUser) = AuthGuard::requireRole(array('driver','school_admin','super_admin'));
        if(!$ok) return $resUser;
        $user = $resUser;
        $role = $this->roleOf($user);

        $id = isset($this->data->trip_id) ? $this->data->trip_id : (isset($this->data->id) ? $this->data->id : '');
        if($id === '' || !is_numeric($id))
            return array('status'=>400,'payload'=>"Invalid trip id");
        $trip = parent::get($id);
        if(!$trip || !is_object($trip))
            return array('status'=>404,'payload'=>"Not found");

        if($role == 'driver'){
            list($owned, $err) = $this->requireDriverOwnedTrip($trip, $user->id);
            if(!$owned) return $err;
        } elseif(!$this->canManageTrip($trip, $user)){
            return array('status'=>403,'payload'=>"Forbidden");
        }

        // KOO_BUS_ADAPT: mabadiliko halali pekee ndiyo yanaruhusiwa.
        //   pending -> active      (start)
        //   active  -> completed   (end)
        //   pending/active -> cancelled
        $current = isset($trip->status) ? $trip->status : '';
        $startedEarly = false;
        $earlyReason = '';
        if($newStatus === 'active'){
            if($current !== 'pending')
                return array('status'=>409,'payload'=>"Trip cannot be started from status '$current'");

            // Dereva asiwe na safari nyingine inayoendelea kwa wakati mmoja.
            $active = parent::get_active_by_driver($trip->driver_id);
            if(is_array($active)){
                foreach($active as $a){
                    if(isset($a['id']) && intval($a['id']) !== intval($id))
                        return array('status'=>409,'payload'=>"Driver already has an active trip");
                }
            }

            list($windowOk, $windowError) = $this->checkStartWindow($trip, $startedEarly, $earlyReason);
            if(!$windowOk) return $windowError;
        } elseif($newStatus === 'completed'){
            if($current !== 'active')
                return array('status'=>409,'payload'=>"Trip cannot be completed from status '$current'");
        } else {
            if(!in_array($current, array('pending','active'), true))
                return array('status'=>409,'payload'=>"Trip cannot be cancelled from status '$current'");
        }

        if($newStatus === 'active') $sql = parent::start_trip($id, $startedEarly, $earlyReason);
        elseif($newStatus === 'completed') $sql = parent::end_trip($id);
        else $sql = parent::cancel_trip($id);

        if($sql){
            // Hakikisha hali imebadilika kweli (kuzuia race au update iliyoshindikana).
            $after = parent::get($id);
            if($after && is_object($after) && isset($after->status) && $after->status === $newStatus){
                if($newStatus === 'active'){
                    $notified = $this->notifyTripStarted($after, $startedEarly, $earlyReason);
                    return array('status'=>200,'payload'=>array(
                        'trip_id'=>intval($id),
                        'status'=>'active',
                        'started_early'=>$startedEarly ? 1 : 0,
                        'early_start_reason'=>$startedEarly ? $earlyReason : null,
                        'started_at'=>isset($after->started_at) ? $after->started_at : null,
                        'notified'=>$notified,
                    ));
                }
                return array('status'=>200,'payload'=>"Trip ".$newStatus);
            }
        }
        return array('status'=>500,'payload'=>"Failed");
    }

    public function start(){ return $this->transition('active'); }
    public function end(){ return $this->transition('completed'); }
    public function cancel(){ return $this->transition('cancelled'); }

    public function delete($data = ''){
        if($this->clean->Method() !== "POST" && $this->clean->Method() !== "DELETE")
            return array('status'=>403,'payload'=>"Unauthorized Access");
        // KOO_BUS_ADAPT: kufuta trip ni kazi ya admin.
        list($ok, $resUser) = AuthGuard::requireRole(array('school_admin','super_admin'));
        if(!$ok) return $resUser;

        $id = isset($this->data->id) ? $this->data->id : '';
        if($id === '' || !is_numeric($id))
            return array('status'=>400,'payload'=>"Invalid trip id");
        $trip = parent::get($id);
        if(!$trip || !is_object($trip))
            return array('status'=>404,'payload'=>"Not found");

        if(!$this->canManageTrip($trip, $resUser))
            return array('status'=>403,'payload'=>"Forbidden");

        $sql = parent::delete_trip($id);
        if($sql) return array('status'=>200,'payload'=>"Deleted");
        return array('status'=>500,'payload'=>"Failed");
    }
}
