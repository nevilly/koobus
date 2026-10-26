<?php
// KOO_BUS_ADAPT: Trips module
include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class TripsModule extends Database
{
    private $table = "trips";

    public function __construct()
    {
        parent::__construct();
    }

    public function add($data){
        $data = (array) $this->decode($data);
        $vs = '';
        if(is_array($data)){
            foreach ($data as $key => $value) {
                if($value === null || $value === '') continue;
                // allow datetime strings as-is
                $vs .= "$key='".$this->con->real_escape_string($value)."',";
            }
            $vs = chop($vs, ',');
        }
        if(empty($vs)) return false;
        $sql = parent::insert($this->encode(['table'=>$this->table, 'data'=>$vs]));
        return ($sql) ? $this->con->insert_id : $sql;
    }

    public function update_trip($data){
        $data = (array) parent::decode($data);
        $d = '';
        if(count($data) > 0){
            foreach ($data as $key=>$value) {
                if($key !== 'id' && $value !== null && $value !== ''){
                    $d .= "$key='".$this->con->real_escape_string($value)."',";
                }
            }
            $d = chop($d,',');
            if(empty($d)) return false;
            $id = intval($data['id']);
            $status = parent::update(parent::encode(array("table"=>$this->table,"data"=>"$d","where"=>"id='$id'")));
            return $status;
        }
        return false;
    }

    public function get($id = ''){
        $str = '';
        if(!empty($id)){
            if(is_numeric($id)) $str = "id=".intval($id);
        }
        return parent::select(parent::encode(['table'=>$this->table,'where'=>$str]));
    }

    public function get_by_driver($driver_id){
        if(empty($driver_id)) return false;
        $driver_id = intval($driver_id);
        // Safari zilizopangwa huja kwanza kwa muda; zisizo na ratiba
        // (data ya zamani) zinawekwa mwisho.
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"driver_id='$driver_id' ORDER BY CASE WHEN scheduled_at IS NULL THEN 1 ELSE 0 END ASC, scheduled_at ASC, id ASC"]));
    }

    public function get_by_route($route_id){
        if(empty($route_id)) return false;
        $route_id = intval($route_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"route_id='$route_id' ORDER BY id DESC"]));
    }

    public function get_active_by_driver($driver_id){
        if(empty($driver_id)) return false;
        $driver_id = intval($driver_id);
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"driver_id='$driver_id' AND status='active'"]));
    }

    /**
     * KOO_BUS_ADAPT: manifest ya wanafunzi kwa safari.
     *
     * Mpangilio ni kwa kituo cha safari:
     *  - asubuhi: pickup_stop (wa kwanza kupanda)
     *  - mchana: dropoff_stop (wa kwanza kushuka)
     *
     * `attendance_status` ni event ya mwisho ya mtoto kwenye safari hii.
     * Watoto wasio na kituo wanawekwa mwisho; hatutengenezi kituo cha mfano.
     */
    public function get_manifest($trip_id, $route_id, $trip_type){
        $trip_id = intval($trip_id);
        $route_id = intval($route_id);
        if($trip_id <= 0 || $route_id <= 0) return false;

        $orderExpr = ($trip_type === 'morning')
            ? 'COALESCE(ps.stop_order, 999999)'
            : 'COALESCE(ds.stop_order, 999999)';

        $sql = "SELECT c.id,
                       c.first_name,
                       c.last_name,
                       c.class_name,
                       c.route_id,
                       c.pickup_stop_id,
                       ps.name AS pickup_stop_name,
                       ps.stop_order AS pickup_stop_order,
                       c.dropoff_stop_id,
                       ds.name AS dropoff_stop_name,
                       ds.stop_order AS dropoff_stop_order,
                       e.event_type AS attendance_status,
                       e.created_at AS attendance_at
                FROM children c
                LEFT JOIN route_stops ps ON ps.id = c.pickup_stop_id
                LEFT JOIN route_stops ds ON ds.id = c.dropoff_stop_id
                LEFT JOIN trip_events e ON e.id = (
                    SELECT e2.id
                    FROM trip_events e2
                    WHERE e2.trip_id = $trip_id AND e2.child_id = c.id
                    ORDER BY e2.created_at DESC, e2.id DESC
                    LIMIT 1
                )
                WHERE c.route_id = $route_id AND c.status = 'active'
                ORDER BY $orderExpr ASC, c.first_name ASC, c.last_name ASC, c.id ASC";

        $res = $this->con->query($sql);
        if(!$res){
            error_log("KooBus manifest error (trip $trip_id): " . $this->con->error);
            return false;
        }
        return $res->fetch_all(MYSQLI_ASSOC);
    }

    public function get_active(){
        return parent::select(parent::encode(['table'=>$this->table,'where'=>"status='active' ORDER BY started_at DESC"]));
    }

    /**
     * KOO_BUS_ADAPT: jina la route kwa taarifa za safari.
     */
    public function get_route_name($route_id){
        $route_id = intval($route_id);
        if($route_id <= 0) return '';
        $res = $this->con->query("SELECT name FROM routes WHERE id='$route_id' LIMIT 1");
        if(!$res || $res->num_rows === 0) return '';
        $row = $res->fetch_object();
        return $row && isset($row->name) ? $row->name : '';
    }

    /**
     * KOO_BUS_ADAPT: wapokeaji wa taarifa ya kuanza safari.
     *
     * - wazazi waliounganishwa na watoto walio kwenye route
     * - school_admin wa shule
     * - matron/patron aliyepangiwa safari
     *
     * Tunatumia `users.status='1'` ili akaunti zilizozimwa zisipate taarifa.
     */
    public function get_start_recipients($route_id, $school_id, $matron_id = 0){
        $route_id = intval($route_id);
        $school_id = intval($school_id);
        $matron_id = intval($matron_id);
        $ids = array();

        if($route_id > 0){
            $sql = "SELECT DISTINCT pc.parent_id AS uid
                    FROM parent_children pc
                    INNER JOIN children c ON c.id = pc.child_id
                    INNER JOIN users u ON u.id = pc.parent_id
                    WHERE c.route_id='$route_id'
                      AND c.status='active'
                      AND u.status='1'";
            $res = $this->con->query($sql);
            if($res){
                while($row = $res->fetch_object()){
                    if(isset($row->uid) && intval($row->uid) > 0) $ids[] = intval($row->uid);
                }
            }
        }

        if($school_id > 0){
            $res = $this->con->query("SELECT id FROM users
                WHERE role='school_admin' AND school_id='$school_id' AND status='1'");
            if($res){
                while($row = $res->fetch_object()){
                    if(isset($row->id) && intval($row->id) > 0) $ids[] = intval($row->id);
                }
            }
        }

        if($matron_id > 0) $ids[] = $matron_id;

        return array_values(array_unique($ids));
    }

    public function start_trip($id, $started_early = false, $reason = null){
        if(empty($id)) return false;
        $id = intval($id);
        $now = date('Y-m-d H:i:s');
        $early = $started_early ? 1 : 0;
        $reasonSql = "NULL";
        if($early === 1){
            $reasonText = trim((string) $reason);
            if($reasonText === '') $reasonText = 'Dharura ya shule';
            $reasonSql = "'".$this->con->real_escape_string($reasonText)."'";
        }
        $data = "status='active', started_at='$now', started_early='$early', early_start_reason=$reasonSql";
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>$data,"where"=>"id='$id' AND status='pending'")));
    }

    public function end_trip($id){
        if(empty($id)) return false;
        $id = intval($id);
        $now = date('Y-m-d H:i:s');
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>"status='completed', ended_at='$now'","where"=>"id='$id' AND status='active'")));
    }

    public function cancel_trip($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::update(parent::encode(array("table"=>$this->table,"data"=>"status='cancelled'","where"=>"id='$id' AND status IN ('pending','active')")));
    }

    public function delete_trip($id){
        if(empty($id)) return false;
        $id = intval($id);
        return parent::delete($this->encode(['table'=>$this->table, "where"=>"id='$id'"]));
    }
}
