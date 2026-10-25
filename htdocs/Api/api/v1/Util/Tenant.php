<?php
// KOO_BUS_ADAPT: Tenant — msaada wa kutenganisha data kwa shule.
//
// Kanuni:
//  - super_admin: anaweza kuona/kubadilisha kila shule.
//  - school_admin: anaweza kuona/kubadilisha data ya shule Yake tu.
//  - school_admin asiye na school_id (0): hakuna data anayoruhusiwa
//    (fail-closed), mpaka admin mkuu amemweka kwenye shule.
//
// Hii inatumika kwenye routes za admin pekee; wazazi/dereva/matron
// wana kanuni zao za umiliki (parent_children / driver_id / matron_id).

class Tenant
{
    public static function roleOf($user)
    {
        return isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
    }

    public static function isSuperAdmin($user)
    {
        return self::roleOf($user) === 'super_admin';
    }

    public static function isSchoolAdmin($user)
    {
        return self::roleOf($user) === 'school_admin';
    }

    public static function isAdmin($user)
    {
        return self::isSuperAdmin($user) || self::isSchoolAdmin($user);
    }

    public static function schoolIdOfUser($user)
    {
        return isset($user->school_id) ? intval($user->school_id) : 0;
    }

    /**
     * Je, mtumiaji anaweza kufikia shule hii?
     */
    public static function canAccess($user, $schoolId)
    {
        if (self::isSuperAdmin($user)) return true;
        if (self::isSchoolAdmin($user)) {
            $mine = self::schoolIdOfUser($user);
            return $mine > 0 && $mine === intval($schoolId);
        }
        return false;
    }

    /**
     * KOO_BUS_ADAPT: shule ipo?
     */
    public static function schoolExists($schoolId)
    {
        if (empty($schoolId)) return false;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/SchoolsController.php';
        $c = new SchoolsController();
        $s = $c->get($schoolId);
        return $s && is_object($s);
    }

    public static function routeSchoolId($routeId)    {
        if (empty($routeId)) return 0;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/RoutesController.php';
        $c = new RoutesController();
        $r = $c->get($routeId);
        return ($r && is_object($r) && isset($r->school_id)) ? intval($r->school_id) : 0;
    }

    public static function childSchoolId($childId)
    {
        if (empty($childId)) return 0;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ChildrenController.php';
        $c = new ChildrenController();
        $r = $c->get($childId);
        return ($r && is_object($r) && isset($r->school_id)) ? intval($r->school_id) : 0;
    }

    public static function busSchoolId($busId)
    {
        if (empty($busId)) return 0;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/BusesController.php';
        $c = new BusesController();
        $r = $c->get($busId);
        return ($r && is_object($r) && isset($r->school_id)) ? intval($r->school_id) : 0;
    }

    public static function userSchoolId($userId)
    {
        if (empty($userId)) return 0;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/UsersController.php';
        $c = new UsersController();
        $r = $c->get($userId);
        return ($r && is_object($r) && isset($r->school_id)) ? intval($r->school_id) : 0;
    }

    public static function tripSchoolId($tripId)
    {
        if (empty($tripId)) return 0;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripsController.php';
        $c = new TripsController();
        $t = $c->get($tripId);
        if (!$t || !is_object($t) || !isset($t->route_id)) return 0;
        return self::routeSchoolId($t->route_id);
    }

    public static function eventSchoolId($eventId)
    {
        if (empty($eventId)) return 0;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/TripEventsController.php';
        $c = new TripEventsController();
        $e = $c->get($eventId);
        if (!$e || !is_object($e) || !isset($e->trip_id)) return 0;
        return self::tripSchoolId($e->trip_id);
    }

    public static function parentChildSchoolId($linkId)
    {
        if (empty($linkId)) return 0;
        include_once $_SERVER["DOCUMENT_ROOT"] . '/api/v1/Controller/ParentChildrenController.php';
        $c = new ParentChildrenController();
        $l = $c->get($linkId);
        if (!$l || !is_object($l) || !isset($l->child_id)) return 0;
        return self::childSchoolId($l->child_id);
    }
}
