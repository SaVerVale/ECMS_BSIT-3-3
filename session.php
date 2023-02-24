<?php
   include('database.php');
   session_start();
   
   $user_check = $_SESSION['login_user'];
   
   $ses_sql = mysqli_query($conn,"select User_ID from user where User_ID = '$user_check' ");
   
   $row = mysqli_fetch_array($ses_sql,MYSQLI_ASSOC);
   
   $login_session = $row['User_ID'];
   
   if(!isset($_SESSION['login_user'])){
      header("location:session_login.php");
      die();
   }
?>