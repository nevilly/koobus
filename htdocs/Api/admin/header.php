<?php
include_once Util::root()."/admin/head.php";
include_once $_SERVER["DOCUMENT_ROOT"]."/api/v1/Util/Util.php";

$notNo =  Util::CartNotification();

 $countNot = '';
  if($notNo !== null && is_array($notNo))
  	 foreach ($notNo as $datum) {
         $countNot =  $datum['Cnt']; 
  	 }

    $searchList =  Util::searchList();
 //$countNot = '';
  if($searchList !== null && is_array($searchList))
    

?>
<div id="data-container" class = "hidden" data-array="<?php echo htmlspecialchars(json_encode($searchList)); ?>"></div>

<!-- Topbar Start -->
<div class="navbar-custom " >
    <ul class="list-unstyled topnav-menu float-end mb-0">

        <li class="d-none d-lg-block">
            <form class="app-search">
                <div class="app-search-box">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Search..." id="top-search">
                        <button class="btn input-group-text" type="submit">
                            <i class="fe-search"></i>
                        </button>
                    </div>
                    <div class="dropdown-menu dropdown-lg" id="search-dropdown">
                        <!-- item-->
                        <div class="dropdown-header noti-title">
                            <h5 class="text-overflow mb-2">Found 22 results</h5>
                        </div>

                        

                   
                        <!-- item-->
                        <div class="dropdown-header noti-title">
                            <h6 class="text-overflow mb-2 text-uppercase">Users</h6>
                        </div>

                        <div class="notification-list">
                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item">
                                <div class="d-flex align-items-start">
                                    <img class="d-flex me-2 rounded-circle" src="<?= Util::Url();?>/public/assets/images/user.png" alt="Generic placeholder image" height="32">
                                    <div class="w-100">
                                        <h5 class="m-0 font-14">Erwin E. Brown</h5>
                                        <span class="font-12 mb-0">UI Designer</span>
                                    </div>
                                </div>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item">
                                <div class="d-flex align-items-start">
                                    <img class="d-flex me-2 rounded-circle" src="<?= Util::Url();?>/public/assets/images/users.png" alt="Generic placeholder image" height="32">
                                    <div class="w-100">
                                        <h5 class="m-0 font-14">Jacob Deo</h5>
                                        <span class="font-12 mb-0">Developer</span>
                                    </div>
                                </div>
                            </a>
                        </div>

                    </div>
                </div>
            </form>
        </li>

        <li class="dropdown d-inline-block d-lg-none">
            <a class="nav-link dropdown-toggle arrow-none waves-effect waves-light" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                <i class="fe-search noti-icon"></i>
            </a>
            <div class="dropdown-menu dropdown-lg dropdown-menu-end p-0">
                <form class="p-3">
                    <input type="text" class="form-control" placeholder="Search ..." aria-label="Recipient's username">
                </form>
            </div>
        </li>


       <!--   Notification -->
        
        <li class="dropdown notification-list topbar-dropdown">
            <a  class="nav-link dropdown-toggle waves-effect waves-light"  href="/admin/Booking/"  aria-haspopup="false" aria-expanded="false">
                <i class="fe-bell noti-icon"></i>
                <span class="badge bg-danger rounded-circle noti-icon-badge"><?= $countNot; ?></span>
            </a>
            <div class="dropdown-menu dropdown-menu-end dropdown-lg">

                <!-- item-->
                <div class="dropdown-item noti-title">
                    <h5 class="m-0">
                        <span class="float-end">
                            <a href="" class="text-dark">
                                <small>Clear All</small>
                            </a>
                        </span>Notification
                    </h5>
                </div>

                <div class="noti-scroll" data-simplebar>

                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item notify-item active">
                        <div class="notify-icon">
                            <img src="<?= Util::staticUrl();?>/assets/images/users/user-1.jpg" class="img-fluid rounded-circle" alt="" /> </div>
                        <p class="notify-details">Cristina Pride</p>
                        <p class="text-muted mb-0 user-msg">
                            <small>Hi, How are you? What about our next meeting</small>
                        </p>
                    </a>

                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item notify-item">
                        <div class="notify-icon bg-primary">
                            <i class="mdi mdi-comment-account-outline"></i>
                        </div>
                        <p class="notify-details">Caleb Flakelar commented on Admin
                            <small class="text-muted">1 min ago</small>
                        </p>
                    </a>

                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item notify-item">
                        <div class="notify-icon">
                            <img src="<?= Util::staticUrl();?>/assets/images/user.png" class="img-fluid rounded-circle" alt="" /> </div>
                        <p class="notify-details">Karen Robinson</p>
                        <p class="text-muted mb-0 user-msg">
                            <small>Wow ! this admin looks good and awesome design</small>
                        </p>
                    </a>

                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item notify-item">
                        <div class="notify-icon bg-warning">
                            <i class="mdi mdi-account-plus"></i>
                        </div>
                        <p class="notify-details">New user registered.
                            <small class="text-muted">5 hours ago</small>
                        </p>
                    </a>

                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item notify-item">
                        <div class="notify-icon bg-info">
                            <i class="mdi mdi-comment-account-outline"></i>
                        </div>
                        <p class="notify-details">Caleb Flakelar commented on Admin
                            <small class="text-muted">4 days ago</small>
                        </p>
                    </a>

                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item notify-item">
                        <div class="notify-icon bg-secondary">
                            <i class="mdi mdi-heart"></i>
                        </div>
                        <p class="notify-details">Carlos Crouch liked
                            <b>Admin</b>
                            <small class="text-muted">13 days ago</small>
                        </p>
                    </a>
                </div>

                <!-- All-->
                <a href="javascript:void(0);" class="dropdown-item text-center text-primary notify-item notify-all">
                    View all
                    <i class="fe-arrow-right"></i>
                </a>

            </div>
        </li>

        <li class="dropdown notification-list topbar-dropdown">
            <a class="nav-link dropdown-toggle nav-user me-0 waves-effect waves-light" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                <img src="<?= $this->avatar;?>" alt="<?=$this->username;?>" class="rounded-circle">
                <span class="pro-user-name ms-1">
                                    <?=$this->username;?> <i class="mdi mdi-chevron-down"></i>
                                </span>
            </a>
            <div class="dropdown-menu dropdown-menu-end profile-dropdown ">
                <!-- item-->
                <div class="dropdown-header noti-title">
                    <h6 class="text-overflow m-0">Welcome !</h6>
                </div>

                <!-- item-->
                <a href="/admin/users/profile/<?=$this->token;?>" class="dropdown-item notify-item">
                    <i class="fe-user"></i>
                    <span>My Account</span>
                </a>

                <div class="dropdown-divider"></div>

                <!-- item-->
                <a href="/admin/auth/logout" class="dropdown-item notify-item">
                    <i class="fe-log-out"></i>
                    <span>Logout</span>
                </a>

            </div>
        </li>

   

    </ul>

    <!-- LOGO -->
    <div class="logo-box" style = ''>

        <a href="/admin/" class="logo logo-light text-center">
                           <span class="logo-sm" >
                                <?= self::$APP.' '; //echo getenv("Version");?>
                            </span> 
            <span class="logo-lg">
                                <?= self::$APP.' '; // echo getenv("Version");?>
                            </span>
        </a>
        <a href="/admin/" class="logo logo-dark text-center" style = ''>
                            <span class="logo-sm">
                                <?= self::$APP.' ';  //echo getenv("Version");?>
                            </span>
            <span class="logo-lg">
                                <?= self::$APP.' ';  //echo getenv("Version");?>
                            </span>
        </a>
    </div>

    <ul class="list-unstyled topnav-menu topnav-menu-left mb-0">
        <li>
            <button class="button-menu-mobile  button-menu-mobile  waves-effect">
                <i class="fe-menu"></i>
            </button>

          <!--   <button class="button-menu-mobile disable-btn waves-effect">
                <i class="fe-menu"></i>
            </button> -->
        </li>

        <li>
            <h4 class="page-title-main">
                <?= ucfirst( preg_match('/Home/', $this->view) ? "Dashboard" :$this->view );?>
            </h4>
        </li>

    </ul>

    <div class="clearfix"></div>

</div>
<!-- end Topbar -->

<!-- ========== Left Sidebar Start ========== -->
<div class="left-side-menu" style = ''>

    <div class="h-100 w-100" data-simplebar  >

        <!-- User box -->
        <div class="user-box text-center">

            <img src="<?= $this->avatar;?>" alt="user-img" title="<?=$this->username;?>" class="rounded-circle img-thumbnail avatar-md">
            <div class="dropdown">
                <a href="#" class="user-name dropdown-toggle h5 mt-2 mb-1 d-block" data-bs-toggle="dropdown"  aria-expanded="false"><?=$this->username;?></a>
                <div class="dropdown-menu user-pro-dropdown">

                    <!-- item-->
                    <a href="/admin/users/profile/<?=$this->token;?>" class="dropdown-item notify-item">
                        <i class="fe-user me-1"></i>
                        <span>My Account</span>
                    </a>

                    <!-- item-->
                    <a href="/admin/settings/"  class="dropdown-item notify-item">
                        <i class="fe-settings me-1"></i>
                        <span>Settings</span>
                    </a>

        
                    <!-- item-->
                    <a href="/admin/auth/logout" class="dropdown-item notify-item">
                        <i class="fe-log-out me-1"></i>
                        <span>Logout</span>
                    </a>

                </div>
            </div>

            <p class="text-muted left-user-info"><?=$this->role;?></p>

            <ul class="list-inline">

                <li class="list-inline-item">
                    <a href="/admin/auth/logout">
                        <i class="mdi mdi-power"></i>
                    </a>
                </li>
            </ul>
        </div>

        <!--- Sidemenu -->
        <div id="sidebar-menu">

            <ul id="side-menu">

                <li>
                    <a href="/admin/Home">
                        <i class="mdi mdi-view-dashboard-outline"></i>
                        <span class="badge bg-success rounded-pill float-end"></span>
                        <span> Home </span>
                    </a>
                </li>
               

                <li class="menu-title mt-2">Apps</li>
                
 

                   <!------Home---------->
                     <li>
                    <a href="/admin/Hom">
                        <i class="mdi mdi-view-dashboard-outline"></i>
                        <span class="badge bg-success rounded-pill float-end"></span>
                        <span> Digital rate </span>
                    </a>
                </li>
                  

           
                <!------Booking---------->
                <li>
                    <a href="/admin/Newz/">
                       <i class="mdi mdi-account-multiple"></i>
                        <span class="badge bg-success rounded-pill float-end"></span>
                        <span> News Ads </span>
                    </a>
                </li>

           
                        
                   <!------Booking---------->
                <li>
                    <a href="/admin/Booking/">
                       <i class="mdi mdi-account-multiple"></i>
                        <span class="badge bg-success rounded-pill float-end"></span>
                        <span> Booking </span>
                    </a>
                </li>

         


          
                <li>
                    <a href="/admin/settings/<?=$this->token;?>" >
                        <i class="mdi mdi-cog-sync-outline"></i>
                        <span> Settings </span>
                    </a>
                </li>

            </ul>

        </div>
        <!-- End Sidebar -->

        <div class="clearfix"></div>

    </div>
    <!-- Sidebar -left -->

</div>
<!-- Left Sidebar End -->

<div class="content-page">