<?php

include_once __DIR__."/../Module/Database.php";

class AdsModule extends Database
{

    private $table = "ads";

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @param $data
     * @return false
     */
    public function addCart($data){
        $data = (array) parent::decode($data);
        $status = false;
        $d = '';

        if(count($data) > 0){

            foreach ($data as $key=>$value) {
                if(!empty($value))
                    $d .= "$key='$value',";
            }

            $d = chop($d,',');

            $status = parent::insert(parent::encode(array("table"=>$this->table,"data"=>"$d,createdDate =NOW()")));
        }

        return $status;
    }

    /**
     * @param $title
     * @return mixed
     */
    public function checkApplication($title){
        return parent::select(parent::encode(array("table"=>$this->table,'cols'=>"id",'where'=>"title Like '%$title'", 'limit'=>1)));
    }

  

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get($id = '',$limit =''){
        echo '1';
        $where = !empty($id)? "Where id='$id'" :'';

        return parent::query(parent::encode(['query'=>"select * from $this->table $where  $limit "])); 
    }

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_by_kifurushiId($id = '',$limit =''){
    
        $where = !empty($id)? "Where id='$id'" :'';

        return parent::query(parent::encode(['query'=>"select * from $this->table Where kifurushi_id='$id'  $limit "])); 
    }

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_carts($id = '',$limit =''){
        $where = !empty($id)? "id='$id' AND payed = '0'" :'';


             return parent::query(parent::encode(['query'=>"select COUNT(*) as Cnt from $this->table  where payed = '0' $limit "])); 
    }


    /**
     * @param $data
     * @return false|mixed
     */
    public function update($data)
    {
        $data = (array) parent::decode($data);
        $status = false;
        $d = '';

        if(count($data) > 0){

            foreach ($data as $key=>$value) {
                if(!empty($value) && $key != 'id' ||  !empty($value) && $key != 'user_id')
                    $d .= "$key='$value',";
            }

            $d = chop($d,',');
            $id = $data['id'];
            $userid = $data['user_id'];

            $status = parent::update(parent::encode(array("table"=>$this->table,"data"=>"$d",'where'=>"id='$id' AND user='$userid'")));
        }

        return $status;
    }

    public function deleteCart($id, $user)
    {
        $where = !empty($id) ? "id='$id'" :'';

        return parent::delete(parent::encode(['table'=>$this->table,'where'=>$where]));
    }
}