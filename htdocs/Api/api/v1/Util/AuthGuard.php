<?php
// KOO_BUS_ADAPT: AuthGuard helper kwa Authorization
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Module/UsersModule.php";
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Util/Util.php";

class AuthGuard extends UsersModule
{
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Pata mtumiaji wa sasa kutoka token
     */
    public static function user()
    {
        if (!Util::tokenValidate()) {
            return false;
        }
        $guard = new self();
        $result = $guard->getUserIdByToken(Util::$token);

        // KOO_BUS_ADAPT: getUserIdByToken inarudisha mysqli_result (module),
        // si object. Lazima tufetch object kabla ya kuangalia ->id.
        if ($result && $result instanceof mysqli_result && $result->num_rows > 0) {
            $user = $result->fetch_object();
            if ($user && isset($user->id)) {
                return $user;
            }
        }

        return false;
    }

    /**
     * Hitaji mtumiaji aliyeingia
     */
    public static function requireAuth()
    {
        $user = self::user();
        if (!$user) {
            return array(false, array('status' => 401, 'payload' => 'Unauthorized'));
        }
        return array(true, $user);
    }

    /**
     * Hitaji mtumiaji mwenye role moja kati ya zilizotajwa
     */
    public static function requireRole($roles = array())
    {
        list($ok, $res) = self::requireAuth();
        if (!$ok) {
            return array(false, $res);
        }
        $user = $res;
        if (!empty($roles) && is_array($roles)) {
            $role = isset($user->role) ? $user->role : (isset($user->privilege) ? $user->privilege : '');
            if (!in_array($role, $roles)) {
                return array(false, array('status' => 403, 'payload' => 'Forbidden'));
            }
        }
        return array(true, $user);
    }

    /**
     * Hitaji kuwa mtumiaji ni parent/driver/matron/school_admin/super_admin na ameingia
     */
    public static function requireAny()
    {
        return self::requireRole(array('parent', 'driver', 'matron', 'school_admin', 'super_admin'));
    }
}
