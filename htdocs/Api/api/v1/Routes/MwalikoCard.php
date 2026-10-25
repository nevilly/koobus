<?php
include_once __DIR__ ."/../Controller/MwalikoCardController.php";
//include_once __DIR__ . "/../Controller/UsersController.php";
include_once __DIR__."/../Util/Util.php";
//use PostController\PostController;

class MwalikoCard extends MwalikoCardController
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
    public function getx(){

        if($this->clean->Method() !== "POST" && !(array) $this->data )
            return array('status'=>403,'payload'=>"Unauthorized Accessx");

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
           // $userd = new UsersController();
            foreach ($sql as $key=>$value){
                //$user = $userd->get($sql[$key]['user']);
                //$username = $user->username;
               // $avatar = $user->avatar;
                //$sql[$key]['user'] = $username;
               // $sql[$key]['avatar'] = $avatar;
            }

            $data = $sql;
        }
        

        return array('status'=>$status, 'payload'=>$data);
    }




}

$class = new MwalikoCard();