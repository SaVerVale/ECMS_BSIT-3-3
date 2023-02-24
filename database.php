<?php
// // <!-- create connection to database -->
$pdo = new PDO('mysql:host=localhost;port=3306;dbname=evac_management_system', 'root', '');
// $pdo = new PDO('mysql:host=localhost;port=3306;dbname=db_evac_management_sys_20230216', 'root', '');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "evac_management_system";
// $dbname = "db_evac_management_sys_20230216";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);
$conn2 = mysqli_connect($servername, $username, $password, $dbname);
$conn3 = mysqli_connect($servername, $username, $password, $dbname);
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$connect = mysqli_connect("localhost", "root", "", "evac_management_system");
$output = '';
?>

