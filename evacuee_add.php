<?php
// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// if FirstName is empty, throw error because it is required
$errors = [];

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $First_Name = $_POST['First_Name'];
  $Middle_Name = $_POST['Middle_Name'];
  $Last_Name = $_POST['Last_Name'];
  $Sex = $_POST['Sex'];
  $Birthday = $_POST['Birthday'];
  $Contact_No = $_POST['Contact_No'];
  $Household_ID = $_POST['Household_ID'];


  // if FirstName is empty, throw error because it is required
  if (!$First_Name) {
    $errors[] = 'Please enter your First Name';
  }
  if (!$Last_Name) {
    $errors[] = 'Please enter your Last Name';
  }
  if (!$Sex) {
    $errors[] = 'Please enter your Gender';
  }
  if (!$Contact_No) {
    $errors[] = 'Please enter your Contact No';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addEvacuee(:First_Name, :Middle_Name, :Last_Name, :Sex, :Birthday, :Contact_No, :Household_ID);
                                
                  ");
                //   SELECT Household_ID FROM dagdaghh ORDER BY Household_ID ASC
    $statement->bindValue(':First_Name', $First_Name);
    $statement->bindValue(':Middle_Name', $Middle_Name);
    $statement->bindValue(':Last_Name', $Last_Name);
    $statement->bindValue(':Sex', $Sex);
    $statement->bindValue(':Birthday', $Birthday);
    $statement->bindValue(':Contact_No', $Contact_No);
    $statement->bindValue(':Household_ID', $Household_ID);
    $statement->execute();

    // redirect user after creating
    header('Location: evacuees.php');
  }
}