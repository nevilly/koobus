<?php
include_once __DIR__ ."/../Controller/AdsController.php";
//include_once __DIR__ . "/../Controller/UsersController.php";
include_once __DIR__."/../Util/Util.php";
//use PostController\PostController;

class Ads extends AdsController
{
    private $data;
    private $clean;
    private $key;

    /**
     * Posts constructor.
     */
    public function __construct()
    {
        parent::__construct();

        $this->clean = new Util();
        $this->data = isset($_POST) && count($_POST) > 0 ? parent::decode(parent::encode($_POST)) : parent::decode(file_get_contents("php://input"));

        $this->key = koobus_env("SECRET");
    }

    /**
     * @return array
     * @throws Exception
     */
    public function add(){

        if($this->clean->Method() !== "POST" && !(array) $this->data )
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = $this->data;
        $pid = $data->productId;
        $tablename = $data->tablename;
        $ad_type = $data->ad_type;
        $selectPlatform = $data->selectPlatform;
        $device = $data->device;
        $ad_unit = $data->ad_unit;
        $rate = $data->rate;
        $img = $data->img;
        $price = $data->price;
        $bookDate = $data->bookDate;
        $dimension = $data->dimension;

        $status = 401;
        $data = 'All fields are required!';

        // Validate user

        if(!empty($pid)){
            $status = 401;
            $data = "Sorry  try to add again!";

            $user = new UsersController();
            $users = $user->get(Util::$token);
           // $username = $users->username;
           //echo $user_id = $users->id;

            if(!empty($pid)){
                $sql = parent::addCart(parent::encode(array("pId"=>$pid,'tablename'=>$tablename,
                    'ad_type'=>$ad_type,
                    'selectPlatform'=>$selectPlatform,
                    'device'=>$device,
                    'ad_unit'=>$ad_unit,
                    'rate'=>$rate,
                    'userID'=>$user_id,
                    'dimension'=>$dimension,
                    'price'=>$price,
                    'img'=>$img,
                    'bookDate'=>$bookDate,
                    'qty'=>'1')));

                $data = 'Sorry something went wrong, Please try again!';
                if($sql){
                    $status = 200;
                    $data = 'Ads added to Booking system.';
                }
            }
        }

        return array('status'=>$status, 'payload'=>$data);
    }
    /**
     * @return array
     * @throws Exception
     */
    public function getx(){

        if($this->clean->Method() !== "POST" && !(array) $this->data )
            return array('status'=>403,'payload'=>"Unauthorized Accesxss");

        $data = $this->data;
        $pid = $data->productId;
       // $tablename = $data->tablename;

        $status = 401;
        $data = 'All fields are required!';
         $id = '';
         $limit = '';
        // Validate user

        
            $status = 401;
            $data = "Sorry  try to add again!";

            //$user = new UsersController();
            //$users = $user->get(Util::$token);
           // $username = $users->username;
           
           $data = 'No content';
           $status = 401;

        $sql = parent::get($pid,$limit);
        if($sql) {

            $status = 200;
            foreach ($sql as $key=>$value){
       
                // if (!empty($invitationCardsIds)) {
                //     # code...
                //    $invCard_arr =  explode(',', $invitationCardsIds);      
                
                //    foreach($invCard_arr as $c){
            
                //         $invCard = $MwalikoCard->get_by_idsa($c);
                    
                //         if($invCard !== false)
                //            $mwalikoArr[] = $invCard;

                //     }

                // }
            
               
                //$user = $userd->get($sql[$key]['user']);
                //$username = $user->username;
               // $avatar = $user->avatar;
             
              //   $sql[$key]['washereheshaji'] = $ary;
              //   $sql[$key]['MwalikoCards'] = $mwalikoArr;
            }

            $data = $sql;
        }
        

        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * @param string $a
     * @return array
     * @throws Exception
     */
    public function update($a ='')
    {
        if($this->clean->Method() !== "POST" && !(array) $this->data  && !Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = $this->data;
        $title = isset($data->title) ? $this->clean->clean_input($data->title) :'';
        $desc = isset($data->description) ? $this->clean->clean_input($data->description) :'';

        $user = new UsersController();
        $users = $user->get(Util::$token);
        $user_id = $users->id;

        $status = 401;
        $data = 'All fields are required!';

        if(!empty($title) && !empty($category)
            && !empty($address) && !empty($desc) && !empty($id)){

            $sql = parent::update(parent::encode(array("id"=>$id,"user"=>$user_id)));

            $data = 'Sorry something went wrong, Please try again!';
            if($sql){
                $status = 200;
                $data = 'Application was update successful!';
            }
        }

        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * @param $params
     * @return array
     */
    public function application($params){

        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = parent::decode($params);

        $id = '';
        if(!empty($data->page) && !empty($data->page1) && empty($data->page2) && empty($data->page3) && empty($data->page4))
            $limit = "$data->page,$data->page1";
        else{
            $id = isset($data->page) && !empty($data->page) ? $data->page :'';
            $page = isset($data->page2) && !empty($data->page2) ? $data->page1 :'';
            $limit = isset($data->page3) && !empty($data->page3) ? "$page,$data->page2" :'';
        }

        // get category id
        include_once __DIR__."/../Controller/UsersController.php";

        $data = 'No content';
        $status = 401;

        $sql = parent::get($id,$limit);
        if($sql) {

            $status = 200;
            $userd = new UsersController();
            foreach ($sql as $key=>$value){
                $user = $userd->get($sql[$key]['user']);
                $username = $user->username;
                $avatar = $user->avatar;
                $sql[$key]['user'] = $username;
                $sql[$key]['avatar'] = $avatar;
            }

            $data = $sql;
        }

        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * @param $params
     * @return array
     * @throws Exception
     */
    public function remove($params){
        if($this->clean->Method() !== "POST" )
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 403;
        $data = 'Unauthorized Access';

        //$userd = new UsersController();
       // $user_id = ($userd->getUserIdByToken(Util::$token))->id;

        if( !empty($this->data->id)) {
            if(parent::deleteCart($this->data->id, '')){
                $status = 200;
                $data = "Booking was successful Removed!";
            }
        }
        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * @param $params
     */
    public function my_application($params){
        if($this->clean->Method() !== "GET" || !Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $num = '';
        $page ='';
        $category ='';
        if(is_array((array) $this->data)){
            $data = parent::decode($params);

            $category = isset($data->page) && !empty($data->page) ? $data->page :'';
            $num = isset($data->page1) && !empty($data->page1) ? $data->page1 :'';
            $page = isset($data->page2) && $data->page2 !== '' ? $data->page2 :'';
        }


        include_once __DIR__."/../Controller/UsersController.php";
        $limit = !empty($page) && !empty($num) ? "$page,$num" : '';
        $userd = new UsersController();
        $user_id = ($userd->getUserIdByToken(Util::$token))->id;
        $sql = parent::get_by_user($user_id, $limit);

        $data = "No content!";
        if($sql) {
            $status = 200;
            $userd = new UsersController();
            foreach ($sql as $key=>$value){
                $user = ($userd->get($sql[$key]['user']));
                $username = $user->username;
                $avatar = $user->avatar;
                $sql[$key]['username'] = $username;
                $sql[$key]['avatar'] = "public/uploads/".strtolower($username)."/data/".$avatar;
                $sql[$key]['title'] = $value['title'];
                $sql[$key]['description'] = nl2br($value['description']);
                $sql[$key]['responsibilities'] = nl2br($value['responsibilities']);
                $sql[$key]['created_at'] = Util::ago($value['created_at']);
                $sql[$key]['deadline'] = date("M, d Y", strtotime($value['deadline']));
                $sql[$key]['salary_min'] = Util::short_number((int) $value['salary_min']);
                $sql[$key]['type'] = ucfirst($sql[$key]['type']);
                $sql[$key]['featured'] = (int) $sql[$key]['featured'] > 0;
                $sql[$key]['salary_max'] = Util::short_number((int) $value['salary_max']);
                $sql[$key]['logo'] = "public/uploads/".strtolower($username)."/data/".$value['logo'];
            }

            $data = $sql;
        }

        return array('status'=>$status, 'payload'=>$data);
    }
}

$class = new Ads();