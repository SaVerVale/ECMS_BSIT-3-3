<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

$Evacuee_ID = $_POST['Evacuee_ID'] ?? null;
if(!$Evacuee_ID){
    header('Location: evacuees.php');
    exit;
}

$statement = $pdo->prepare('CALL deleteEvacuee(:Evacuee_ID)');
$statement->bindValue(':Evacuee_ID', $Evacuee_ID);
$statement->execute();

// redirect to index
header("Location: evacuees.php");
