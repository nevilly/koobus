


<style type="text/css"> .header-clip {
            clip-path: polygon(0 0, 100% 0, 100% 75vh, 0 100%);
            height: 90vh;
            background: #007bff; /* Fallback color */
            background: linear-gradient(to right, #0062cc, #007bff);
            position: relative;
            overflow: visible;
            margin:-1.5rem;
            padding: 1rem;
        }

        /* Adjust navbar positioning */
        .navbar {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }

        /* Content spacing */
        .header-content {
            padding-top: 20vh;
            color: white;
            position: relative;
            z-index: 100;
        }

        /* Ensure content below header starts after the clipped area */
        .next-section {
            margin-top: -25vh;
            padding-top: 30vh;
        }

        
        .custom-card-h {
            border-radius: 24px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            padding: 20px;
            margin: 15px;
            width:145px;

        }
        
        .custom-card-h:hover {
            transform: translateY(-5px);
        }
        
        .card-icon {
            font-size: 2.5rem;
            color: #0d6efd;
            margin-bottom: 20px;
        }
        .custom-card-h > p{
            color:black;
        }

        .textarea-container {
            position: relative;
        }
        .textarea-buttons  {
            position: absolute;
            left: 10px;
            bottom: 10px;
            width: 30%;
           
            width: 40%;
        }
        .textarea-buttons > select {
            position: absolute;
            left: 10px;
            bottom: 10px;
            width: 15rem;
            border-radius: 24px;
            background-color: white;
            border-radius: 24px;
            border:1px solid blue;
        }

        .textarea-buttons > div >.n-ask {
            height: 50px;       
            border:1px solid blue;
            border-radius: 24px;border:1px solid blue; height: 30px;
        }
        textarea {
            padding-bottom: 60px; /* Make space for buttons */
        }


        .card-img-top {
            height: 200px;
            object-fit: cover;
        }
        .card {
            transition: transform 0.3s;
             transition: all 0.3s ease;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 
                    0 2px 4px -1px rgba(0, 0, 0, 0.06);

        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.15), 
                    0 4px 6px -2px rgba(0, 0, 0, 0.08);
        transform: translateY(-3px);
        }

    </style>


     <style>
        .product-item {
            transition: all 0.2s;
            border-bottom: 1px solid #eee;
        }
        .product-item:hover {
            background-color: #f8f9fa;
        }
        .product-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
        }

        #myPointer{
          border-radius: 50px; background-color: #DBEAFE ;  color: #1E40AF; border:none; 
          margin: 4px;
                
             box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 
                    0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        #myPointer:hover{
        
            background-color: #a9cdfc ;
             
        }


        #tryNow{
              border-radius: 50px; background-color: #0066FF ;  color: white; border:none; 
        }
    </style>








    <div class="content" style=" padding:-2rem;margin:-5px;">

        <!-- Start Content-->
        <div class="container-fluid">


        <header class="header-clip">
            <div class="container container-fluid flex-grow-1 header-content">
                <div class="row">
                    <div class="col-md-4">
                        <h1 class="" style = "color:white ; font-weight:bold; ">Empowering All To </h1>
                        <h1 style = "color:white ; font-weight:bold; "><span class = 'auto-type'></span> </h1>
                       
                       
                        <a href="/admin/Hom"><button class="btn btn-light btn-lg" style = "background-color:white; border:1px solid #141627;border-radius:23px;padding:15px,15px, 0px, 0px;width: 200px; margin-top:10px;"  >Book Ads</button></a>
                    </div>
                    <div class="col-md-8 " >

                        <div class="container ">
                            <div class="row  ">

                                <!-- Card 3 - Find -->
                                <div class="col-md-4">
                                    <div class="custom-card-h bg-white">
                                        <i class="fas fa-search card-icon"></i>
                                        <h3 class="mb-0">Find</h3>
                                        <h4 class="mb-0"> Media Rate</h4>
                                    </div>
                                </div>
                                <!-- Card 1 - Buy -->
                                <div class="col-md-4">
                                    <div class="custom-card-h bg-white">
                                        <i class="fas fa-shopping-cart card-icon"></i>
                                        <h3 class="mb-0">Buy</h3>
                                        <h4 class="mb-0"> Media Spot</h4>
                                    </div>
                                </div>

                                <!-- Card 2 - Plan -->
                                <div class="col-md-4">
                                    <div class="custom-card-h bg-white">
                                        <i class="fas fa-calendar-alt card-icon"></i>
                                        <h3 class="mb-0">Plan</h3>
                                         <h4 class="mb-0">Media Plan</h4>
                                    </div>
                                </div>

                                
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </header>


        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-auto">
                     <button class="px-4 py-2  text-sm font-medium " id ='tryNow'>Try Digital APP Now
                        </button>
                </div>
            </div>
        </div>


        <div class="container mt-3">
       

            <div class="flex flex-wrap justify-center gap-4 mb-8">
      
                <button class="px-4 py-2  text-sm font-medium " id = "myPointer" data-bs-toggle="modal" data-bs-target="#pdfModal">Preview RateCard pdf
                </button>
               
                <button class="px-4 py-2  text-sm font-medium " id = "myPointer" data-bs-toggle="modal" data-bs-target="#pModal">Preview Digital Rate pdf
                </button> 

                 <a href="/admin/Booking">
                    <button class="px-4 py-2  text-sm font-medium " id = "myPointer" style="">View Booking Page
                    </button>
                </a>
            </div>
        </div>



        <div class="container py-5">
           
            <h2 style="padding-bottom: 3%;"> Top Choice</h2>
            <div class="row row-cols-1 row-cols-md-3 row-cols-lg-3 g-2">
                <!-- Card 1 -->
                <div class="col" >
                    <div class="card  shadow-lg">
                        <img src="/public/uploads/MwananchiAds/youtube.jpg" alt="Product Image">
                        <div class="card-body" style = >
                            <h5 class="card-title">Banner</h5>
                            <p class="card-text">Mwananchi provides Banner Ads which are rectangular ads that are displayed along with the content..</p>
                       
                        </div>
                        <div class="card-footer bg-white">
                            <div class="d-flex justify-content-between align-items-center">
                              
                                <button class="btn btn-primary">Buy Now</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Card 2 -->
                <div class="col">
                    <div class="card mb-5 shadow-lg">
                        <img src="/public/uploads/MwananchiAds/youtube.jpg" alt="Product Image">
                        <div class="card-body">
                            <h5 class="card-title">Article</h5>
                            <p class="card-text">Mwananchi provides Banner Ads which are rectangular ads that are displayed along with the content.</p>
                          
                        </div>
                        <div class="card-footer bg-white">
                            <div class="d-flex justify-content-between align-items-center">
                            
                              <a href = "">  <button class="btn btn-primary"> Buy Now</button> </a>
                            </div>
                        </div>
                    </div>
                </div>

             
             

                   <!-- Card 3 -->
                <div class="col">
                    <div class="card shadow-lg">
                        <img src="/public/uploads/MwananchiAds/SharedScreenshot.jpg " class="card-img-top" alt="Product Image">
                        <div class="card-body">
                            <h5 class="card-title">Vedeo</h5>
                            <p class="card-text">Video Ad in Mwananchi are displayed on all pages ..</p>
                       
                        </div>
                        <div class="card-footer bg-white">
                            <div class="d-flex justify-content-between align-items-center">
                               
                                <button class="btn btn-primary">Buy Now</button>
                            </div>
                        </div>
                    </div>
                </div>


            

            </div>
        </div>



    
        <div class="container mt-5">
   
            <div class="card">
                <div class="card-header" style ="color:#0062cc;">
                  <h4> <i class="bi bi-robot me-2"></i>Ask Mwananchi, Our AI chatbot </h4>
                </div>
                <div class="card-body">
                    
                   

                    <!-- Textarea with buttons -->
                    <div class="textarea-container">
                        <textarea class="form-control" id="autoTypeTextarea" style= 'border:1px solid #141627;
                            box-shadow: 0 0 10px #719ECE; border-radius:10px;' rows="4" placeholder="Add notes..."></textarea>
                        

                    <div class="textarea-buttons">
                           
                       
                                 
                            <div class="d-flex gap-4">
                                <select class="form-select my-1 n-ask my-md-0 btn btn-sm  me-2" id="selectPlatform" name="selectPlatform" style="">
                                    <option  value = 'Facebook' ><i class="bi bi-save"></i>I want to know the Rate</option>
                                    <option value = 'Instagram'>Instagram</option>
                                    <option value = 'Youtube'>Youtube</option>
                                    <option value = 'Mwananchi'>Mwananchi</option>
                                    <option value = 'Citizen'>Citizen</option>
                                    <option value = 'Mwanaspoti'>Mwanaspoti</option>
                                    <option value = 'X'>X</option>
                                </select>

                                <select class="form-select my-1 n-ask my-md-0 btn btn-sm  me-2" id="selectPlatform" name="selectPlatform" style="">
                                    <option  value = 'Facebook' ><i class="bi bi-save"></i>I want to know the Rate</option>
                                    <option value = 'Instagram'>Instagram</option>
                                    <option value = 'Youtube'>Youtube</option>
                                    <option value = 'Mwananchi'>Mwananchi</option>
                                    <option value = 'Citizen'>Citizen</option>
                                    <option value = 'Mwanaspoti'>Mwanaspoti</option>
                                    <option value = 'X'>X</option>
                                </select>
                            </div>
                        

                         
                      
                        </div>
                    </div>

                 
                </div>
               
            </div>
            
        </div>
                 


            <!-- end row -->

    </div> <!-- container-fluid -->

    </div> <!-- content -->

<!-- ============================================================== -->
<!-- End Page content -->
<!-- =======================================================




<header class="header-slider">
    <div id="headerCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#headerCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#headerCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#headerCarousel" data-bs-slide-to="2"></button>
        </div>
        
        <div class="carousel-inner">
            <!-- Slide 1 --
            <div class="carousel-item active" style="background-image: url('https://analytive.com/wp-content/uploads/2024/04/facebook-ads-that-convert-1024x574-1024x585.png')">
              
            </div>
            
            <!-- Slide 2 --
            <div class="carousel-item" style="background-image: url('https://www.huptechweb.com/wp-content/uploads/2020/08/Blog-image-4.jpg')">
             
            </div>
            
            <!-- Slide 3 --
            <div class="carousel-item" style="background-image: url('https://source.unsplash.com/random/1920x1080/?meeting')">
              
            </div>
        </div>
        <div class="carousel-caption">
                    <h1 class="display-4">Professional Team</h1>
                    <p class="lead">Expert support and consultation</p>
                </div>
    
    </div>
</header>

======= -->




    <!-- PDF Viewer Modal -->
<div class="modal fade" id="pModal" tabindex="-1" aria-labelledby="pdfModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="pdfModalLabel">PDF Viewer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- PDF Viewer -->
                    <embed 
                        src="/public/uploads/pdf/d.pdf" 
                        type="application/pdf" 
                        style="width: 100%; height: 80vh;"
                        aria-label="PDF Document"
                    >
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>


      <!-- PDF Viewer Modal -->
<div class="modal fade" id="pdfModal" tabindex="-1" aria-labelledby="pdfModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="pdfModalLabel">PDF Viewer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- PDF Viewer -->
                    <embed 
                        src="/public/uploads/pdf/p.pdf" 
                        type="application/pdf" 
                        style="width: 100%; height: 80vh;"
                        aria-label="PDF Document"
                    >
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>





