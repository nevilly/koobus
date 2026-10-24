<?php

include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/CartController.php";


class Booking extends CartController
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

               


               $booking .="
                    <div class=\"row cart-item mb-3\" style=\"; border-radius:30px; \">
                        
                        <div class=\"col-md-3\">
                            <img src=\"$avatar\"  alt=\"$ad_type\" class=\"img-fluid rounded\" style= \"margin-top:2rem; \">
                        </div>

                        <div class=\"col-md-4\" style= \"margin-top:1.5rem; \">
                            <h5 class=\"card-title\" style= \" \">$ad_type</h5>
                            <p class=\"text-muted\">Platform: $selectPlatform</p>
                            <p class=\"text-muted\">Dimension: $dimension</p>
                            <p class=\"text-muted\">Rate: $rate</p>
                        </div>
                        <div class=\"col-md-2\" style= \"margin-top:2rem; \">
                          <!--- <div class=\"input-group\">
                                <h4 class=\"btn-sm\" type=\"button\">Booking</h4>
                                
                                <button class=\"btn btn-outline-secondary btn-sm\" type=\"button\">$bookDate</button>
                            </div>---> 
                        </div>
                        <div class=\"col-md-2 text-end\" style= \"margin-top:2rem;\">
                            <p class=\"fw-bold\" style= \"color:white;font-size:18px; color:#e84393;\">$price Tsh</p>
                            <button data-bs-toggle=\"modal\" data-bs-target=\"#cartdelete$id\" class=\"btn btn-sm btn-outline-danger\">
                                    <i class=\"bi bi-trash\" ></i>
                                </button>
                        </div>
                    </div>
                    <hr>



                    <div class=\"modal fade\" tabindex=\"1\"  id=\"cartdelete$id\" style=\" color:white;\">
        <div class=\"modal-dialog modal-dialog-centered modal-dialog-scrollable\">
            <div class=\"modal-content\" style=\"background-color: #1C1F37;   border-radius: 30px; color:white;\">
                <div class=\"modal-header center\">
                    <h5 class=\"modal-title\" style=\"color:white;\" >DELETE </h5>
                    <button type=\"button\" class=\"btn-close\" style=\" color:white;\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>
                </div>
             
               <div class=\"modal-body\">

           

                    
            <div class=\"card-body\">
                <h4 class=\"card-title\" style=\"color:white\">Delete</h4>
                <p class=\"card-text\"> Are sure you want to delete? </p>
                
               <input type=\"text\" value= \"$id\" id=\"deleteCart\" hidden>
           
            </div>
                
        </div>

                <div class=\"modal-footer d-flex  align-items-center\">
                   <button type=\"button\" class=\"btn btn-danger\"  data-bs-dismiss=\"modal\"  >No</button>
                    <button type=\"button\" class=\"btn btn-primary cDelete\"   >Yes</button>
                </div>
            </div>
        </div>
    </div>


";
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