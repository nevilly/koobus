<?php
error_reporting(1);

class Database
{
    public $con;
    private $db_user;
    private $db_host;
    private $db_pass;
    private $port = 3306;
    private $db;

    public function __construct(){

        $this->db_user = $_ENV['DB_USER'];
        $this->db_pass = $_ENV['DB_PASS'];
        $this->db_host = $_ENV['DB_HOST'];
        $this->port = empty($_ENV['DB_PORT'])?: $_ENV['DB_PORT'];
        $this->db = $_ENV['DB'];
        self::connect();
    }

    /**
     *
     */
    private function connect(){

        try {
            $sql = new mysqli($this->db_host,$this->db_user,$this->db_pass,$this->db,$this->port);
            $this->con = $sql;
        }catch (Exception $e){
            (new mysqli($this->db_host,$this->db_user,$this->db_pass))->query("CREATE DATABASE $this->db;");
            $this->connect();
        }

    }

    /**
     * @param $data
     * @return false|string
     */
    public function encode($data){
        // code...
        return json_encode($data);
    }

    /**
     * @param $data
     * @return mixed
     */
    public function decode($data) {
        // code...
        return json_decode($data);
    }

    /**
     * @param $param
     * @return mixed
     */
    public function insert($param){
        $param = $this->decode($param);
        $table = $param->table;
        $data = $param->data;
//        print_r("INSERT INTO $table SET $data");
        $state = $this->con->query("INSERT INTO $table SET $data") ;
        print_r($this->con->error);
        return $state;
    }

    /**
     * @param $param
     * @return mixed
     */
    public function delete($param){
        $param = $this->decode($param);
        $table = $param->table;
        $data = $param->where;
        return $this->con->query("DELETE FROM $table WHERE $data");
    }

    /**
     * @param $param
     * @return mixed
     */
    public function update($param){
        $param = $this->decode($param);
        $table = $param->table;
        $data = $param->data;
        $where = isset($param->where) ? ' WHERE ' .$param->where : '';
//        echo "UPDATE $table SET $data $where";
        return $this->con->query("UPDATE $table SET $data $where");

    }

    /**
     * @param $param
     * @return mixed
     */
    public function select($param){
        $param = $this->decode($param);
        $table = $param->table;
        $cols = $cols = isset($param->cols)? $param->cols: "*";

        $limit = isset($param->limit) && !empty($param->limit) ? "LIMIT $param->limit" : '';

        $where = isset($param->where) && !empty($param->where)  ? ' WHERE ' .$param->where : '';

//        echo "SELECT $cols FROM $table $where ORDER BY id DESC $limit";
        return $this->query($this->encode(['query'=>"SELECT $cols FROM $table $where ORDER BY id DESC $limit"]));
    }

    /**
     * @param $param
     * @return mixed
     */
    public function query($param){
        $param = $this->decode($param);
        $query = $param->query;
        return $this->con->query("$query");
    }

    /**
     * @param $param
     * @return string|true
     */
    public function createTable($param){
        $param = $this->decode($param);
        $table = $param->name;
        $value = $param->value;

        //echo "CREATE TABLE IF NOT EXISTS $table ($value)";
        $sql = $this->con->query("CREATE TABLE IF NOT EXISTS $table ($value)");
        return print_r(!$sql ?? $this->con->error.'<br>');
    }

    /**
     * @param $param
     * @return mixed
     */
    public function dropTable($param){
        $param = $this->decode($param);
        $table = $param->name;
        return $this->con->query("
                SET FOREIGN_KEY_CHECKS = 0;
                drop table if exists $table;
                SET FOREIGN_KEY_CHECKS = 1;");
    }

}