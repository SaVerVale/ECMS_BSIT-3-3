<?php
// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// if FirstName is empty, throw error because it is required
$errors = [];

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $Household_ID = $_POST['Household_ID'];
  $Items = $_POST['Items'];
  $Date_Given = $_POST['Date_Given'];

  // if FirstName is empty, throw error because it is required
  if (!$Household_ID) {
    $errors[] = 'Please enter your Household_ID';
  }
  if (!$Items) {
    $errors[] = 'Please enter your Items';
  }
  if (!$Date_Given) {
    $errors[] = 'Please enter Items';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {
    
    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addDistribution(:Household_ID, :Items, :Date_Given);
                                
                  ");

    $statement->bindValue(':Household_ID', $Household_ID);
    $statement->bindValue(':Items', $Items);
    $statement->bindValue(':Date_Given', $Date_Given);
    $statement->execute();

    // redirect user after creating
    header('Location: distribution.php#anchor');
  }
}