<?php
// KOO_BUS_ADAPT: Coordinates routes
//
// Nafasi ya mtoto na nafasi ya shule zinahitaji uthibitisho wa pande
// MBILI: mzazi na shule. Upande mmoja pekee HAUWEZI kutumika kwa
// route/ETA. Upande unaohifadhi nafasi unathibitisha mara moja, kisha
// upande wa pili unathibitisha. Mabadiliko yoyote yanafuta uthibitisho
// wa upande wa pili.
include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/CoordinatesController.php';
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Controller/ParentChildrenController.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/AuthGuard.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Tenant.php";

class Coordinates extends CoordinatesController
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

    private function parentChildIds($parentId)
    {
        $pcc = new ParentChildrenController();
        $links = $pcc->get_by_parent(intval($parentId));
        $ids = array();
        if (is_array($links)) {
            foreach ($links as $link) {
                if (isset($link['child_id'])) $ids[] = intval($link['child_id']);
            }
        }
        return $ids;
    }

    private function parentHasChild($parentId, $childId)
    {
        return in_array(intval($childId), $this->parentChildIds($parentId), true);
    }

    private function parentHasSchool($parentId, $schoolId)
    {
        foreach ($this->parentChildIds($parentId) as $childId) {
            if (Tenant::childSchoolId($childId) === intval($schoolId)) return true;
        }
        return false;
    }

    /**
     * Ruhusa ya kusoma/kuandika nafasi ya mtoto.
     * null = amruhusiwa; array = jibu la kosa.
     */
    private function childAccessError($user, $childId)
    {
        $childId = intval($childId);
        $childSchool = Tenant::childSchoolId($childId);
        if ($childSchool <= 0) {
            return array('status' => 404, 'payload' => "Not found");
        }

        $role = $this->roleOf($user);
        if ($role === 'parent') {
            if (!$this->parentHasChild($user->id, $childId)) {
                return array('status' => 403, 'payload' => "Forbidden");
            }
            return null;
        }

        if (Tenant::isSuperAdmin($user)) return null;

        $scope = Tenant::schoolIdOfUser($user);
        if ($scope <= 0) {
            return array('status' => 403, 'payload' => "No school assigned to your account");
        }
        if ($scope !== $childSchool) {
            return array('status' => 403, 'payload' => "Forbidden");
        }
        return null;
    }

    /**
     * Ruhusa ya kusoma/kuandika nafasi ya shule.
     */
    private function schoolAccessError($user, $schoolId)
    {
        $schoolId = intval($schoolId);
        if (!Tenant::schoolExists($schoolId)) {
            return array('status' => 404, 'payload' => "Not found");
        }

        $role = $this->roleOf($user);
        if ($role === 'parent') {
            if (!$this->parentHasSchool($user->id, $schoolId)) {
                return array('status' => 403, 'payload' => "Forbidden");
            }
            return null;
        }

        if (Tenant::isSuperAdmin($user)) return null;

        $scope = Tenant::schoolIdOfUser($user);
        if ($scope <= 0) {
            return array('status' => 403, 'payload' => "No school assigned to your account");
        }
        if ($scope !== $schoolId) {
            return array('status' => 403, 'payload' => "Forbidden");
        }
        return null;
    }

    private function coordinatePayload($row)
    {
        if (!$row) return null;
        $parentConfirmed = !empty($row['parent_confirmed_at']);
        $schoolConfirmed = !empty($row['school_confirmed_at']);

        return array(
            'id' => intval($row['id']),
            'entity_type' => $row['entity_type'],
            'entity_id' => intval($row['entity_id']),
            'latitude' => (float) $row['latitude'],
            'longitude' => (float) $row['longitude'],
            'label' => $row['label'],
            'proposed_by' => $row['proposed_by'] !== null ? intval($row['proposed_by']) : null,
            'proposed_role' => $row['proposed_role'],
            'parent_confirmed' => $parentConfirmed,
            'school_confirmed' => $schoolConfirmed,
            'is_valid' => $parentConfirmed && $schoolConfirmed,
            'parent_confirmed_at' => $row['parent_confirmed_at'],
            'school_confirmed_at' => $row['school_confirmed_at'],
            'updated_at' => $row['updated_at'],
        );
    }

    private function overviewCoordinate($row)
    {
        if (empty($row['coordinate_id'])) return null;
        $parentConfirmed = !empty($row['coordinate_parent_confirmed_at']);
        $schoolConfirmed = !empty($row['coordinate_school_confirmed_at']);

        return array(
            'id' => intval($row['coordinate_id']),
            'latitude' => (float) $row['coordinate_latitude'],
            'longitude' => (float) $row['coordinate_longitude'],
            'label' => $row['coordinate_label'],
            'proposed_by' => $row['coordinate_proposed_by'] !== null
                ? intval($row['coordinate_proposed_by']) : null,
            'proposed_role' => $row['coordinate_proposed_role'],
            'parent_confirmed' => $parentConfirmed,
            'school_confirmed' => $schoolConfirmed,
            'is_valid' => $parentConfirmed && $schoolConfirmed,
            'parent_confirmed_at' => $row['coordinate_parent_confirmed_at'],
            'school_confirmed_at' => $row['coordinate_school_confirmed_at'],
            'updated_at' => $row['coordinate_updated_at'],
        );
    }

    private function childOverviewItem($row)
    {
        return array(
            'child_id' => intval($row['child_id']),
            'first_name' => $row['first_name'],
            'last_name' => $row['last_name'],
            'class_name' => $row['class_name'],
            'school_id' => intval($row['school_id']),
            'school_name' => $row['school_name'],
            'coordinate' => $this->overviewCoordinate($row),
        );
    }

    private function schoolOverviewItem($row)
    {
        return array(
            'school_id' => intval($row['school_id']),
            'school_name' => $row['school_name'],
            'coordinate' => $this->overviewCoordinate($row),
        );
    }

    /**
     * Soma na kagua lat/lng/label. Rudisha ujumbe wa kosa au null.
     */
    private function readCoordinateInput(&$latitude, &$longitude, &$label)
    {
        if (!is_object($this->data)) return "Invalid data";

        if (!isset($this->data->latitude) || !is_numeric($this->data->latitude)) {
            return "latitude is required";
        }
        if (!isset($this->data->longitude) || !is_numeric($this->data->longitude)) {
            return "longitude is required";
        }

        $latitude = (float) $this->data->latitude;
        $longitude = (float) $this->data->longitude;

        if ($latitude < -90 || $latitude > 90) return "Invalid latitude";
        if ($longitude < -180 || $longitude > 180) return "Invalid longitude";
        if (abs($latitude) < 0.0000001 && abs($longitude) < 0.0000001) {
            return "Invalid coordinate";
        }

        $label = null;
        if (isset($this->data->label)) {
            $label = trim((string) $this->data->label);
            if ($label === '') $label = null;
            if ($label !== null && strlen($label) > 150) return "Label is too long";
        }

        return null;
    }

    /**
     * GET /coordinates/overview
     *
     * Inarudisha watoto na shule zinazohusiana na mtumiaji, pamoja na
     * nafasi zao na hali ya uthibitisho.
     */
    public function overview()
    {
        if ($this->clean->Method() !== "GET") {
            return array('status' => 403, 'payload' => "Unauthorized Access");
        }

        list($ok, $user) = AuthGuard::requireRole(
            array('parent', 'matron', 'school_admin', 'super_admin')
        );
        if (!$ok) return $user;

        $role = $this->roleOf($user);
        $childRows = array();
        $schoolRows = array();

        if ($role === 'parent') {
            $childRows = $this->children_for_parent($user->id);
            $schoolIds = array();
            foreach ($childRows as $row) {
                $schoolIds[] = intval($row['school_id']);
            }
            $schoolRows = $this->schools_by_ids($schoolIds);
        } elseif (Tenant::isSuperAdmin($user)) {
            $childRows = $this->all_children();
            $schoolRows = $this->all_schools();
        } else {
            $scope = Tenant::schoolIdOfUser($user);
            if ($scope <= 0) {
                return array('status' => 403, 'payload' => "No school assigned to your account");
            }
            $childRows = $this->children_for_school($scope);
            $schoolRows = $this->schools_by_ids(array($scope));
        }

        $children = array();
        foreach ($childRows as $row) $children[] = $this->childOverviewItem($row);

        $schools = array();
        foreach ($schoolRows as $row) $schools[] = $this->schoolOverviewItem($row);

        return array('status' => 200, 'payload' => array(
            'children' => $children,
            'schools' => $schools,
        ));
    }

    /**
     * GET/POST/PUT /coordinates/child/{id}
     * POST /coordinates/child/{id}/confirm
     */
    public function child($params = '')
    {
        $method = $this->clean->Method();
        if (!in_array($method, array('GET', 'POST', 'PUT'), true)) {
            return array('status' => 403, 'payload' => "Unauthorized Access");
        }

        $p = parent::decode($params);
        $childId = isset($p->page) ? intval($p->page) : 0;
        $action = isset($p->page1) ? strtolower(trim((string) $p->page1)) : '';
        if ($childId <= 0) return array('status' => 400, 'payload' => "Invalid child");

        list($ok, $user) = AuthGuard::requireRole(
            array('parent', 'matron', 'school_admin', 'super_admin')
        );
        if (!$ok) return $user;

        $error = $this->childAccessError($user, $childId);
        if ($error !== null) return $error;

        if ($method === 'GET') {
            $row = $this->get_coordinate('child', $childId);
            return array('status' => 200, 'payload' => $this->coordinatePayload($row));
        }

        if ($method === 'POST' && $action === 'confirm') {
            $side = $this->roleOf($user) === 'parent' ? 'parent' : 'school';
            $row = $this->confirm_coordinate('child', $childId, $user->id, $side);
            if (!$row) return array('status' => 404, 'payload' => "Coordinate not found");
            return array('status' => 200, 'payload' => $this->coordinatePayload($row));
        }

        if ($action !== '') {
            return array('status' => 404, 'payload' => "Not found");
        }

        $latitude = 0.0;
        $longitude = 0.0;
        $label = null;
        $inputError = $this->readCoordinateInput($latitude, $longitude, $label);
        if ($inputError !== null) return array('status' => 400, 'payload' => $inputError);

        $role = $this->roleOf($user);
        $side = $role === 'parent' ? 'parent' : 'school';
        $row = $this->save_coordinate(
            'child',
            $childId,
            $latitude,
            $longitude,
            $label,
            $user->id,
            $role,
            $side
        );
        if (!$row) return array('status' => 500, 'payload' => "Failed");

        return array('status' => 200, 'payload' => $this->coordinatePayload($row));
    }

    /**
     * GET/POST/PUT /coordinates/school/{id}
     * POST /coordinates/school/{id}/confirm
     */
    public function school($params = '')
    {
        $method = $this->clean->Method();
        if (!in_array($method, array('GET', 'POST', 'PUT'), true)) {
            return array('status' => 403, 'payload' => "Unauthorized Access");
        }

        $p = parent::decode($params);
        $schoolId = isset($p->page) ? intval($p->page) : 0;
        $action = isset($p->page1) ? strtolower(trim((string) $p->page1)) : '';
        if ($schoolId <= 0) return array('status' => 400, 'payload' => "Invalid school");

        list($ok, $user) = AuthGuard::requireRole(
            array('parent', 'matron', 'school_admin', 'super_admin')
        );
        if (!$ok) return $user;

        $error = $this->schoolAccessError($user, $schoolId);
        if ($error !== null) return $error;

        if ($method === 'GET') {
            $row = $this->get_coordinate('school', $schoolId);
            return array('status' => 200, 'payload' => $this->coordinatePayload($row));
        }

        $role = $this->roleOf($user);

        if ($method === 'POST' && $action === 'confirm') {
            $side = $role === 'parent' ? 'parent' : 'school';
            $row = $this->confirm_coordinate('school', $schoolId, $user->id, $side);
            if (!$row) return array('status' => 404, 'payload' => "Coordinate not found");
            return array('status' => 200, 'payload' => $this->coordinatePayload($row));
        }

        if ($action !== '') {
            return array('status' => 404, 'payload' => "Not found");
        }

        // KOO_BUS_ADAPT: nafasi ya shule inawekwa na matron/school admin
        // (au super_admin), si mzazi. Mzazi huthibitisha tu.
        if ($role === 'parent') {
            return array('status' => 403, 'payload' => "Forbidden");
        }

        $latitude = 0.0;
        $longitude = 0.0;
        $label = null;
        $inputError = $this->readCoordinateInput($latitude, $longitude, $label);
        if ($inputError !== null) return array('status' => 400, 'payload' => $inputError);

        $row = $this->save_coordinate(
            'school',
            $schoolId,
            $latitude,
            $longitude,
            $label,
            $user->id,
            $role,
            'school'
        );
        if (!$row) return array('status' => 500, 'payload' => "Failed");

        return array('status' => 200, 'payload' => $this->coordinatePayload($row));
    }
}
