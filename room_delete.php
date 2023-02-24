<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

$Room_ID = $_POST['Room_ID'] ?? null;
if(!$Room_ID){
    header('Location: center.php');
    exit;
}

$statement = $pdo->prepare('CALL deleteRoom(:Room_ID)');
$statement->bindValue(':Room_ID', $Room_ID);
$statement->execute();

// redirect to index
header("Location: center.php");
