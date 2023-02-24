<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// // if FirstName is empty, throw error because it is required
// $errors = [];

// // solution when FirstName, etc is empty
// // $Item_ID = '';
// $I_Name = '';
// $Expiry = '';
// $Quantity = '';

// // add pack zxc
// $Relief_ID = '';
// $Item_ID = '';
// $Date_Packed = '';
// $R_Quantity = '';


// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $Relief_ID = $_POST['Relief_ID'];
  $Item_ID = $_POST['Item_ID'];
  $Date_Packed = $_POST['Date_Packed'];
  $R_Quantity = $_POST['R_Quantity'];


  // if FirstName is empty, throw error because it is required
  if (!$Relief_ID) {
    $errors[] = 'Please enter Relief_ID';
  }
  if (!$Item_ID) {
    $errors[] = 'Please enter Item_ID';
  }
  if (!$Date_Packed) {
    $errors[] = 'Please enter Date_Packed';
  }
  if (!$R_Quantity) {
    $errors[] = 'Please enter your R_Quantity';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addReliefGoodNew(:Relief_ID, :Item_ID, :Date_Packed, :R_Quantity);
                                
                  ");
    $statement->bindValue(':Relief_ID', $Relief_ID);
    $statement->bindValue(':Item_ID', $Item_ID);
    $statement->bindValue(':Date_Packed', $Date_Packed);
    $statement->bindValue(':R_Quantity', $R_Quantity);
    $statement->execute();

    // redirect user after creating
    header('Location: inventory.php');
  }
}

?>