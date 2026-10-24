<?php
include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/TipController.php";
include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/UsersController.php";
include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Util/Util.php";
//use PostController\PostController;

class Tips extends TipController
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

        $this->key = getenv("SECRET");
    }

    /**
     * @return array
     * @throws Exception
     */
    public function add(){

        if($this->clean->Method() !== "POST" && !(array) $this->data || !Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = $this->data;
        $title = isset($data->title) ? $this->clean->clean_input($data->title) :'';
        $desc = isset($data->desc) ? $this->clean->clean_input($data->desc) :'';
        $media = isset($data->media) ? $this->clean->clean_input($data->media) :'';
        $keyword = isset($data->keyword) ? $this->clean->clean_input($data->keyword) :'';
        $type = isset($data->type) ? $this->clean->clean_input($data->type) :'';
        $category = isset($data->category) ? $this->clean->clean_input($data->category) :'';

        $status = 401;
        $data = 'All fields are required!';

        // Validate user

        if(!empty($title) && !empty($desc) && !empty($media) && !empty($category) && !empty($keyword) && !empty($type)){
            $status = 401;
            $data = "Sorry a user with the same content exists on our system. Please try another content!";

            if (!parent::checkTip($title)) {
                $user = new UsersController();
                $users = $user->get(Util::$token);
                $user_id = $users->id;

                $sql = parent::addTip(parent::encode(array("title" => $title, "description" => $desc, "tags" => $keyword,"status" => $type, "category" => $category, 'user' => $user_id, "featured" => $media)));

                $data = 'Sorry something went wrong, Please try again!';
                if ($sql) {
                    $status = 200;
                    $data = 'Post added successful!';
                }
            }
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

            $sql = parent::update_tip(parent::encode(array("title"=>$title,"id"=>$id,"description"=>$desc,"user"=>$user_id)));

            $data = 'Sorry something went wrong, Please try again!';
            if($sql){
                $status = 200;
                $data = 'Tip was update successful!';
            }
        }

        return array('status'=>$status, 'payload'=>$data);
    }

    /**
     * @param $params
     * @return array
     */
    public function post($params){

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

        $sql = parent::getPost($id,$limit);
        if($sql) {

            $status = 200;
            $userd = new UsersController();
            foreach ($sql as $key=>$value){
                $user = $userd->get($sql[$key]['user']);
                $username = $user->username;
                $avatar = $user->avatar;
                $sql[$key]['author'] = $username;
                $sql[$key]['avatar'] = $avatar;
                $sql[$key]['description'] = nl2br(urldecode($value['description']));
                $sql[$key]['created_at'] = Util::ago($value['created_at']);
                $sql[$key]['media'] = Util::staticUrl()."uploads/$username/data/".$value['featured'];
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
        if($this->clean->Method() !== "POST"  && Util::tokenValidate())
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $status = 403;
        $data = 'Unauthorized Access';

        $userd = new UsersController();
        $user_id = ($userd->getUserIdByToken(Util::$token))->id;

        if(!empty($user_id) && !empty($this->data->id)) {
            if(parent::deleteTip($this->data->id, $user_id)){
                $status = 200;
                $data = "Post was successful deleted!";
            }
        }
        return array('status'=>$status, 'payload'=>$data);
    }

    public function addCategory(){

    }

    /**
     * @param $params
     */
    public function my_tips($params){

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

        // get category id
        include_once __DIR__."/../Controller/UsersController.php";
        $userd = new UsersController();
        $limit ="$page,$num";
        $user_id = ($userd->getUserIdByToken(Util::$token))->id;
        $sql = parent::get_tip_by_user($user_id, $limit);

        $data = "No content!";
        if($sql) {
            $status = 200;
            $userd = new UsersController();
            foreach ($sql as $key=>$value){
                $user = ($userd->get($sql[$key]['user']));
                $username = $user->username;
                $avatar = $user->avatar;
                $sql[$key]['user'] = $username;
                $sql[$key]['avatar'] = $avatar;
                $sql[$key]['descriptions'] = nl2br($sql[$key]['description']);
                $sql[$key]['created_at'] = Util::ago($sql[$key]['created_at']);
                $sql[$key]['image'] = "public/uploads/$username/data/".$sql[$key]['featured'];
            }

            $data = $sql;
        }

        return array('status'=>$status, 'payload'=>$data);
    }
}

//$class = new Posts();