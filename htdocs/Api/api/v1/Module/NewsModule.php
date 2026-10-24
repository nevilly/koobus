<?php

include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Module/Database.php";

class NewsModule extends Database
{

    private $table = "news";

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
        $where = !empty($id)? "id='$id' AND payed = '0'" :'';

       

             return parent::query(parent::encode(['query'=>"select COUNT(*) as Cnt from $this->table  where payed = '0' $limit "])); 
    }

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_news($id = '',$limit =''){

             return parent::query(parent::encode(['query'=>"select * from $this->table   $limit "])); 
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