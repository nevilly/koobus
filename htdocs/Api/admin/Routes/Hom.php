<?php

include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Controller/AdslotController.php";

class Hom extends AdslotController{
    static $APP;
    static $page;
    static $view;

    public function __construct()
    {
        parent::__construct();
        self::$APP = getenv("App");
    }

    public function render($params = ''){
        $p = json_decode($params);
        $data = [];
        $display_rate = [];
        $sponser_content = [];
        $social_medias = [];
        $vedeo_production = [];
        if(!empty($p->page))
            $data = self::user($p->token);
        else{
            $data = self::all_employee();
            $display_rate = self::all_displayRate();
            $sponser_content = self::all_sponser_content();
            $social_medias = self::all_social_medias();
            $vedeo_production = self::allvedeo_production();
            
        }
  

          $dr = '';
          if($display_rate !== null && is_array($display_rate))
            foreach ($display_rate as $datum) {
              # code...

              $id =  $datum['id']; 
              $ad_type =  $datum['ad_type'];  
              $dimension =  $datum['dimension']; 
              $ad_unit =  $datum['ad_unit'];
              $device =  $datum['device'];
              $descr =  $datum['descr'];
              $img =  $datum['img'];
              $rate =  $datum['rate'];
              $price =  $datum['price'];
        
              $placement_type =  $datum['placement_type'];
              $createDate =  $datum['createDate'];

             $avatar = !empty($img) && $img !== ''? Util::Url()."/public/uploads/mwananchiAds/$img" : Util::Url()."/public/uploads/mwananchiAds/mlog.jpg";




               $dr .="<div class=\"col\">
                <div class=\"card\">
                    <div class=\"badge-trending\">POPULAR</div>
                    <div class=\"rating\"><i class=\"fas fa-star\" ></i> 4.8</div>
                     <img src=\"$avatar\" class=\"card-img-top card-img-custom\" alt=\"Product Image\" style = \"margin-top: 20px;\"  data-bs-toggle=\"modal\" data-bs-target=\"#addModal$id\">

                    <div class=\"card-body\">
                          
                        <h4 class=\"card-title\">$ad_type</h4>
                            
                        <p class=\"card-text\">Select info to see preferred size to to corresponding product Ads images.</p>
                        <div class=\"price-tag\">$rate</div>
                        <button class=\"btn btn-book\" data-bs-toggle=\"modal\" data-bs-target=\"#addBooking$id\" >Book Now</button>
                    </div>
                </div>
            </div>



                <!-- end col -->



                  

                   <div class=\"modal fade\" tabindex=\"1\"  id=\"addBooking$id\">
        <div class=\"modal-dialog modal-dialog-centered modal-dialog-scrollable\">
            <div class=\"modal-content\">
                <div class=\"modal-header\">
                    <h5 class=\"modal-title\">BOOKING ADS</h5>
                    <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>
                </div>
             
                <div class=\"modal-body\">


          <input type='text' value = '$dimension' id = 'dimension' hidden/>
          <input type='text' value = '$img' id = 'img' hidden/>
          <input type='text' value = '$ad_type' id = 'ad_type' hidden/>
          <input type='text' value = '$ad_unit' id = 'ad_unit' hidden/>
          <input type='text' value = '$device' id = 'device' hidden/>
          <input type='text' value = '$rate' id = 'rate' hidden/>
          <input type='text' value = '$price' id = 'price' hidden/>
          <input type='text' value = '$dimension' id = 'dimension' hidden/>





                    
                    <img src=\"$avatar\"  alt=\"Size 20x30\", style= \"width:100%\">


                    <!-- Card Body -->
                        <div class=\"card-body\">
                            <h5 class=\"card-title\">$ad_type</h5>
                            <p class=\"card-text\">Select your preferred size to see corresponding product images.</p>
                            
                            <!-- Size Selection -->
                            <div class=\"mb-3\">
                                <h6>Select Size (px):</h6>
                                <div class=\"d-flex gap-2\">
                                    <div class=\"size-option border p-2 rounded active\" data-size=\"20\">$dimension</div>
                                    <div class=\"size-option border p-2 rounded\" data-size=\"30\">30x40</div>
                                    <div class=\"size-option border p-2 rounded\" data-size=\"40\">40x60</div>
                                </div>
                            </div>
                            </div>

                    
                    <!--------First Name---------->
              

                    <div class=\"mb-3\">
                        <label for=\"status-select\" class=\"me-2\">Select Platform</label>
                        <div class=\"me-sm-2\">
                            <select class=\"form-select my-1 my-md-0\" id=\"selectPlatform\" name=\"selectPlatform\">
                                <option  value = 'Facebook' >Facebook</option>
                                <option value = 'Instagram'>Instagram</option>
                                <option value = 'Youtube'>Youtube</option>
                                <option value = 'Mwananchi'>Mwananchi</option>
                                <option value = 'Citizen'>Citizen</option>
                                <option value = 'Mwanaspoti'>Mwanaspoti</option>
                                <option value = 'X'>X</option>
                            </select>
                        </div> 
                    </div>


                    <!--------First Name---------->
                    <div class=\"mb-3\">
                      <label for=\"exampleFormControlInput1\" class=\"form-label\">Date</label>
                   
                    <input id=\"bookingDate\" class=\"form-control not_required\" type=\"date\" />
                    </div>
                
                </div>

                <!-----Submit---------->
                <div class=\"modal-footer d-flex justify-content-between align-items-center\">
                    <h4 class=\"text-primary\">$rate</h4>
                    <button type=\"button\" class=\"btn btn-primary addCart\">Booking Now</button>
                </div>
            </div>
        </div>
    </div>




     <div class=\"modal fade\" tabindex=\"1\"  id=\"addModal$id\" style=\" color:white;\">
        <div class=\"modal-dialog modal-dialog-centered modal-dialog-scrollable\">
            <div class=\"modal-content\" style=\"background-color: #1C1F37;   border-radius: 30px; color:white;\">
                <div class=\"modal-header\">
                    <h5 class=\"modal-title\" style=\"color:white;\" >BANNER INFO </h5>
                    <button type=\"button\" class=\"btn-close\" style=\" color:white;\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>
                </div>
             
               <div class=\"modal-body\">

               <img src=\"$avatar\" class=\"card-img-top\" alt=\"Product Image\" style = ' width:  100%;'>
                             


                    
            <div class=\"card-body\">
                <h4 class=\"card-title\" style=\"color:white;\">$ad_type</h4>
                <p class=\"card-text\">Select your preferred size to see corresponding product images.</p>
                
            
                <div class=\"mb-3\">
                    <h5 style=\" color:white;\">Select Size (px):</h5>
                    <div class=\"d-flex gap-2\">
                        <div class=\"size-option border p-2 rounded active\" data-size=\"20\">$dimension</div>
                        <div class=\"size-option border p-2 rounded\" data-size=\"30\">30x40</div>
                        <div class=\"size-option border p-2 rounded\" data-size=\"40\">40x60</div>
                    </div>
                </div>
            </div>

            <div class=\"mb-3\">
                <div class=\"me-sm-2\">
                    <div class=\" d-flex justify-content-between align-items-center\" >
                        <span class=\"price\" >Rate : $rate</span>
                        <span class=\"price \" >Price : $price</span>
         
                    </div>
                </div> 
            </div>
                
        </div>

                <div class=\"modal-footer d-flex justify-content-between align-items-center\">
                    <h4 class=\"text-primary\">$rate</h4>
                    <button type=\"button\" class=\"btn btn-primary addEmployee\"  data-bs-dismiss=\"modal\"  >Close</button>
                </div>
            </div>
        </div>
    </div>



                 ";
           } 


          $sc = '';
          if($sponser_content !== null && is_array($sponser_content))
            foreach ($sponser_content as $datum) {
              # code...

              $id =  $datum['id']; 
              $idsc =  $datum['id'].'sc'; 
              $type =  $datum['content_type'];  
              $img =  $datum['img']; 
              $desr =  $datum['desr'];
              $specification =  $datum['specification'];
              $platform =  $datum['platform'];
              $rate_per_content =  $datum['rate_per_content'];
              $duration =  $datum['duration'];
              $price =  $datum['price'];
        
              $createDate =  $datum['createDate'];


               $sc .=" <div class=\"col-xl-4\" style = \"display:none;\">
                   
                    <div class=\"card\" style=\"max-width: 400px;\">
                        <!-- Image Slider -->
                        <div id=\"productCarousel\" class=\"carousel slide\">
                            <div class=\"carousel-inner\">
                                <div class=\"carousel-item active\">
                                    <img src=\"https://via.placeholder.com/400x300/FF0000/FFFFFF?text=Size+20x30\" class=\"d-block w-100\" alt=\"Size 20x30\">
                                </div>
                                <div class=\"carousel-item active\">
                                    <img src=\"https://via.placeholder.com/400x300/FF0000/FFFFFF?text=Size+20x30\" class=\"d-block w-100\" alt=\"Size 20x30\">
                                </div>
                                 <div class=\"carousel-item active\">
                                    <img src=\"https://via.placeholder.com/400x300/FF0000/FFFFFF?text=Size+20x30\" class=\"d-block w-100\" alt=\"Size 20x30\">
                                </div>
                            </div>
                            <button class=\"carousel-control-prev\" type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide=\"prev\">
                                <span class=\"carousel-control-prev-icon\" aria-hidden=\"true\"></span>
                                <span class=\"visually-hidden\">Previous</span>
                            </button>
                            <button class=\"carousel-control-next\" type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide=\"next\">
                                <span class=\"carousel-control-next-icon\" aria-hidden=\"true\"></span>
                                <span class=\"visually-hidden\">Next</span>
                            </button>
                            <div class=\"carousel-indicators\">
                                <button type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide-to=\"0\" class=\"active\"></button>
                                <button type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide-to=\"1\"></button>
                                <button type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide-to=\"2\"></button>
                            </div>
                        </div>

                        <!-- Card Body -->
                        <div class=\"card-body\">
                            <h5 class=\"card-title\">$type</h5>
                            <p class=\"card-text\">$specification</p>
                            
                            <!-- Size Selection -->
                            <div class=\"mb-3\">
                                <h6>Platform:</h6>
                                <div class=\"d-flex gap-2\">
                                    <div class=\"size-option border p-2 rounded active\" data-size=\"20\">Mwananchi</div>
                                    <div class=\"size-option border p-2 rounded\" data-size=\"30\">MwanaSpoti</div>
                                  
                                </div>
                            </div>

                            <input type ='text' hidden value='$id' id = 't_id' hidden>
                              <input type ='text' hidden value='m_display_rate_card' id = 'tablename'>

                            <!-- Price -->
                            <div class=\"d-flex justify-content-between align-items-center\">
                                <h4 class=\"text-primary\">$rate_per_content</h4>
                                <button data-bs-toggle=\"modal\" data-bs-target=\"#addBookingSc$idsc\" class=\"btn btn-primary  \"> Booking</button>
                            </div>
                        </div>
                    </div>
                </div><!-- end col -->




                <div class=\"modal fade\" tabindex=\"1\"  id=\"addBookingSc\">
        <div class=\"modal-dialog modal-dialog-centered modal-dialog-scrollable\">
            <div class=\"modal-content\">
                <div class=\"modal-header\">
                    <h5 class=\"modal-title\">BOOKING ADS</h5>
                    <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>
                </div>
             
                <div class=\"modal-body\">


          <input type='text' value = '$dimension' id = 'dimension' hidden/>
          <input type='text' value = '$img' id = 'img' hidden/>
          <input type='text' value = '$type' id = 'ad_type' hidden/>
          <input type='text' value = '$ad_unit' id = 'ad_unit' hidden/>
          <input type='text' value = '$device' id = 'device' hidden/>
          <input type='text' value = '$rate_per_content' id = 'rate' hidden/>
          <input type='text' value = '$price' id = 'price' hidden/>
          <input type='text' value = '$dimension' id = 'dimension' hidden/>





                    
                    <img src=\"$avatar\"  alt=\"Size 20x30\", style= \"width:100%\">


                    <!-- Card Body -->
                        <div class=\"card-body\">
                            <h5 class=\"card-title\">$type</h5>
                            <p class=\"card-text\">$specification</p>
                            
                            <!-- Size Selection -->
                           
                            </div>

                    
                    <!--------First Name---------->
              

                    <div class=\"mb-3\">
                        <label for=\"status-select\" class=\"me-2\">Select Platform</label>
                        <div class=\"me-sm-2\">
                            <select class=\"form-select my-1 my-md-0\" id=\"selectPlatform\" name=\"selectPlatform\">
                                <option  value = 'Facebook' >Facebook</option>
                                <option value = 'Instagram'>Instagram</option>
                                <option value = 'Youtube'>Youtube</option>
                                <option value = 'Mwananchi'>Mwananchi</option>
                                <option value = 'Citizen'>Citizen</option>
                                <option value = 'Mwanaspoti'>Mwanaspoti</option>
                                <option value = 'X'>X</option>
                            </select>
                        </div> 
                    </div>


                    <!--------First Name---------->
                    <div class=\"mb-3\">
                      <label for=\"exampleFormControlInput1\" class=\"form-label\">Date</label>
                   
                    <input id=\"bookingDate\" class=\"form-control not_required\" type=\"date\" />
                    </div>
                
                </div>

                <!-----Submit---------->
                <div class=\"modal-footer d-flex justify-content-between align-items-center\">
                    <h4 class=\"text-primary\">$rate</h4>
                    <button type=\"button\" class=\"btn btn-primary addCart\">Booking Now</button>
                </div>
            </div>
        </div>
    </div>
                 ";
          } 

          $vd = '';
          if($vedeo_production !== null && is_array($vedeo_production))
            foreach ($vedeo_production as $datum) {
              # code...

              $id =  $datum['id']; 
              $type =  $datum['platform'];  
              $img =  $datum['img']; 
              $desr =  $datum['descr'];
              $specification =  $datum['specification'];
              $platform =  $datum['platform'];
              $rate_per_content =  $datum['rate'];
              $v_length =  $datum['v_length'];
        
              $createDate =  $datum['createDate'];


               $vd .=" <div class=\"col-xl-4\">
                   
                    <div class=\"card\" style=\"max-width: 400px;\">
                        <!-- Image Slider -->
                        <div id=\"productCarousel\" class=\"carousel slide\">
                            <div class=\"carousel-inner\">
                                <div class=\"carousel-item active\">
                                    <img src=\"https://via.placeholder.com/400x300/FF0000/FFFFFF?text=Size+20x30\" class=\"d-block w-100\" alt=\"Size 20x30\">
                                </div>
                                <div class=\"carousel-item active\">
                                    <img src=\"https://via.placeholder.com/400x300/FF0000/FFFFFF?text=Size+20x30\" class=\"d-block w-100\" alt=\"Size 20x30\">
                                </div>
                                 <div class=\"carousel-item active\">
                                    <img src=\"https://via.placeholder.com/400x300/FF0000/FFFFFF?text=Size+20x30\" class=\"d-block w-100\" alt=\"Size 20x30\">
                                </div>
                            </div>
                            <button class=\"carousel-control-prev\" type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide=\"prev\">
                                <span class=\"carousel-control-prev-icon\" aria-hidden=\"true\"></span>
                                <span class=\"visually-hidden\">Previous</span>
                            </button>
                            <button class=\"carousel-control-next\" type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide=\"next\">
                                <span class=\"carousel-control-next-icon\" aria-hidden=\"true\"></span>
                                <span class=\"visually-hidden\">Next</span>
                            </button>
                            <div class=\"carousel-indicators\">
                                <button type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide-to=\"0\" class=\"active\"></button>
                                <button type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide-to=\"1\"></button>
                                <button type=\"button\" data-bs-target=\"#productCarousel\" data-bs-slide-to=\"2\"></button>
                            </div>
                        </div>

                        <!-- Card Body -->
                        <div class=\"card-body\">
                            <h5 class=\"card-title\">$type</h5>
                            <p class=\"card-text\">$specification</p>
                            
                            <!-- Size Selection -->
                            
                            

                            <!-- Price -->
                            <div class=\"d-flex justify-content-between align-items-center\">
                                <h4 class=\"text-primary\">$rate_per_content</h4>
                                <button class=\"btn btn-primary\" >Add to Cartx</button>
                            </div>
                        </div>
                    </div>
                </div><!-- end col -->
                 ";
          } 


     
   


     


          $scm = '';
          if($social_medias !== null && is_array($social_medias))
            foreach ($social_medias as $datum) {
              # code...

              $id =  $datum['id']; 
              $type =  $datum['platform'];  
              $img =  $datum['img']; 
              $desr =  $datum['desr'];
              $brand =  $datum['brand'];
              $platform =  $datum['platform'];
              $rate =  $datum['rate'];
              $duration =  $datum['duration'];
        
              $createDate =  $datum['createDate'];


               $scm .="   
                 <div class=\"col\">
                <div class=\"card\">
                    <div class=\"badge-trending\">POPULAR</div>
                    <div class=\"rating\"><i class=\"fas fa-star\" ></i> 4.8</div>
                     <img src=\"../public/uploads/mwananchiAds/fbLogo.png\" class=\"card-img-top card-img-custom\" alt=\"Product Image\" style = \"margin-top: 20px;\"  data-bs-toggle=\"modal\" data-bs-target=\"#addModal$id\">

                     

                    <div class=\"card-body\">
                          
                        <h4 class=\"card-title\">$platform</h4>
                            
                        <p class=\"card-text\">$desr</p>
                        <p class=\"card-text\"> $brand <br/>  Duration: <b>$duration </b></p>
                        
                        <div class=\"price-tag\">$rate</div>
                        <button class=\"btn btn-book\" data-bs-toggle=\"modal\" data-bs-target=\"#addBooking$id\" >Book Now</button>
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
        return parent::get_attendency_by_today();
    }
    public function all_displayRate(){
        return parent::get_displayRate();
    }

    public function all_sponser_content(){
        return parent::get_sponser_content();
    }

    public function all_social_medias(){
        return parent::get_social_medias();
    }
    public function allvedeo_production(){
        return parent::get_vedeo_production();
    }

   

    //public function user($token){
      //  return parent::users($token);
    //}

}


