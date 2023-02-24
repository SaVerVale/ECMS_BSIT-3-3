<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

$Area_ID = $_POST['Area_ID'] ?? null;
if(!$Area_ID){
    header('Location: center.php');
    exit;
}

$statement = $pdo->prepare('CALL deleteArea(:Area_ID)');
$statement->bindValue(':Area_ID', $Area_ID);
$statement->execute();

// redirect to index
header("Location: center.php");
