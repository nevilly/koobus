<?php

$users = '';
if($data != null && is_array($data))
    foreach ($data as $datum) {
        $id = $datum['id'];
        $username = $datum['username'];
        $full_name = ucfirst($datum['first_name'])." ".ucfirst($datum['last_name']);
        $mobile = $datum['phone_number'];
        $notified = $datum['notified'];
        $type = strtoupper($datum['type']);
        $email = $datum['email'];
        $avatar = $datum['avatar'];
        $status = $datum['status'];
        $address = $datum['address'];
        $country = $datum['country'];
        $bio = nl2br($datum['bio']);
        $u = strtolower($username);
        $status = $status == '1' ? "<span class='btn-success p-1 rounded-3'>Active</span>" : "<span class='bg-green p-3'>Not Active</span>";
        $avatar = !empty($avatar) ? Util::Url()."/public/uploads/$u/data/$avatar" : Util::Url()."/public/images/user.png";

        $users .="<div class=\"col-xl-4\">
                    <div class=\"card\">
                        <div class=\"text-center card-body\">
                            <div class=\"dropdown float-end\">
                                <a href=\"#\" class=\"dropdown-toggle arrow-none card-drop\"  data-bs-toggle=\"dropdown\" aria-expanded=\"false\">
        <i class=\"mdi mdi-dots-vertical\"></i>
                                </a>
                                <div class=\"dropdown-menu dropdown-menu-end\">
                                    <!-- item-->
                                    <a href=\"javascript:void(0);\" class=\"dropdown-item\">Action</a>
                                    <!-- item-->
                                    <a href=\"javascript:void(0);\" class=\"dropdown-item\">Suspend Account</a>
                                    <!-- item-->
                                    <a href=\"javascript:void(0);\" class=\"dropdown-item\">Delete Account</a>
                                </div>
                            </div>
                            <div>
                                <img src=\"$avatar\" class=\"rounded-circle avatar-xl img-thumbnail mb-2\" alt=\"profile-image\">

                                <p class=\"text-muted font-13 mb-3\">
                                    $bio
                                </p>

                                <div class=\"text-start\">
                                    <p class=\"text-muted font-13\"><strong>Full Name :</strong> <span class=\"ms-2\">$full_name</span></p>

                                    <p class=\"text-muted font-13\"><strong>Mobile :</strong><span class=\"ms-2\">$mobile</span></p>

                                    <p class=\"text-muted font-13\"><strong>Email :</strong> <span class=\"ms-2\">$email</span></p>

                                    <p class=\"text-muted font-13\"><strong>Account Type :</strong> <span class=\"ms-2\">$type</span></p>
                                    
                                    <p class=\"text-muted font-13\"><strong>Location :</strong> <span class=\"ms-2\">$address,$country</span></p>
                                    
                                    <p class=\"text-muted font-13\"><strong>Status :</strong> $status</p>
                                </div>

                               <!--<button type=\"button\" class=\"btn btn-primary rounded-pill waves-effect waves-light\">Send Message</button>-->
                            </div>
                        </div>
                    </div>
                    
                </div> <!-- end col -->
        ";
    }
?>
    <div class="content">

        <!-- Start Content-->
        <div class="container-fluid">

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="row justify-content-between">
                                <div class="col-md-4">
                                    <div class="mt-3 mt-md-0">
<!--                                        <a href="#" type="button" class="btn btn-success waves-effect waves-light" data-bs-toggle="modal" data-bs-target="#custom-modal"><i class="mdi mdi-plus-circle me-1"></i> Add contact</a>-->
                                    </div>
                                </div><!-- end col-->
                                <div class="col-md-8">
                                    <form class="d-flex flex-wrap align-items-center justify-content-sm-end">
                                        <label for="status-select" class="me-2">Sort By</label>
                                        <div class="me-sm-2">
                                            <select class="form-select my-1 my-md-0" id="status-select">
                                                <option selected="">All</option>
                                                <option value="1">Name</option>
<!--                                                <option value="2">Post</option>-->
<!--                                                <option value="3">Followers</option>-->
<!--                                                <option value="4">Followings</option>-->
                                            </select>
                                        </div>
                                        <label for="inputPassword2" class="visually-hidden">Search</label>
                                        <div>
                                            <input type="search" class="form-control my-1 my-md-0" id="inputPassword2" placeholder="Search...">
                                        </div>
                                    </form>
                                </div>
                            </div> <!-- end row -->
                        </div>
                    </div> <!-- end card -->
                </div><!-- end col-->
            </div>
            <!-- end row -->
            <div class="row">
                <?=$users?>
            </div>
            <!-- end row -->
        </div> <!-- container -->

    </div> <!-- content -->
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModalCenter">
    Vertically centered modal
</button>
<div class="modal" tabindex="-1"  id="exampleModalCenter">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="input-group mb-3">
                    <span class="input-group-text" id="basic-addon1">@</span>
                    <input type="text" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="basic-addon1">
                </div>

                <div class="input-group mb-3">
                    <input type="text" class="form-control" placeholder="Recipient's username" aria-label="Recipient's username" aria-describedby="basic-addon2">
                    <span class="input-group-text" id="basic-addon2">@example.com</span>
                </div>

                <div class="mb-3">
                    <label for="basic-url" class="form-label">Your vanity URL</label>
                    <div class="input-group">
                        <span class="input-group-text" id="basic-addon3">https://example.com/users/</span>
                        <input type="text" class="form-control" id="basic-url" aria-describedby="basic-addon3 basic-addon4">
                    </div>
                    <div class="form-text" id="basic-addon4">Example help text goes outside the input group.</div>
                </div>

                <div class="input-group mb-3">
                    <img src="..." class="card-img-top w-100 h-100 bg-primary upload"  alt="...">
                    <input type="file" id="fileUpload" style="display:none">
                    <div class="featured"></div>
                </div>

                <div class="input-group mb-3">
                    <input type="text" class="form-control" placeholder="Username" aria-label="Username">
                    <span class="input-group-text">@</span>
                    <input type="text" class="form-control" placeholder="Server" aria-label="Server">
                </div>

                <div class="input-group">
                    <span class="input-group-text">With textarea</span>
                    <textarea class="form-control" aria-label="With textarea"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary savedata">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php
echo $this->team_member();
?>