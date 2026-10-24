<?php

include_once $_SERVER["DOCUMENT_ROOT"] ."/api/v1/Module/Database.php";

class UsersModule extends Database
{
    private $table = "users";

    /**
     * UsersModule constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @param $data
     * @return null
     */
    public function add($data){
        $data = (array) $this->decode($data);

        $vs = '';
        if(is_array($data)){

            foreach ($data as $key => $value) {
                $vs .= "$key='".$this->con->real_escape_string($value)."',";
            }

            $vs = chop($vs, ',');
        }

        $sql = parent::insert($this->encode(['table'=>$this->table, 'data'=>$vs]));
        return ($sql) ? $this->con->insert_id : $sql;
    }

    public function add_avatar($avatar, $user){
        $status = false;
        if(!empty($avatar) && !empty($user))
            $status = parent::update(parent::encode(array('table'=>$this->table, 'data'=>"avatar='$avatar'", "where"=>"id=$user")));

        return $status;
    }

    /**
     * @param $data
     * @return false|mixed
     */
    public function update_user($data){
        $data =(array) parent::decode($data);

        $status = false;
        $d = '';
        if(count($data) > 0){

            foreach ($data as $key=>$value) {
                if($key !== 'id' && !empty($value))
                  $d .= "$key='$value',";
            }

           $d = chop($d,',');

            $id = $data['id'];

            $status = parent::update(parent::encode(array("table"=>$this->table,"data"=>"$d","where"=>"id='$id'")));
        }

        return $status;
    }

    /**
     * @param $data
     * @return false|mixed
     */
    public function activate_user_by_token($token){

        $status = false;

        if(!empty($token))
            $status = parent::update(parent::encode(array("table"=>$this->table,"data"=>"status='1'","where"=>"token='$token'")));

        return $status;
    }

    /**
     * @param $data
     * @return mixed
     */
    public function reset_password($data){
        $data = parent::decode($data);
        $p = $this->con->real_escape_string($data->p);
        $u = $this->con->real_escape_string($data->u);

        return parent::update(self::encode(array('table'=>$this->table,'data'=>"password='$p'",'where'=>"id=$u")));
    }

    /**
     * @param string $id
     * @return mixed
     */
    public function get($id = ''){
        $str = '';
        if(!empty($id))
            if(is_numeric($id))
                $str = "id=$id";
            elseif (filter_var($id, FILTER_VALIDATE_EMAIL))
                $str = "email='$id'";
            elseif(strlen($id) < 25)
                $str = "username='$id'";
            elseif(strlen($id) > 100)
                $str = "token='$id'";

        return parent::select(parent::encode(['table'=>$this->table,'where'=>$str]));
    }

    /**
     * @param $value
     * @return mixed
     */
    public function get_user_by_email_or_username($value){
        $value = $this->con->real_escape_string($value);
        $value = !empty($value)? "email='$value' OR username='$value'" :'';
        return parent::select(parent::encode(['table'=>$this->table,'where'=>$value]));
    }


    /**
     * @param $value
     * @return mixed
     */
    public function get_users_by_roles($value){
        $v = explode(',',$value);
        $vs = '';
        foreach ($v as $key=> $item) {
            $pg = $this->con->real_escape_string($key);
            $vs .= "privilege='$pg' OR ";
        }

        $vs = chop('OR',$vs);

        $value = !empty($value)? $vs :'';
        return parent::select(parent::encode(['table'=>$this->table,'where'=>$value]));
    }

    /**
     * @param $name
     * @param $password
     * @return mixed
     */
    public function check_user($name, $password){
        return parent::select(parent::encode(['table'=>$this->table,'col'=>'token,name,privilege','where'=>"token = '$name' AND status ='1' OR username='$name' AND password='$password' AND status = '1' OR email='$name' AND password='$password' AND status = '1' OR phone_number='$name' AND password='$password' AND status = '1'"]));
    }
    /**
     * @param $name
     * @param $password
     * @return mixed
     */
    public function getUserIdByToken($token){
        return parent::select(parent::encode(['table'=>$this->table,'col'=>'*, NULL AS password','where'=>"token = '$token' AND status ='1'"]));
    }

    /**
     *
     * @param $id
     * @return false
     */
    public function delete_user($id){
        $status = false;

        if(!empty($id))
           $status = parent::delete($this->encode([
            'table'=>$this->table, "where"=>"id='$id'"]));

        return $status;
    }
}