<?php

$posts = '';
$n = 1;
if($data)
    foreach ($data as $item) {
        $id = $item['id'];
        $title = $item['title'];
        $summary = $item['summary'];
        $cover = $item['cover'];
        $file = $item['file'];
        $username = $item['username'];
        $name = $item['fullname'];
        $date = Util::ago($item['created_at']);
        $cur = Util::staticUrl().'uploads/'.strtolower($username).'/data/'.$cover;
        $cover = !empty($cover) ? "<img src='$cur' width='100' alt='$title'>" :'';
        $file = !empty($file) ? Util::staticUrl().'uploads/'.strtolower($username).'/data/'.$file :'';

      $posts .= "
        <tr>
                            <td>$n</td>
                            <td>$title</td>
                            <td>$name</td>
                            <td>$cover</td>
                            <td>$date</td>
                            <td><a href='$file' class='btn btn-primary'>Download</a></td>
                        </tr>
      ";

      $n++;
    }
?>
<div class="container-fluid">

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <h4 class="mt-0 header-title">All Posts</h4>
                    <p class="text-muted font-14 mb-3">
                    </p>

                    <table id="datatable" class="table table-bordered dt-responsive table-responsive nowrap">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Cover</th>
                            <th>Created at</th>
                            <th>Action</th>
                        </tr>
                        </thead>


                        <tbody>
                            <?=$posts?>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div> <!-- end row -->


</div> <!-- container-fluid -->
