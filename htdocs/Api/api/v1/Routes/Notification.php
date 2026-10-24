<?php

include_once __DIR__.'/../Controller/NotificationController.php';

class Notification extends NotificationController
{


    private $data,$clean;

    public function __construct()
    {
        parent::__construct();

        $this->clean = new Util();
        $this->data = isset($_POST) && count($_POST) > 0 ? parent::decode(parent::encode($_POST)) : parent::decode(file_get_contents("php://input"));
    }

    public function add($data)
    {
        if($this->clean->Method() !== "POST" && !(array) $this->data && !Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 403;
        $data = $this->data;

        $type = isset($data->type) ? $this->clean->clean_input($data->type) : '';
        $title = isset($data->title) ? $this->clean->clean_input($data->title) : '';
        $message = isset($data->message) ? $this->clean->clean_input($data->message) : '';
        $logo = Util::get_site_url().'/public/images/logo.png';

        $user = new UsersController();
        $user_id = ($user->get(Util::$token))->id;
        $receiver_id = '';//get all users from the data base and blast

        $data = "Sorry something went wrong!";
        $sql = parent::add($this->encode(['sender'=>$user_id, 'receiver'=>$receiver_id,'title'=>$title,"content"=>$message]));
        if($sql){
            $status = 200;
            $data = "Notification was added successful!";

            // fetch token
            $ntoken ='';
            parent::send_notification(parent::encode(["to"=>$ntoken,
                "body"=>["title"=>$title,"body"=>$message,"mutable_content"=>true,"type"=>$type],
                "data"=>["url"=>$logo,"dl"=>""]]));
        }

        return array('status'=>$status, 'payload'=>$data);
    }


    public function add_token(){
        print_r("Hello World");
    }

}

//$class = new Notifications();