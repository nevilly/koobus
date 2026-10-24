
<!-- Footer Start -->
<footer class="footer" >
    <div class="container-fluid" >
        <div class="row">
            <div class="col-md-6">
                <script>document.write(new Date().getFullYear())</script> &copy; <?= self::$APP.' ';  echo getenv("Version");?> by <a href="https://www.linkedin.com/in/frankgalos/">Nehemia Mwansasu</a>
            </div>
            <div class="col-md-6">
                <div class="text-md-end footer-links d-none d-sm-block">
                    <a href="https://owesis.com/about">About Us</a>
                    <a href="mailto:frankgalos@hotmail.com">Help</a>
                    <a href="https://owesis.com/contact">Contact Us</a>
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- end Footer -->

</div>

</div>
<!-- END wrapper -->

<!-- Right Sidebar -->
<div class="right-bar" >

    <div data-simplebar class="w-100 h-100" >

        <div class="rightbar-title">
            <a href="javascript:void(0);" class="right-bar-toggle float-end">
                <i class="mdi mdi-close"></i>
            </a>
            <h4 class="font-16 m-0 text-white">Customize</h4>
        </div>

        <!-- Tab panes -->
        <div class="tab-content pt-0">

            <div class="tab-pane active" id="settings-tab" role="tabpanel">

                <div class="p-3">
                    <div class="alert alert-warning" role="alert">
                        <strong>Customize </strong> the overall color scheme, Layout, etc.
                    </div>

                    <h6 class="fw-medium font-14 mt-4 mb-2 pb-1">Color Scheme</h6>
              <div class="col-xl-6 ">
                    <div class="card">
                        <div class="card-body widget-user">
                            <div class="d-flex align-items-center">
                                <div class="flex-shrink-0 avatar-lg me-3">
                                    <img src="../public/assets/images/user.png" class="img-fluid rounded-circle" alt="user">
                                </div>
                                <div class="flex-grow-1 overflow-hidden">
                                    <h5 class="mt-0 mb-1">Chadengle</h5>
                                    <p class="text-muted mb-2 font-13 text-truncate">employee@gmail.com</p>
                                    <small class="text-warning"><b>Admin</b></small>
                                </div>
                            </div>
                        </div>
                    </div>

                </div><!-- end col -->


                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="layout-color" value="light"
                               id="light-mode-check" checked />
                        <label class="form-check-label" for="light-mode-check">Light Mode</label>
                    </div>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="layout-color" value="dark"
                               id="dark-mode-check" />
                        <label class="form-check-label" for="dark-mode-check">Dark Mode</label>
                    </div>

                    <!-- Width -->
                    <h6 class="fw-medium font-14 mt-4 mb-2 pb-1">Width</h6>
                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="layout-size" value="fluid" id="fluid" checked />
                        <label class="form-check-label" for="fluid-check">Fluid</label>
                    </div>
                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="layout-size" value="boxed" id="boxed" />
                        <label class="form-check-label" for="boxed-check">Boxed</label>
                    </div>

                    <!-- Menu positions -->
                    <h6 class="fw-medium font-14 mt-4 mb-2 pb-1">Menus (Leftsidebar and Topbar) Positon</h6>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-position" value="fixed" id="fixed-check"
                               checked />
                        <label class="form-check-label" for="fixed-check">Fixed</label>
                    </div>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-position" value="scrollable"
                               id="scrollable-check" />
                        <label class="form-check-label" for="scrollable-check">Scrollable</label>
                    </div>

                    <!-- Left Sidebar-->
                    <h6 class="fw-medium font-14 mt-4 mb-2 pb-1">Left Sidebar Color</h6>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-color" value="light" id="light" />
                        <label class="form-check-label" for="light-check">Light</label>
                    </div>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-color" value="dark" id="dark" checked/>
                        <label class="form-check-label" for="dark-check">Dark</label>
                    </div>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-color" value="brand" id="brand" />
                        <label class="form-check-label" for="brand-check">Brand</label>
                    </div>

                    <div class="form-check form-switch mb-3">
                        <input type="checkbox" class="form-check-input" name="leftbar-color" value="gradient" id="gradient" />
                        <label class="form-check-label" for="gradient-check">Gradient</label>
                    </div>

                    <!-- size -->
                    <h6 class="fw-medium font-14 mt-4 mb-2 pb-1">Left Sidebar Size</h6>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-size" value="default"
                               id="default-size-check" checked />
                        <label class="form-check-label" for="default-size-check">Default</label>
                    </div>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-size" value="condensed"
                               id="condensed-check" />
                        <label class="form-check-label" for="condensed-check">Condensed <small>(Extra Small size)</small></label>
                    </div>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="leftbar-size" value="compact"
                               id="compact-check" />
                        <label class="form-check-label" for="compact-check">Compact <small>(Small size)</small></label>
                    </div>

                    <!-- User info -->
                    <h6 class="fw-medium font-14 mt-4 mb-2 pb-1">Sidebar User Info</h6>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="sidebar-user" value="true" id="sidebaruser-check" />
                        <label class="form-check-label" for="sidebaruser-check">Enable</label>
                    </div>


                    <!-- Topbar -->
                    <h6 class="fw-medium font-14 mt-4 mb-2 pb-1">Topbar</h6>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="topbar-color" value="dark" id="darktopbar-check"
                               checked />
                        <label class="form-check-label" for="darktopbar-check">Dark</label>
                    </div>

                    <div class="form-check form-switch mb-1">
                        <input type="checkbox" class="form-check-input" name="topbar-color" value="light" id="lighttopbar-check" />
                        <label class="form-check-label" for="lighttopbar-check">Light</label>
                    </div>

                </div>

            </div>
        </div>

    </div> <!-- end slimscroll-menu-->
</div>
<!-- /Right-bar -->

<!-- Right bar overlay-->
<div class="rightbar-overlay"></div>

  

<!-- Vendor -->
<script src="<?=Util::staticUrl()?>assets/libs/jquery/jquery.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/simplebar/simplebar.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/node-waves/waves.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/waypoints/lib/jquery.waypoints.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/jquery.counterup/jquery.counterup.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/feather-icons/feather.min.js"></script>

<!-- knob plugin -->
<script src="<?=Util::staticUrl()?>assets/libs/jquery-knob/jquery.knob.min.js"></script>

<!-- Plugins js -->
<script src="<?=Util::staticUrl()?>assets/libs/quill/quill.min.js"></script>

<!-- Init js-->
<!--<script src="--><?//=Util::staticUrl()?><!--assets/js/pages/form-quilljs.init.js"></script>-->
<?php if($this->route == "Home"){?>

<!--Morris Chart-->
<script src="<?=Util::staticUrl()?>assets/libs/morris.js06/morris.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/raphael/raphael.min.js"></script>


<!-- third party js -->
<script src="<?=Util::staticUrl()?>assets/libs/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
<!-- third party js ends -->

<!-- Datatables init -->
<script src="<?=Util::staticUrl()?>assets/js/pages/datatables.init.js"></script>


    <!-- Dashboar init js-->
    <script src="<?=Util::staticUrl()?>assets/js/pages/dashboard.init.js"></script>

<?php }?>


<script src="<?=Util::staticUrl()?>assets/libs/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/libs/datatables.net-select/js/dataTables.select.min.js"></script>
<script src="<?=Util::staticUrl()?>assets/js/pages/datatables.init.js"></script>

<script src="<?=Util::staticUrl()?>assets/libs/dropify/js/dropify.min.js"></script>
<!-- Plugins js -->
<script src="<?=Util::staticUrl()?>assets/libs/dropzone/min/dropzone.min.js"></script>

<!-- Init js-->
<script src="<?=Util::staticUrl()?>assets/js/pages/form-fileuploads.init.js"></script>

<script src="<?=Util::staticUrl()?>assets/libs/selectize/js/standalone/selectize.min.js"></script>

<!-- App js-->
<script src="<?=Util::staticUrl()?>assets/js/app.js"></script>
<!--<script src="--><?//=Util::Url()?><!--assets/js/app.min.js"></script>-->

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
 





<script src="https://unpkg.com/typed.js@2.1.0/dist/typed.umd.js"></script>
<script type="text/javascript">
  var  typed = new Typed('.auto-type',{
    strings: ["Advertise","Connect","Succeed"],
    typeSpeed:150,
    backSpeed:150,
    loop:true
  }); 
</script>


<script type="text/javascript">
	// Select the textarea element
const textarea = document.getElementById('autoTypeTextarea');

// Text to be auto-typed
const textToType = "Hello! This text is being automatically typed into the textarea. ✨";
let index = 0;

// Typing function
function typeText() {
  if (index < textToType.length) {
    textarea.classList.add('cursor');
    textarea.value += textToType.charAt(index);
    index++;
    setTimeout(typeText, 50);
  } else {
    textarea.classList.remove('cursor');
  }
}
</script>


<!--Start of Tawk.to Script-->
<script type="text/javascript">
var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();

(function(){
var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;
s1.src='https://embed.tawk.to/67e6bae9338fd8190ed1c41d/1inekk8t9';
s1.charset='UTF-8';
s1.setAttribute('crossorigin','*');
s0.parentNode.insertBefore(s1,s0);
})();
</script>
<!--End of Tawk.to Script-->




<script>


    const dataElement = document.getElementById('data-container');
 console.log(dataElement);

   // const items = JSON.parse(dataElement.dataset.array);
    //console.log(items);

    const items = [
             { brand: 'Wooden Chair', price: 125.99, dimension: '80x50x60 cm', position: 'Warehouse A' },
             { brand: 'Office Desk', price: 299.50, dimension: '150x75x70 cm', position: 'Showroom' },
            { brand: 'Reading Lamp', price: 45.00, dimension: '30x30x40 cm', position: 'Storage Room' },
             { brand: 'Bookshelf', price: 179.95, dimension: '180x40x200 cm', position: 'Warehouse B' },
             { brand: 'Coffee Table', price: 149.99, dimension: '120x60x45 cm', position: 'Display Area' },
             { brand: 'Computer Monitor', price: 199.00, dimension: '52x35x5 cm', position: 'Electronics Section' },
             { brand: 'Filing Cabinet', price: 89.75, dimension: '45x40x70 cm', position: 'Office Supplies' },
             { brand: 'Patio Umbrella', price: 129.50, dimension: '300x300x250 cm', position: 'Outdoor Section' },
             { brand: 'Throw Pillow', price: 24.99, dimension: '40x40x10 cm', position: 'Home Decor' },
            { brand: 'Wall Clock', price: 34.95, dimension: '30x30x5 cm', position: 'Decorations' }
      ];

           


       // Initial render
        renderItems(items);


         // Search functionality
        document.getElementById('searchInput').addEventListener('input',function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const filteredItems = items.filter(item => {

                console.log(filteredItems);
                return item.brand.toLowerCase().includes(searchTerm) ||
                       item.position.toLowerCase().includes(searchTerm) || item.size.toLowerCase().includes(searchTerm);
                        });
              renderItems(filteredItems);

            });

            


     // Render items function
        function renderItems(itemsToRender) {
            const itemList = document.getElementById('search-dropdown');

            console.log('------Am Here-----');
            console.log(itemList);
             console.log('------Am Here-----');

            if (itemsToRender.length === 0) {
                itemList.innerHTML = '<div class="no-items">No items found matching your search</div>';
                return;
            }

              console.log(itemList);
              itemList.innerHTML = itemsToRender.map(item => `<div id="resultsContainer" class="bg-white rounded shadow-sm">
                    <div class="product-item p-3">
                        <div class="row align-items-center g-0">
                            <!-- Image First -->
                            <div class="col-auto">
                                <img src="https://via.placeholder.com/120x120" 
                                     class="product-img rounded"
                                     alt="Product Image">
                            </div>
                            <div class="item-name">${item.brand}</div>
                            <div class="item-property">
                                <i class="fas fa-tag"></i> Price: ${item.price.toFixed(2)}
                            </div>
                            <div class="item-property">
                                <i class="fas fa-ruler-combined"></i> Dimension: ${item.brand}
                            </div>
                            <div class="item-property">
                                <i class="fas fa-map-marker-alt"></i> Position: ${item.brand}
                            </div>
                        </div>
                    </div>
                </div>
            `).join('');



              console.log( );
        }
        












        const filterButton = document.getElementById('filterButton');
        const filterDropdown = document.getElementById('filterDropdown');

        // Toggle dropdown
        filterButton.addEventListener('click', (e) => {
            e.stopPropagation();
            filterDropdown.classList.toggle('active');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.filter-wrapper')) {
                filterDropdown.classList.remove('active');
            }
        });

        // Optional: Close dropdown when scrolling
        window.addEventListener('scroll', () => {
            filterDropdown.classList.remove('active');
        });
    </script>
 
      

</body>
</html>