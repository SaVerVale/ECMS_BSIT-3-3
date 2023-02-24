<?php  
// database
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$output = '';
if(isset($_POST["export"]))
{
 $query = "CALL viewEvacueeJoinHousehold";
 $result = mysqli_query($connect, $query);
 if(mysqli_num_rows($result) > 0)
 {
  $output .= '
   <table class="table" bordered="1">  
    <tr> 
    <th></th> 
    <th></th> 
    <th></th> 
    <th></th> 
    <th>Evacuees Status Report</th>
    </tr>
                    <tr>  
                        <th>Evacuee_ID</th>  
                        <th>Full_Name</th>  
                        <th>Sex</th>  
                        <th>Age</th>
                        <th>Contact_No</th>
                        <th>Room_ID</th>
                        <th>Household_ID</th>
                        <th>Evacuation_Status</th>
                    </tr>
  ';
  while($row = mysqli_fetch_array($result))
  {
   $output .= '
                    <tr>  
                        <td>'.$row["Evacuee_ID"].'</td>  
                        <td>'.$row["Full_Name"].'</td>  
                        <td>'.$row["Sex"].'</td>  
                        <td>'.$row["Age"].'</td>  
                        <td>'.$row["Contact_No"].'</td>
                        <td>'.$row["Room_ID"].'</td>  
                        <td>'.$row["Household_ID"].'</td>  
                        <td>'.$row["Evacuation_Status"].'</td>  
                    </tr>
   ';
  }
  $output .= '</table>';
  header('Content-Type: application/xls');
  header('Content-Disposition: attachment; filename=Evacuees Status Report.xls');
  echo $output;
 }
}
?>