<?php

include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/CartController.php";


class Invoice extends CartController
{
    static $APP;
    static $page;
    static $view;

    public function __construct(){  
        parent::__construct();
        self::$APP = getenv("App");
    }

    public function render($params = ''){
        $p = json_decode($params);
        //print_r($p);
        $data = [];
        $dept = [];
        if(!empty($p->page))
            $data = self::user($p->token);
        else{
            $data = self::all_employee();
           // $dept = self::all_department();
        }


        //print_r($data);
           $totalPrice = 0;
           $booking = '';

           $table = '';
          if($data !== null && is_array($data))
            foreach ($data as $datum) {
              # code...

              $id =  $datum['id'];
              $user_id =  $datum['pId'];
              $userID =  $datum['userID'];
              $ad_type =  $datum['ad_type'];
              $tablename =  $datum['tablename'];
              $selectPlatform =  $datum['selectPlatform'];
              $device =  $datum['device'];
              $ad_unit =  $datum['ad_unit'];
              $qty =  $datum['qty'];
              $rate =  $datum['rate'];
              $payed =  $datum['payed'];
              $bookDate =  $datum['bookDate'];
              $dimension =  $datum['dimension'];
              $img =  $datum['img'];
              $price =  $datum['price'];

               if($price !== 0 )
                  $totalPrice = $totalPrice + $price;


                $avatar = !empty($img) && $img !== ''? Util::Url()."/public/uploads/mwananchiAds/$img" : Util::Url()."/public/uploads/mwananchiAds/Banner_300x250.png";

               $table .= " <tr>
                            <td>$ad_type</td>
                            <td>$dimension</td>
                            <td>$price</td>
                            <td>1</td>
                            <td>$price</td>
                        </tr>";
                      } 



        if(file_exists(__DIR__."/../Views/$p->view.php")) {
          return  include_once __DIR__ . "/../Views/$p->view.php";
        }elseif (file_exists(__DIR__."/../Views/$p->view/$p->page.php"))
           return include_once (__DIR__."/../Views/$p->view/$p->page.php");
        elseif (file_exists(__DIR__."/../Views/$p->view/$p->view.php"))
           return include_once (__DIR__."/../Views/$p->view/$p->view.php");
        elseif(file_exists(__DIR__."/../Views/$p->view/index.php"))
           return include_once (__DIR__."/../Views/$p->view/index.php");
        return;
    }

    public function all_employee(){
      return parent::get_by_cart();
    }

 
    
    //public function user($token){
      //  return parent::users($token);
    //}

}