<?php


include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/CategoriesController.php";
include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Util/Util.php";

class Categories extends CategoriesController
{
    private $data;
    private $clean;
    private $key;

    public function __construct()
    {
        parent::__construct();

        $this->clean = new Util();
        $this->data = isset($_POST) && count($_POST) > 0 ? parent::decode(parent::encode($_POST)) : parent::decode(file_get_contents("php://input"));

        $this->key = getenv("SECRET");
    }

    public function add_category(){
        if($this->clean->Method() !== "POST" && !(array) $this->data && !Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = $this->data;

        $status = 401;
        $message = 'All fields are required!';


        if(!empty($data->name))
            if(parent::addCategory(parent::encode(["name"=>$data->name]))){
                $status = 200;
                $message = "Category created!";
            }

        return array('status'=>$status, 'payload'=>$message);
    }

    public function all(){
        if($this->clean->Method() !== "GET")
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 201;
        $data = $this->data;

        $c = parent::get();
        if($c){
            $status = 200;
            $data = $c;
        }


        return array('status'=>$status, 'payload'=>$data);
    }
}

//$class = new Categories();