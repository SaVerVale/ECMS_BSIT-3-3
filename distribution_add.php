<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

if(isset($_POST['submit'])){
    if(!empty($_POST['household'])) {
      foreach($_POST['household'] as $selected){
        echo '  ' . $selected;
      }          
    } else {
      echo 'Please select the value.';
    }
  }

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $Item_ID = $_POST['Item_ID'];
  $Household_ID = $_POST['Household_ID'];
  $Relief_ID = $_POST['Relief_ID'];
  $Date_Given = $_POST['Date_Given'];


  // if FirstName is empty, throw error because it is required
//   if (!$Item_ID) {
//     $errors[] = 'Please enter Item_ID';
//   }
  if (!$Household_ID) {
    $errors[] = 'Please enter Household_ID';
  }
  if (!$Relief_ID) {
    $errors[] = 'Please enter Relief_ID';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addDistribution(:Household_ID, :Relief_ID, :Date_Given);
                                
                  ");
    // $statement->bindValue(':Distribution_ID', $Distribution_ID);
    $statement->bindValue(':Household_ID', $Household_ID);
    $statement->bindValue(':Relief_ID', $Relief_ID);
    $statement->bindValue(':Date_Given', '2022-01-30');
    $statement->execute();

    // redirect user after creating
    header('Location: distribution.php');
  }
}

?>