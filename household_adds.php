<?php
// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// if FirstName is empty, throw error because it is required
$errors = [];

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $Address = $_POST['Address'];
    $Family_Head = $_POST['Family_Head'];
    $Room_ID = $_POST['Room_ID'];
    $Date_Evacuated = $_POST['Date_Evacuated'];
    
  
    // if FirstName is empty, throw error because it is required
    if (!$Address) {
      $errors[] = 'Please enter Address';
    }
    if (!$Date_Evacuated) {
      $errors[] = 'Please enter Date_Evacuated';
    }
    if (!$Room_ID) {
      $errors[] = 'Please enter Room_ID';
    }
  
  
    // Only Submit to sql when it is not empty
    if (empty($errors)) {
  
      // double quotations are used so I can use variables in strings
      // exec() instead of prepare() should be avoided because it is unsafe
      // I created named parameters
      // CALL addHousehold('Dolores', NULL, 'RM-002', '2023-02-14');
      // "CALL addHousehold(:Address, :Family_Head, :Room_ID, :Date_Evacuated)"
      $statement2 = $pdo->prepare("INSERT INTO household (Address, Family_Head, Room_ID, Date_Evacuated)
                                  VALUES (:Address, :Family_Head, :Room_ID, :Date_Evacuated);");
  
      $statement2->bindValue(':Address', $Address);
      $statement2->bindValue(':Family_Head', $Family_Head);
      $statement2->bindValue(':Room_ID', $Room_ID);
      $statement2->bindValue(':Date_Evacuated', $Date_Evacuated);
      $statement2->execute();
  
      // redirect user after creating
      header('Location: evacuees.php');
    }
  }






?>