<?php

$posts = '';
if($data)
    foreach ($data as $item) {
        $id = $item['id'];
        $file = $item['media'];
        $username = strtolower(($users->get($item['user']))->username);
        $image = Util::staticUrl()."uploads/$username/data/$file";

        $posts .="
        
        <div class=\"col-xl-3 col-lg-4 col-md-6 natural personal\">
                        <div class=\"gal-detail thumb\">
                            <a href=\"$image\" class=\"image-popup\" title=\"Ajira Direct image\">
                                <img src=\"$image\" class=\"thumb-img img-fluid\" alt=\"work-thumbnail\">
                            </a>
                        </div>
                    </div>
        
        ";
    }
?>
    <div class="content">

        <!-- Start Content-->
        <div class="container-fluid">

            <div class="row">
                <div class="col-lg-12">
                    <div class="portfolioFilter">
                        <a href="#" data-filter="*" class="current waves-effect waves-primary">All</a>
<!--                        <a href="#" data-filter=".natural" class="waves-effect waves-primary">Natural</a>-->
<!--                        <a href="#" data-filter=".creative" class="waves-effect waves-primary">Creative</a>-->
<!--                        <a href="#" data-filter=".personal" class="waves-effect waves-primary">Personal</a>-->
<!--                        <a href="#" data-filter=".photography" class="waves-effect waves-primary">Photography</a>-->
                    </div>
                </div>
            </div>

            <div class="port mb-2">
                <div class="row portfolioContainer">
                    <?=$posts;?>
                </div><!-- end portfoliocontainer-->
            </div> <!-- End row -->

        </div> <!-- container -->

    </div> <!-- content -->
