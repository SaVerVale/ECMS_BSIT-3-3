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

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $Item_ID = $_POST['Item_ID'];
  $I_Name = $_POST['I_Name'];
  $Expiry = $_POST['Expiry'];
  $Quantity = $_POST['Quantity'];


  // if FirstName is empty, throw error because it is required
//   if (!$Item_ID) {
//     $errors[] = 'Please enter Item_ID';
//   }
  if (!$I_Name) {
    $errors[] = 'Please enter I_Name';
  }
  if (!$Expiry) {
    $errors[] = 'Please enter Expiry';
  }
  if (!$Quantity) {
    $errors[] = 'Please enter your Quantity';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addItem(:I_Name, :Expiry, :Quantity);
                                
                  ");
    // $statement->bindValue(':Item_ID', $Item_ID);
    $statement->bindValue(':I_Name', $I_Name);
    $statement->bindValue(':Expiry', $Expiry);
    $statement->bindValue(':Quantity', $Quantity);
    $statement->execute();

    // redirect user after creating
    header('Location: inventory.php');
  }
}

?>