<!-- Plugins css -->
<link href="<?=Util::staticUrl()?>assets/libs/dropzone/min/dropzone.min.css" rel="stylesheet" type="text/css" />
<link href="<?=Util::staticUrl()?>assets/libs/dropify/css/dropify.min.css" rel="stylesheet" type="text/css" />

<div class="col-12">


    <div class="form-group row">
        <label for="text" class="col-12 col-form-label">Title</label>
        <div class="col-sm-12 col-lg-6">
            <input id="text" value="<?php echo $title;?>" name="title" placeholder="Enter Title here" class="form-control here" required="required" type="text">
        </div>
    </div>
    <div class="form-group row">
        <label for="text" class="col-12 col-form-label">Type</label>
        <div class="col-sm-12 col-lg-6">
            <select class="form-control" name="type">
                <option value="">Select</option>
                <option value="free">Free</option>
                <option value="premium">Premium</option>
            </select>
        </div>
    </div>
    <br>


    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">

                    <div class="row">
                        <div class="col-lg-5">
                            <p>Drop PDF/DOC File</p>
                            <div class="mt-3">
                                <input type="file" id="fileUpload" data-plugins="dropify" data-height="300" accept="application/msword, application/vnd.ms-powerpoint,application/pdf" />
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <p>Drop cover image</p>
                            <div class="mt-3">
                                <input type="file" id="cvsUpload" accept="image/*" data-plugins="dropify" data-height="300" />
                            </div>
                        </div>
                    </div> <!-- end row -->
                    <br>
                    <div class="col-sm-12 col-lg-10 mb-3">
                        <label for="example-textarea" class="form-label">Caption</label>
                        <textarea class="form-control" name="caption" id="example-textarea" rows="5"></textarea>
                    </div><!-- end card-->
                </div> <!-- end card-body-->
            </div>


        </div><!-- end col -->
    </div>
    <!-- end row -->
    <!-- file preview template -->
    <div class="d-none" id="uploadPreviewTemplate">
        <div class="card mt-1 mb-0 shadow-none border">
            <div class="p-2">
                <div class="row align-items-center">
                    <div class="col-auto">
                        <img data-dz-thumbnail src="#" class="avatar-sm rounded bg-light" alt="">
                    </div>
                    <div class="col ps-0">
                        <a href="javascript:void(0);" class="text-muted fw-bold" data-dz-name></a>
                        <p class="mb-0" data-dz-size></p>
                    </div>
                    <div class="col-auto">
                        <!-- Button -->
                        <a href="" class="btn btn-link btn-lg text-muted" data-dz-remove>
                            <i class="dripicons-cross"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <p></p>
    <div  class="row">
        <div class="col-sm-7 col-lg-9"></div>
        <div class="col-sm-5 col-lg-3">
            <a class="btn btn-primary add-cvs">Add Files</a>
        </div>
    </div>
</div><!-- end col -->


