<?php  
// database
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$output = '';
if(isset($_POST["export"]))
{
 $query = "SELECT * FROM item_inventory_analytics;";
 $result = mysqli_query($connect, $query);
 if(mysqli_num_rows($result) > 0)
 {
  $output .= '
   <table class="table" bordered="1">  
    <tr> 
    <th></th> 
    <th>Daily Relief Operation Status Report</th>
    </tr>
                    <tr>  
                        <th scope="col">Date</th>
                        <th scope="col">Item_Name</th>
                        <th scope="col">Item_Quantity</th>
                    </tr>
  ';
  while($row = mysqli_fetch_array($result))
  {
   $output .= '
                    <tr>  
                        <td>'.$row["Date"].'</td>  
                        <td>'.$row["I_Name"].'</td>  
                        <td>'.$row["I_Quantity"].'</td>  
                    </tr>
   ';
  }
  $output .= '</table>';
  header('Content-Type: application/xls');
  header('Content-Disposition: attachment; filename=Daily Relief Operation Status Report.xls');
  echo $output;
 }
}
?>