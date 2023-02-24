<?php
// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// if FirstName is empty, throw error because it is required
$errors = [];

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  // $Household_ID = $_POST['Household_ID'];
  $Address = $_POST['Address'];
  $Family_Head = $_POST['Family_Head'];
  $Room_ID = $_POST['Room_ID'];
  $Date_Evacuated = $_POST['Date_Evacuated'];

  // if FirstName is empty, throw error because it is required
  if (!$Address) {
    $errors[] = 'Please enter Address';
  }
  if (!$Room_ID) {
    $errors[] = 'Please enter your Room_ID';
  }
  if (!$Date_Evacuated) {
    $errors[] = 'Please enter your Date_Evacuated';
  }
  if (!$Family_Head) {
    $Family_Head = $_POST['NULL'];
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addHousehold(:Address, :Family_Head, :Room_ID, :Date_Evacuated);
                                
                  ");
    // $statement->bindValue(':Household_ID', $Household_ID);
    $statement->bindValue(':Address', $Address);
    $statement->bindValue(':Family_Head', $Family_Head);
    $statement->bindValue(':Room_ID', $Room_ID);
    $statement->bindValue(':Date_Evacuated', $Date_Evacuated);
    $statement->execute();

    // redirect user after creating
    header('Location: evacuees.php');
  }
}