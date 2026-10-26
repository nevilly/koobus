<?php
// KOO_BUS_ADAPT: Coordinates controller
include_once $_SERVER["DOCUMENT_ROOT"] . "/api/v1/Module/CoordinatesModule.php";

class CoordinatesController extends CoordinatesModule
{
    public function __construct()
    {
        parent::__construct();
    }

    public function get_coordinate($entityType, $entityId)
    {
        return parent::getCoordinate($entityType, $entityId);
    }

    public function save_coordinate(
        $entityType,
        $entityId,
        $latitude,
        $longitude,
        $label,
        $userId,
        $role,
        $side
    ) {
        return parent::saveCoordinate(
            $entityType,
            $entityId,
            $latitude,
            $longitude,
            $label,
            $userId,
            $role,
            $side
        );
    }

    public function confirm_coordinate($entityType, $entityId, $userId, $side)
    {
        return parent::confirmCoordinate($entityType, $entityId, $userId, $side);
    }

    public function children_for_parent($parentId)
    {
        return parent::childrenForParent($parentId);
    }

    public function children_for_school($schoolId)
    {
        return parent::childrenForSchool($schoolId);
    }

    public function all_children()
    {
        return parent::allChildren();
    }

    public function schools_by_ids($schoolIds)
    {
        return parent::schoolsByIds($schoolIds);
    }

    public function all_schools()
    {
        return parent::allSchools();
    }
}
