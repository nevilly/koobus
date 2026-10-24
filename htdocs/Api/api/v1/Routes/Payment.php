<?php

include_once __DIR__."/../Controller/PaymentController.php";

class Payment extends PaymentController
{
    private $data;
    private $clean;
    private $vendor;
    private $api;
    private $api1;
    private $private_key;
    private $public_key;


    /**
     * @var array|false|string
     */
    private $key;

    public function __construct()
    {
        parent::__construct();

        $this->clean = new Util();
        $this->data = isset($_POST) && count($_POST) > 0 ? parent::decode(parent::encode($_POST)) : parent::decode(file_get_contents("php://input"));

        $this->key = getenv("SECRET");
        $this->vendor = getenv("pay_bill");
        $this->api = getenv("api");
        $this->api1 = getenv("api2");
        $this->private_key = getenv("private_key");
        $this->public_key = getenv("public_key");
    }

    public function make_payment(){

        if($this->clean->Method() !== "POST" && !Util::tokenValidate() && count((array) $this->data) < 1)
            return array('status'=>403,'payload'=>"Unauthorized Access");

        $data = $this->data;

        if(isset($data->amount) && isset($data->subscription_type) && isset($data->phone) && isset($data->mno)){

            $amount = $this->clean->clean_input($data->amount);
            $substype = $this->clean->clean_input($data->subscription_type);
            $phone = $this->clean->clean_input($data->phone);
            $mno = $this->clean->clean_input($data->mno);

            $status = 201;
            $message = "All fields are required!";

            if(!empty($amount) && !empty($substype) && !empty($phone) && !empty($mno)){
                $sql = parent::add(parent::encode(array("amount"=>$amount, "subscription_type"=>$substype, "phone"=>$phone, "mno"=>$mno)));

                $order_id = '';
                if($sql){
                    // Send third_part request to perform payment

                }
            }
        }

        //parent::add();
        return array('status'=>$status, 'payload'=>$data);
    }

    public function callback(){
        $data = $this->data;
        $data->date = date("d/m/Y H:i:s");
        file_put_contents(__DIR__."/payment-logs.txt",print_r($data, true),FILE_APPEND);

        if((array) $data){
            // subscribe users
            // check user
            $token = $data->token;
            $order_id = $data->order_id;
            $desc = $data->description;

            $d = new DateTime('NOW');
            $day = $d->format("d");
            $mon = $d->format("m");
            $yr = $d->format("y");
            $hr = $d->format("H");
            $min = $d->format("i");
            $sec = $d->format("s");

            print_r($d);

            return print_r("$yr-$mon-$day $hr:$min:$sec");

            $message = "Sorry something went wrong!";
            $status = false;

            if((int) $order_id > 0){
                $sql = parent::exist($order_id,$token);

                if(!$sql){
                    $sql = parent::updatePayment(parent::encode(array(
                        "id"=>$order_id,
                        "token"=>$token,
                        "description"=>$desc
                    )));

                    if($sql) {
                        $message = "Thank your subscription was successful.";
                        $status = true;
                    }
                }

            }

        }

        return array('status'=>$status, 'payload'=>$message);
    }


    /**
     * Process a payment
     */
    public function process_payment( $order ) {

        /*
          * Array with parameters for API interaction
         */
        $id = $order['id'];
        $phone = $order['phone'];
        $total = $order['total'];
        $mno = $order['mno'];

        $url = Util::get_site_url();

        $api = !preg_match("/airtel/", $mno) ? $this->api: $this->airtel;
        //$api = $this->api;
        $message = '';
        $token = '';
        $status = false;

        $timestamp = date("Y-m-d H:i:s");//"trx_date":"2020-02-27 09:28:38"

        $signed_fields = "amount,channel,callback_url,recipient,reference_id,trx_date";

        $bref = "RD".substr(strrev($phone),0,4);

        $args = array(
            'channel'=>$this->vendor,
            'trx_date'=>''.$timestamp.'',
            'reference_id'=>"$phone$id",
            'recipient'=>$phone,
            'amount'=>''.$total.'',
            'bill_ref'=>$bref,
            'transactionTypeName'=>'Debit',
            'callback_url'=>Util::get_site_url()."callback"
        );

        $argshash = array(
            'channel'=>$this->vendor,
            'trx_date'=>urlencode($timestamp),
            'reference_id'=>"$phone$id",
            'recipient'=>$phone,
            'amount'=>$total,
            'bill_ref'=>$bref,
            'transactionTypeName'=>'Debit',
            'callback_url'=>urlencode(Util::get_site_url()."callback")
        );

        $digest = parent::computeSignature($argshash, $signed_fields, $this->private_key);

        $headers = array(
            "Content-type: application/json"
        );

        $args['hash'] = $digest;

        /*
         * Your API interaction could be built with wp_remote_post()
          */
        $response = HTTP::http($api,['request'=>$args],$headers,true,true);

        if( $response ) {

            $result = (int) $response['isSuccessful'];
            $message = $response['error_description'];

            if(!empty($message))
                file_put_contents(__DIR__.'/error.txt',$message, FILE_APPEND);
            $token = $response['reference_id'];
            $description = $response['description'];

            // it could be different depending on your payment processor
            if ($result == 1 ) {
                $status = parent::updatePayment(parent::encode(array(
                    "id"=>$id,
                    "token"=>$digest,
                    "reference"=>$token,
                    'description'=>$description
                )));
            }

        }

        return $status;
    }
}

//$class = new Payment();