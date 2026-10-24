 


<style>
/* Custom CSS */
.table-responsive {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.table {
  min-width: 600px; /* Minimum width before scrolling */
  table-layout: fixed;
}

@media (max-width: 768px) {
  .table {
    min-width: 100%;
    font-size: 0.875rem;
  }
  
  .card-body {
    padding: 0.5rem !important;
  }
  
  th, td {
    padding: 0.5rem !important;
  }
}

.text-truncate {
  max-width: 200px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>


<div class="card shadow">
	 <div class="card-header">
	    <h3 class="mb-0">Invoice</h3>
	    <small class="text-muted">Date: <?= date('Y-m-d') ?></small>
	</div>
  <div class="card-body p-2">
    <!-- Responsive table container -->
    <div class="table-responsive">
      <table class="table table-sm table-borderless mb-0">
        <thead>
          <tr class="bg-light">
            <th style="width: 40%;">Ads-Type</th>
            <th style="width: 40%;">Dimension</th>
            <th style="width: 20%;">Price</th>
            <th style="width: 15%;">Qty</th>
            <th style="width: 25%;">Total</th>
          </tr>
        </thead>
        <tbody>
          <!-- Sample Data -->
           <?= $table; ?>
        
        </tbody>
      </table>	
    </div>

    <!-- Totals Section -->
    <div class="row mt-3 g-2">
      <div class="col-6"></div>
      <div class="col-6">

        <div class="table-responsive">
          <table class="table table-sm mb-0">
            <tr>
              <td>Subtotal:</td>
              <td><?=  $totalPrice; ?> Tsh</td>
            </tr>
            <tr>
              <td>Tax (10%):</td>
              <td>0 Tsh</td>
            </tr>
            <tr class="fw-bold">
              <td>Total:</td>
              <td><?= $totalPrice; ?></td>
            </tr>
          </table>
        </div>
      </div>
    </div>
  </div>
     <div class="card-footer text-end">
                <button class="btn btn-primary" onclick="window.print()">Print Invoice</button>
            </div>
</div>



