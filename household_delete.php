<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

$Household_ID = $_POST['Household_ID'] ?? null;
if(!$Household_ID){
    header('Location: evacuees.php');
    exit;
}

$statement = $pdo->prepare('CALL deleteHousehold(:Household_ID)');
$statement->bindValue(':Household_ID', $Household_ID);
$statement->execute();

// redirect to index
header("Location: evacuees.php");
