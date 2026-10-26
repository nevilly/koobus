<?php
// KOO_BUS_ADAPT: Locations module (GPS tracking)
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class LocationsModule extends Database
{
    private $table = "locations";

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * KOO_BUS_ADAPT: safu zinazoruhusiwa tu. Bila whitelist, key yoyote
     * ya JSON ingeingizwa kwenye INSERT (SQL injection kupitia key).
     */
    private $allowed = array(
        'trip_id', 'driver_id', 'latitude', 'longitude', 'speed', 'accuracy'
    );

    public function add($data){
        $data = (array) $this->decode($data);
        $vs = '';
        if(is_array($data)){
            foreach ($data as $key => $value) {
                if(!in_array($key, $this->allowed, true)) continue;
                if($value === null || $value === '') continue;
                $vs .= "$key='".$this->con->real_escape_string($value)."',";
            }
            $vs = chop($vs, ',');
        }
        if(empty($vs)) return false;
        $sql = parent::insert($this->encode(['table'=>$this->table, 'data'=>$vs]));
        return ($sql) ? $this->con->insert_id : $sql;
    }

    public function get_latest_by_trip($trip_id){
        if(empty($trip_id)) return false;
        $trip_id = intval($trip_id);
        $sql = "SELECT * FROM {$this->table} WHERE trip_id='$trip_id' ORDER BY id DESC LIMIT 1";
        return $this->con->query($sql);
    }

    public function get_latest_by_trips($trip_ids){
        if(empty($trip_ids) || !is_array($trip_ids)) return false;
        $ids = array();
        foreach($trip_ids as $tid){ if(is_numeric($tid)) $ids[] = intval($tid); }
        if(empty($ids)) return false;
        $in = implode(',', $ids);
        $sql = "SELECT l.* FROM {$this->table} l INNER JOIN (SELECT trip_id, MAX(id) as maxid FROM {$this->table} WHERE trip_id IN ($in) GROUP BY trip_id) m ON l.id = m.maxid";
        return $this->con->query($sql);
    }

    public function get_by_trip($trip_id, $limit=50){
        if(empty($trip_id)) return false;
        $trip_id = intval($trip_id);
        $limit = intval($limit);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"trip_id='$trip_id' ORDER BY id DESC LIMIT $limit"]));
    }

    public function delete_old($days=7){
        $days = intval($days);
        $sql = "DELETE FROM {$this->table} WHERE created_at < DATE_SUB(NOW(), INTERVAL $days DAY)";
        return $this->con->query($sql);
    }
}
