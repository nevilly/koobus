<?php
// KOO_BUS_ADAPT: Coordinates module
//
// Nafasi moja inaweza kuwa ya mtoto (nyumbani/kituo cha kupanda) au ya
// shule. Kanuni kuu: nafasi ni HALALI pale upande wa mzazi na upande wa
// shule wote wameithibitisha. Kila mabadiliko ya lat/lng yanafuta
// uthibitisho wa upande wa pili ili uthibitisho usiendelee kwa nafasi
// mpya bila ridhaa.
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Module/Database.php";

class CoordinatesModule extends Database
{
    private $table = "coordinates";

    public function __construct()
    {
        parent::__construct();
    }

    private function validType($entityType)
    {
        return in_array($entityType, array('child', 'school'), true);
    }

    private function validSide($side)
    {
        return in_array($side, array('parent', 'school'), true);
    }

    private function validRole($role)
    {
        return in_array($role, array('parent', 'matron', 'school_admin', 'super_admin'), true);
    }

    /**
     * Pata nafasi moja ya entity (child/school).
     */
    public function getCoordinate($entityType, $entityId)
    {
        if (!$this->validType($entityType)) return null;
        $entityId = intval($entityId);
        if ($entityId <= 0) return null;

        $sql = "SELECT * FROM {$this->table}
                WHERE entity_type='" . $this->con->real_escape_string($entityType) . "'
                AND entity_id=$entityId LIMIT 1";
        $res = $this->con->query($sql);
        if ($res && $res->num_rows > 0) return $res->fetch_assoc();
        return null;
    }

    /**
     * Hifadhi nafasi mpya au badilisha iliyopo.
     *
     * Upande uliohifadhi unathibitisha nafasi hiyo mara moja; upande wa
     * pili unafutwa na utahitaji uthibitisho mpya. Hii inazuia nafasi
     * iliyobadilishwa kuendelea kuonekana kama halali.
     */
    public function saveCoordinate(
        $entityType,
        $entityId,
        $latitude,
        $longitude,
        $label,
        $userId,
        $role,
        $side
    ) {
        if (!$this->validType($entityType) || !$this->validSide($side) || !$this->validRole($role)) {
            return null;
        }

        $entityId = intval($entityId);
        $userId = intval($userId);
        if ($entityId <= 0 || $userId <= 0) return null;

        $lat = number_format((float) $latitude, 7, '.', '');
        $lng = number_format((float) $longitude, 7, '.', '');
        $labelSql = ($label === null || trim((string) $label) === '')
            ? 'NULL'
            : "'" . $this->con->real_escape_string(trim((string) $label)) . "'";
        $typeSql = "'" . $this->con->real_escape_string($entityType) . "'";
        $roleSql = "'" . $this->con->real_escape_string($role) . "'";

        if ($side === 'parent') {
            $parentBy = $userId;
            $parentAt = 'NOW()';
            $schoolBy = 'NULL';
            $schoolAt = 'NULL';
        } else {
            $parentBy = 'NULL';
            $parentAt = 'NULL';
            $schoolBy = $userId;
            $schoolAt = 'NOW()';
        }

        $existing = $this->getCoordinate($entityType, $entityId);
        if ($existing) {
            $id = intval($existing['id']);
            $sql = "UPDATE {$this->table} SET
                    latitude=$lat,
                    longitude=$lng,
                    label=$labelSql,
                    proposed_by=$userId,
                    proposed_role=$roleSql,
                    parent_confirmed_by=$parentBy,
                    parent_confirmed_at=$parentAt,
                    school_confirmed_by=$schoolBy,
                    school_confirmed_at=$schoolAt
                    WHERE id=$id";
            if (!$this->con->query($sql)) return null;
        } else {
            $sql = "INSERT INTO {$this->table}
                    (entity_type, entity_id, latitude, longitude, label,
                     proposed_by, proposed_role,
                     parent_confirmed_by, parent_confirmed_at,
                     school_confirmed_by, school_confirmed_at)
                    VALUES
                    ($typeSql, $entityId, $lat, $lng, $labelSql,
                     $userId, $roleSql,
                     $parentBy, $parentAt,
                     $schoolBy, $schoolAt)";
            if (!$this->con->query($sql)) return null;
        }

        return $this->getCoordinate($entityType, $entityId);
    }

    /**
     * Thibitisha nafasi iliyopo kwa upande mmoja (parent/school).
     */
    public function confirmCoordinate($entityType, $entityId, $userId, $side)
    {
        if (!$this->validType($entityType) || !$this->validSide($side)) return null;
        $entityId = intval($entityId);
        $userId = intval($userId);
        if ($entityId <= 0 || $userId <= 0) return null;

        $existing = $this->getCoordinate($entityType, $entityId);
        if (!$existing) return null;

        $id = intval($existing['id']);
        $typeSql = "'" . $this->con->real_escape_string($entityType) . "'";
        if ($side === 'parent') {
            $set = "parent_confirmed_by=$userId, parent_confirmed_at=NOW()";
        } else {
            $set = "school_confirmed_by=$userId, school_confirmed_at=NOW()";
        }

        if (!$this->con->query("UPDATE {$this->table} SET $set
            WHERE entity_type=$typeSql AND entity_id=$entityId AND id=$id")) {
            return null;
        }

        return $this->getCoordinate($entityType, $entityId);
    }

    /**
     * SQL ya msingi ya orodha ya watoto pamoja na nafasi zao.
     */
    private function childSelect($join, $where)
    {
        return "SELECT c.id AS child_id,
                       c.first_name,
                       c.last_name,
                       c.class_name,
                       c.school_id,
                       s.name AS school_name,
                       co.id AS coordinate_id,
                       co.latitude AS coordinate_latitude,
                       co.longitude AS coordinate_longitude,
                       co.label AS coordinate_label,
                       co.proposed_by AS coordinate_proposed_by,
                       co.proposed_role AS coordinate_proposed_role,
                       co.parent_confirmed_at AS coordinate_parent_confirmed_at,
                       co.school_confirmed_at AS coordinate_school_confirmed_at,
                       co.updated_at AS coordinate_updated_at
                FROM children c
                INNER JOIN schools s ON s.id = c.school_id
                $join
                LEFT JOIN {$this->table} co
                  ON co.entity_type='child' AND co.entity_id=c.id
                WHERE $where
                ORDER BY c.first_name ASC, c.last_name ASC";
    }

    public function childrenForParent($parentId)
    {
        $parentId = intval($parentId);
        if ($parentId <= 0) return array();
        $sql = $this->childSelect(
            "INNER JOIN parent_children pc ON pc.child_id=c.id AND pc.parent_id=$parentId",
            "c.status='active'"
        );
        return $this->rows($sql);
    }

    public function childrenForSchool($schoolId)
    {
        $schoolId = intval($schoolId);
        if ($schoolId <= 0) return array();
        $sql = $this->childSelect('', "c.school_id=$schoolId AND c.status='active'");
        return $this->rows($sql);
    }

    public function allChildren()
    {
        return $this->rows($this->childSelect('', "c.status='active'"));
    }

    /**
     * SQL ya shule pamoja na nafasi zao.
     */
    private function schoolSelect($where)
    {
        return "SELECT s.id AS school_id,
                       s.name AS school_name,
                       co.id AS coordinate_id,
                       co.latitude AS coordinate_latitude,
                       co.longitude AS coordinate_longitude,
                       co.label AS coordinate_label,
                       co.proposed_by AS coordinate_proposed_by,
                       co.proposed_role AS coordinate_proposed_role,
                       co.parent_confirmed_at AS coordinate_parent_confirmed_at,
                       co.school_confirmed_at AS coordinate_school_confirmed_at,
                       co.updated_at AS coordinate_updated_at
                FROM schools s
                LEFT JOIN {$this->table} co
                  ON co.entity_type='school' AND co.entity_id=s.id
                WHERE $where
                ORDER BY s.name ASC";
    }

    public function schoolsByIds($schoolIds)
    {
        $ids = array();
        foreach ((array) $schoolIds as $id) {
            $id = intval($id);
            if ($id > 0) $ids[$id] = $id;
        }
        if (empty($ids)) return array();
        $list = implode(',', array_values($ids));
        return $this->rows($this->schoolSelect("s.id IN ($list)"));
    }

    public function allSchools()
    {
        return $this->rows($this->schoolSelect('1=1'));
    }

    private function rows($sql)
    {
        $res = $this->con->query($sql);
        if ($res && $res->num_rows > 0) return $res->fetch_all(MYSQLI_ASSOC);
        return array();
    }
}
