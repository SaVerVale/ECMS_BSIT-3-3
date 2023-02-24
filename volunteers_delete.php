<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

$V_ID = $_POST['V_ID'] ?? null;
if(!$V_ID){
    header('Location: volunteers.php');
    exit;
}

$statement = $pdo->prepare('CALL deleteVolunteer(:V_ID)');
$statement->bindValue(':V_ID', $V_ID);
$statement->execute();

// redirect to index
header("Location: volunteers.php");