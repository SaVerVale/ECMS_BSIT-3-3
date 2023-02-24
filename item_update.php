<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$Item_ID = $_GET['Item_ID'] ?? null;
if (!$Item_ID) {
  header('Location: inventory.php');
  exit;
}

$statement = $pdo->prepare('SELECT * FROM item_inventory WHERE Item_ID = :Item_ID');
$statement->bindValue(':Item_ID', $Item_ID);
$statement->execute();
$item2 = $statement->fetch(PDO::FETCH_ASSOC);

// if Name is empty, throw error because it is required
$errors = [];

// solution when Name etch is empty
$Item_ID = $item2['Item_ID'];
$I_Name = $item2['I_Name'];
$Expiry = $item2['Expiry'];
$I_Quantity = $item2['I_Quantity'];

// show request method
// echo $_SERVER['REQUEST_METHOD']. '<br>';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $Item_ID = $_POST['Item_ID'];
  $I_Name = $_POST['I_Name'];
  $Expiry = $_POST['Expiry'];
  $I_Quantity = $_POST['I_Quantity'];

  // if Name is empty, throw error because it is required
  if (!$I_Name) {
    $errors[] = 'Please Enter Item Name';
  }
  if (!$Expiry) {
    $errors[] = 'Please Enter Expiry';
  }
  if (!$I_Quantity) {
    $errors[] = 'Please Enter Quantity';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {
    // CALL updateEvacuee('EVAC-0021', 'Hello', 'Hello', 'Hello', 'M', '2005-12-25', '09999999999', 'HHOLD-0005', 'Evacuated');
    // CALL updateEvacuee(:Evacuee_ID, :First_Name, :Middle_Name, :Last_Name, :Sex, :Birthday, :Contact_No, :Household_ID, :Evacuation_Status)
    // UPDATE evacuee SET Evacuee_ID = :Evacuee_ID, 
    //                             First_Name = :First_Name, 
    //                             Middle_Name = :Middle_Name,
    //                             Last_Name = :Last_Name,
    //                             Sex = :Sex,
    //                             Birthday = :Birthday,
    //                             Contact_No = :Contact_No,
    //                             Household_ID = :Household_ID,
    //                             Evacuation_Status = :Evacuation_Status WHERE Evacuee_ID = :Evacuee_ID
    $statement = $pdo->prepare("CALL updateItem(:Item_ID, :I_Name, :Expiry, :I_Quantity)");
    $statement->bindValue(':Item_ID', $Item_ID);
    $statement->bindValue(':I_Name', $I_Name);
    $statement->bindValue(':Expiry', $Expiry);
    $statement->bindValue(':I_Quantity', $I_Quantity);
    $statement->execute();

    // redirect user after creating
    header('Location: inventory.php');
  }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ECMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Icons+Sharp"
      rel="stylesheet">
   <link rel="stylesheet" href="style.css">
</head>
<body>


            <div class="add-evacuees">
                <h1>Update Item <?php echo $I_Name?></h1>
                <!-- $statement->bindValue(':Item_ID', $Item_ID);
                $statement->bindValue(':I_Name', $I_Name);
                $statement->bindValue(':Expiry', $Expiry);
                $statement->bindValue(':I_Quantity', $I_Quantity); -->
                <form action="" method="post" enctype="multipart/form-data">
                <div class="add-evacuees-form">
                    <div class="add-evacuees-row-1">
                        <div class="I_Name">
                        <input type="text" name="I_Name" class="text-box" placeholder="Enter Item Name" value="<?php echo $I_Name ?>">
                        <h3 class="text-muted">First Name</h3>
                        </div>

                        <div>
                            <input type="date" name="Expiry" class="text-box" value="<?php echo $Expiry ?>">
                            <h3 class="text-muted">Expiry</h3>
                        </div>
                    </div>
                    <div class="add-evacuees-row-2">
                        <div>
                            <input type="number" name="I_Quantity" class="text-box" placeholder="Enter Quantity" value="<?php echo $I_Quantity ?>">
                            <h3 class="text-muted">Item_Quantity</h3>
                        </div>
                        
                    </div>
                    <div class="add-evacuees-row-3">
                    </div>
                    <br>
                        <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                        <a href="inventory.php">Back</a>
                    </div>
                </form>
                </div>
            </div>
    

    

    <script>
    const sideMenu = document.querySelector("aside");
    const menuBtn = document.querySelector("#menu-btn");
    const closeBtn = document.querySelector("#close-btn");
    const themeToggler = document.querySelector(".theme-toggler");


    // open sidebar
    menuBtn.addEventListener('click', () =>{
        sideMenu.style.display = 'block';
    })

    // close sidebar
    closeBtn.addEventListener('click', () =>{
        sideMenu.style.display = 'none';
    })

    // change theme
    themeToggler.addEventListener('click', () =>{
        document.body.classList.toggle('dark-theme-variables');

        themeToggler.querySelector('span:nth-child(1)').classList.toggle('active');
        themeToggler.querySelector('span:nth-child(2)').classList.toggle('active');
    })

</script>
</body>
</html>