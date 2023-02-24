<?php

// if(isset($_POST['submit'])){
//     if(!empty($_POST['lols'])) {
//       foreach($_POST['lols'] as $selected){
//         echo '  ' . $selected;
//       }          
//     } else {
//       echo 'Please select the value.';
//     }
//   }

//   isset($_POST['lols']);

foreach($_POST['lols'] as $checkbox) {
    echo $checkbox. '<br>';// do something
 }

//  if (isset($_POST['lols'])){
//     echo $_POST['lols']; // Displays value of checked checkbox.
//     }

    if (isset($_POST['lols'])) 
    {
        print_r($_POST['lols']); 
    }
?>