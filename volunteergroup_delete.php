<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

$V_Group = $_POST['V_Group'] ?? null;
if(!$V_Group){
    header('Location: volunteers.php');
    exit;
}

$statement = $pdo->prepare('CALL deleteVolunteerGroup(:V_Group)');
$statement->bindValue(':V_Group', $V_Group);
$statement->execute();

// redirect to index
header("Location: volunteers.php");