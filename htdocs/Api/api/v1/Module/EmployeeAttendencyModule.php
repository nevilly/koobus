<?php

include_once __DIR__."/../Module/Database.php";

class EmployeeAttendencyModule extends Database
{

    private $table = "emplyeeattendence";

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @param $data
     * @return false
     */
    public function add_empAttndcy($data){
        $data = (array) parent::decode($data);
        $status = false;
        $d = '';

        if(count($data) > 0){

            foreach ($data as $key=>$value) {
                if(!empty($value))
                    $d .= "$key='$value',";
            }

            $d = chop($d,',');

            $status = parent::insert(parent::encode(array("table"=>$this->table,"data"=>"$d,createDate=NOW()")));
        }

        return $status;
    }

    /**
     * @param $title
     * @return mixed
     */
    public function check_empAttndcy($title){
        return parent::select(parent::encode(array("table"=>$this->table,'cols'=>"id",'where'=>"title Like '%$title'", 'limit'=>1)));
    }

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_empAttndcy($id = '',$limit =''){
        $where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select u.first_name,u.last_name,u.avatar,p.* from $this->table as p left join users as u ON(p.user_id = u.id) $where $limit"]));
    }

  

    public function get($user, $limit =''){
        $where = !empty($user)? "user_id='$user'" :'';

        $sql = ['table'=>$this->table,'where'=>$where,'limit'=>chop($limit,',')];
//        print_r($sql);
        return parent::select(parent::encode($sql));
    }

    public function get_by_empAttndcy($user, $limit =''){
        $where = !empty($user)? "user='$user'" :'';

        $sql = ['table'=>$this->table,'where'=>$where,'limit'=>chop($limit,',')];
//        print_r($sql);
        return parent::select(parent::encode($sql));
    }

    /**
     * @param $data
     * @return false|mixed
     */
    public function update_empAttndcy($data)
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

    public function delete_empAttndcy($id, $user)
    {
        $where = !empty($id)  ? "user_id='$id'" :'';

        return parent::delete(parent::encode(['table'=>$this->table,'where'=>$where]));
    }
}