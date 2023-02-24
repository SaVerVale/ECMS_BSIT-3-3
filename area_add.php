<?php
// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// if FirstName is empty, throw error because it is required
$errors = [];

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $A_Name = $_POST['A_Name'];
  $Center_ID = $_POST['Center_ID'];

  // if FirstName is empty, throw error because it is required
  if (!$A_Name) {
    $errors[] = 'Please enter your Area Name';
  }
  if (!$Center_ID) {
    $errors[] = 'Please enter your Center_ID';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addArea(:A_Name, :Center_ID);
                                
                  ");
                //   SELECT Household_ID FROM dagdaghh ORDER BY Household_ID ASC
    $statement->bindValue(':A_Name', $A_Name);
    $statement->bindValue(':Center_ID', $Center_ID);
    $statement->execute();

    // redirect user after creating
    header('Location: center.php');
  }
}