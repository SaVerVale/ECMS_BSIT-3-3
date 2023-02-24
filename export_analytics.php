<?php  
// database
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$output = '';
if(isset($_POST["export"]))
{
 $query = "SELECT * FROM evacuee_analytics";
 $result = mysqli_query($connect, $query);
 if(mysqli_num_rows($result) > 0)
 {
  $output .= '
   <table class="table" bordered="1">  
                    <tr>  
                        <th>Date</th>
                        <th>Household_Evacuated_Today</th>
                        <th>People_Evacuated_Today</th>
                        <th>Household_Evacuated_Total</th>
                        <th>People_Evacuated_Total</th>
                    </tr>
  ';
  while($row = mysqli_fetch_array($result))
  {
   $output .= '
                    <tr>  
                        <td>'.$row["Date"].'</td>  
                        <td>'.$row["Household_Evacuated_Today"].'</td>  
                        <td>'.$row["People_Evacuated_Today"].'</td>  
                        <td>'.$row["Household_Evacuated_Total"].'</td>  
                        <td>'.$row["People_Evacuated_Total"].'</td>  
                    </tr>
   ';
  }
  $output .= '</table>';
  header('Content-Type: application/xls');
  header('Content-Disposition: attachment; filename=Analytics.xls');
  echo $output;
 }
}
?>