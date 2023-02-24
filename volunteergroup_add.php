<?php
// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// if FirstName is empty, throw error because it is required
$errors = [];

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $G_Name = $_POST['G_Name'];
  $Area_ID = $_POST['Area_ID'];

  // if FirstName is empty, throw error because it is required
  if (!$G_Name) {
    $errors[] = 'Please enter your Volunteer Name';
  }
  if (!$Area_ID) {
    $errors[] = 'Please enter your Birthday';
  }


  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addVolunteerGroup(:G_Name, :Area_ID);
                                
                  ");
                //   SELECT Household_ID FROM dagdaghh ORDER BY Household_ID ASC
    $statement->bindValue(':G_Name', $G_Name);
    $statement->bindValue(':Area_ID', $Area_ID);
    $statement->execute();

    // redirect user after creating
    header('Location: volunteers.php');
  }
}