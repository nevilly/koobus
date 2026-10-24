<?php


include_once __DIR__."/../Module/Database.php";

class NotificationModule extends Database
{

    private $table = 'notifications';

    /**
     * NotificationModule constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @param $data
     * @return false|mixed
     */
    public function add($data){
        $data = (array) parent::decode($data);
        $status = false;
        $d = '';

        if(count($data) > 0){

            foreach ($data as $key=>$value) {
                if(!empty($value))
                    $d .= "$key='$value',";
            }

            $d = chop($d,',');

            $status = parent::insert(parent::encode(array("table"=>$this->table,"data"=>"$d,created_at=NOW()")));
        }

        return $status;
    }

    /**
     * @param string $limit
     * @return mixed
     */
    public function get($limit =''){
        return parent::select(parent::encode(['table'=>$this->table,'limit'=>$limit]));
    }
}