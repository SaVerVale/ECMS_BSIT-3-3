<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

$Item_ID = $_POST['Item_ID'] ?? null;
if(!$Item_ID){
    header('Location: inventory.php');
    exit;
}

$statement = $pdo->prepare('CALL deleteItem(:Item_ID)');
$statement->bindValue(':Item_ID', $Item_ID);
$statement->execute();

// redirect to index
header("Location: inventory.php");
