<?php
// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// if FirstName is empty, throw error because it is required
$errors = [];

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $V_Name = $_POST['V_Name'];
  $V_Birthday = $_POST['V_Birthday'];
  $V_Sex = $_POST['V_Sex'];
  $V_Group = $_POST['V_Group'];

  // if FirstName is empty, throw error because it is required
  if (!$V_Name) {
    $errors[] = 'Please enter your Volunteer Name';
  }
  if (!$V_Birthday) {
    $errors[] = 'Please enter your Birthday';
  }
  if (!$V_Sex) {
    $errors[] = 'Please enter your Gender';
  }
  if (!$V_Group) {
    $errors[] = 'Please enter your Volunteer_Group';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addVolunteer(:V_Name, :V_Birthday, :V_Sex, :V_Group);
                                
                  ");
                //   SELECT Household_ID FROM dagdaghh ORDER BY Household_ID ASC
    $statement->bindValue(':V_Name', $V_Name);
    $statement->bindValue(':V_Birthday', $V_Birthday);
    $statement->bindValue(':V_Sex', $V_Sex);
    $statement->bindValue(':V_Group', $V_Group);
    $statement->execute();

    // redirect user after creating
    header('Location: volunteers.php');
  }
}