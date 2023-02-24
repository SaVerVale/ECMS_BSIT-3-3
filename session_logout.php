<?php
   session_start();
   
   if(session_destroy()) {
      header("Location: session_login.php");
   }
?>