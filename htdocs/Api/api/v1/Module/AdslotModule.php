<?php

include_once __DIR__."/../Module/Database.php";

class AdslotModule extends Database
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
    public function addEmployee($data){
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

    public function get_by_PersonalAttendency($id, $limit =''){
        $where = !empty($id)? "user_id='$id'" :'';

        print_r($id);

          return parent::query(parent::encode(['query'=>"select t.*, t.id as tId, e.*, e.id as eId, e.user_id as euId FROM emplyeeattendence as t left join employee as e ON(t.user_id = e.id) where t.user_id = '$id' $limit"]));
    }
    public function get_groupedData($id, $limit =''){
        $where = !empty($id)? "user_id='$id'" :'';

        

          return parent::query(parent::encode(['query'=>"select t.*, t.id as tId, e.*, e.id as eId ,DATE_FORMAT(t.ddate, '%e/%b/%Y') AS formatted_date FROM emplyeeattendence as t left join employee as e ON(t.user_id = e.id) where t.user_id = '$id' ORDER BY createDate"]));
    }

    /**
     * @param $title
     * @return mixed
     */
    public function checkEmployee($title){
        return parent::select(parent::encode(array("table"=>$this->table,'cols'=>"id",'where'=>"title Like '%$title'", 'limit'=>1)));
    }

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function getAll_AttendencyById($id = '',$limit =''){
    
        $where = !empty($id)? "where p.user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select u.*,p.* from $this->table as p left join employee as u ON(p.user_id = u.id) $where $limit"]));
    } 
    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get($id = '',$limit =''){
        $date  =  date("Y-m-d");
        $where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select u.first_name,u.last_name,u.avatar,p.* from $this->table as p left join users as u ON(p.user_id = u.id) where ddate='$date' $limit"]));
    }   

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_attendency_by_today($id = '',$limit =''){
        $date  =  date("Y-m-d");
        $where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select p.*,p.id as pId, u.*,u.id as uId,u.user_id as uUserId from employee as p left join emplyeeattendence as u ON(p.id = u.user_id) AND u.ddate='$date' $limit"]));
    }

    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_attendency_by_groupMonth($id = '',$limit =''){
            $where = !empty($id)? "user_id='$id'" :'';

        

          return parent::query(parent::encode(['query'=>"select t.*, t.id as tId, e.*, e.id as eId ,DATE_FORMAT(t.ddate, '%e/%b/%Y') AS formatted_date FROM emplyeeattendence as t left join employee as e ON(t.user_id = e.id) $where ORDER BY createDate"]));
    }


    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_employee_Profile($id = '',$limit =''){
        $where = !empty($id)? "where id='$id'" :'';

        return parent::query(parent::encode(['query'=>"SELECT * FROM employee $where "]));
    }

   
         /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_inEmployee($id = '',$limit =''){
        $date = date('Y-m-d');
        $where = !empty($id)? "where user_id='$id'" :'';

        // return parent::query(parent::encode(['query'=>"SELECT * FROM `employee` as e Left join emplyeeattendence as m on(e.id = m.user_id) AND m.ddate = $date $limit"]));

     return parent::query(parent::encode(['query'=>"Select u.first_name,u.last_name,u.avatar,p.* from employee as p left join users as u ON(p.user_id = u.id) $where $limit"]));
    }


    public function getx($user, $limit =''){
        $where = !empty($user)? "user_id='$user'" :'';

        $sql = ['table'=>$this->table,'where'=>$where,'limit'=>chop($limit,',')];
//        print_r($sql);
        return parent::select(parent::encode($sql));
    }



    public function get_by_EmployeeAtt($user, $limit =''){
        $where = !empty($user)? "user_id='$user'" :'';

        $sql = ['table'=>$this->table,'where'=>$where,'limit'=>chop($limit,',')];
        // print_r($sql);
        return parent::select(parent::encode($sql));
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

    public function deleteEmployee($id, $user)
    {
        $where = !empty($id) ? "user_id='$id'" :'';

        return parent::delete(parent::encode(['table'=>$this->table,'where'=>$where]));
    }


    ////// Mwananchi Assaigment

        /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_displayRate($id = '',$limit =''){
       // $date  =  date("Y-m-d");
        $where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select * from m_display_rate_card  $limit"]));
    }
        /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_displayRate_by_pid($id = '',$table =''){
       // $date  =  date("Y-m-d");
        $where = !empty($id)? "where p='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select * from table where id = '$id' "]));
    }
        /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_sponser_content($id = '',$limit =''){
       // $date  =  date("Y-m-d");
        //$where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select * from  m_sponsered_content  $limit"]));
    }
        /**
     * @param string $id
     * @param string $limit
     * @return mixed

     
     */
    public function get_social_medias($id = '',$limit =''){
       // $date  =  date("Y-m-d");
        //$where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select * from  m_social_media  $limit"]));
    }
        /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_vedeo_production($id = '',$limit =''){
       // $date  =  date("Y-m-d");
        //$where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select * from  m_vedeo_production  $limit"]));
    }










    /**
     * @param string $id
     * @param string $limit
     * @return mixed
     */
    public function get_newz($brand = '',$category =''){
       // $date  =  date("Y-m-d");
        //$where = !empty($id)? "where user_id='$id'" :'';

        return parent::query(parent::encode(['query'=>"Select * from  news where category = '$category' AND brand = '$brand' "]));
    }
}