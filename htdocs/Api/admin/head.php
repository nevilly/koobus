<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="utf-8" />
    <title>MwanaAds 1.0</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="" name="description" />
    <meta content="reddeath" name="author" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!-- App favicon -->
    <!-- <link rel="shortcut icon" href="<?=Util::staticUrl()?>assets/images/favicon.ico"> -->

    <!-- App css -->

    <link href="<?=Util::staticUrl()?>assets/css/app.min.css" rel="stylesheet" type="text/css" id="app-style" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">


    <!-- Plugins css -->
    <link href="<?=Util::staticUrl()?>assets/libs/quill/quill.core.css" rel="stylesheet" type="text/css" />
    <link href="<?=Util::staticUrl()?>assets/libs/quill/quill.bubble.css" rel="stylesheet" type="text/css" />
    <link href="<?=Util::staticUrl()?>assets/libs/quill/quill.snow.css" rel="stylesheet" type="text/css" />

    <!-- icons -->
    <link href="<?=Util::staticUrl()?>assets/css/icons.min.css" rel="stylesheet" type="text/css" />

    <link href="<?=Util::staticUrl()?>assets/libs/datatables.net-bs5/css/dataTables.bootstrap5.min.css" rel="stylesheet" type="text/css" />
    <link href="<?=Util::staticUrl()?>assets/libs/datatables.net-select-bs5/css/select.bootstrap5.min.css" rel="stylesheet" type="text/css" />
    <link href="<?=Util::staticUrl()?>assets/libs/selectize/css/selectize.bootstrap3.css" rel="stylesheet" type="text/css" />

<style>
   .myColor{
   background-color: #141627;
   }

	.cart-item img {
     max-width: 100px;
     height: auto;
 }

 .quantity-input {
     width: 50px;
 }

 .cart-summary {
     background-color: #f8f9fa;
     border-radius: 10px;
 }
.scrollable-table {
    overflow-x: auto;
    white-space: nowrap;
}
.table {
    min-width: 1000px;
}


 .deduction-badge {
            background-color: #ff4444;
            color: white;
        }
        .help-icon {
            cursor: help;
            font-size: 1.2rem;
            color: #6c757d;
        }





    .header-slider {
            background: linear-gradient(65deg, #141627, #2a5298);
            color: white;
            margin: 0px;
            padding: 0px;
            border-radius: 5rem;
        }
        
        .carousel-item {
            height: 500px;
            background-size: cover;
            background-position: center;
            border-radius: 1.5rem;
        }
        
        .carousel-caption {
        top: 0%;
        left: 1%;
        transform: translateY(-50%);
        width: 50%;
        text-align: left;
        background: rgba(0, 82, 156, 0.9);
        padding: 30px 40px;
        clip-path: polygon(0 0, 100% 0, 100% 75vh, 0 100%);
        border-left: 5px solid #fff;
        position: relative;
        height: 65vh;
    
    }

    .carousel-caption h1 {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    }

    .carousel-caption p {
        font-size: 1.2rem;
        line-height: 1.5;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
    }

    @media (max-width: 768px) {
        .carousel-caption {
            width: 60%;
            padding: 20px;
            left: 5%;
        }
        
        .carousel-caption h1 {
            font-size: 1.8rem;
        }
        
        .carousel-caption p {
            font-size: 1rem;
        }
    }
        
        .carousel-control-prev-icon,
        .carousel-control-next-icon {
            background-color: rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            padding: 20px;
        }
        
        .carousel-indicators [data-bs-target] {
            background-color: white;
            height: 10px;
            width: 10px;
            border-radius: 50%;
            margin: 0 8px;
        }

        
        .size-option {
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .size-option:hover {
            background-color: #f8f9fa;
        }
        
        .size-option.active {
            background-color: #0d6efd;
            color: white;
        }

         .product-card {
            max-width: 900px;
            width: 100%;
            margin: 0 auto;
        }

        
        
        .info-icon {
            cursor: pointer;
            color: #0d6efd;
            transition: transform 0.3s;
        }
        
        .info-icon:hover {
            transform: scale(1.2);
        }
        
        .specs-list dt {
            color: #6c757d;
            width: 160px;
        }
        
        .specs-list dd {
            margin-left: 180px;
        }
        
        @media (max-width: 768px) {
            .specs-list dt {
                width: 100%;
            }
            
            .specs-list dd {
                margin-left: 0;
                margin-bottom: 1rem;
            }

        }



        .custom-card {
            border-radius: 30px;
            overflow: hidden;
            max-width: 15rem;
            margin: 8px;
            height: 350px; /* Set fixed height for the card */
            background-color: #1C1F37;
        }

        .card-img-custom {
            border-radius: 30px;
            margin: 4px;
            width: calc(100% - 8px);
            height: auto;
        }

        .card-body {
            padding: .5rem;
        }

        .price {
            font-weight: bold;
            color: #28a745;
            font-size: 1rem;
            margin-left: 1.5rem;
        }

           .bottom-section {
            margin-top: auto;
            padding-top: 1.5rem;

            border-radius: 0px 0px 24px 24px;
            width: 100%;
        }




    </style>


<style>
    .nContainer{
        width: 100%;
        height: 100vh;
        background-color: green;
        color:white;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .nContainer h1{
          font-size: 3.5rem;
            margin-bottom: 1.5rem;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    }
</style>
</head>
<script type="text/javascript">
      let client = {a : "<?=$this->token;?>",uri:"<?=Util::staticUrl();?>", u: "<?=$_SESSION['name']; ?>"}
   // let client = {a : "<?=$this->token;?>",uri:"<?=Util::staticUrl();?>"}
</script>
<!-- body start -->
<body class="loading" data-layout-color="light"  data-layout-mode="default" data-layout-size="fluid" data-topbar-color="light" data-leftbar-position="fixed" data-leftbar-color="light" data-leftbar-size='default' data-sidebar-user='true' style = ''>

<!-- Begin page -->
<div id="wrapper" style = ''>
	