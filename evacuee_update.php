<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$Evacuee_ID = $_GET['Evacuee_ID'] ?? null;
if (!$Evacuee_ID) {
  header('Location: evacuees.php');
  exit;
}

$statement = $pdo->prepare('SELECT * FROM evacuee WHERE Evacuee_ID = :Evacuee_ID');
$statement->bindValue(':Evacuee_ID', $Evacuee_ID);
$statement->execute();
$evacuee2 = $statement->fetch(PDO::FETCH_ASSOC);

$statement2 = $pdo->prepare('CALL viewHousehold');
$statement2->execute();
$household = $statement2->fetchAll(PDO::FETCH_ASSOC);
$statement2->closeCursor();

// if Name is empty, throw error because it is required
$errors = [];

// solution when Name etch is empty
$Evacuee_ID = $evacuee2['Evacuee_ID'];
$First_Name = $evacuee2['First_Name'];
$Middle_Name = $evacuee2['Middle_Name'];
$Last_Name = $evacuee2['Last_Name'];
$Sex = $evacuee2['Sex'];
$Birthday = $evacuee2['Birthday'];
$Contact_No = $evacuee2['Contact_No'];
$Evacuation_Status = $evacuee2['Evacuation_Status'];
$Household_ID = $evacuee2['Household_ID'];

// show request method
// echo $_SERVER['REQUEST_METHOD']. '<br>';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $Evacuee_ID = $_POST['Evacuee_ID'];
  $First_Name = $_POST['First_Name'];
  $Last_Name = $_POST['Last_Name'];
  $Sex = $_POST['Sex'];
  $Birthday = $_POST['Birthday'];
  $Contact_No = $_POST['Contact_No'];
  $Evacuation_Status = $_POST['Evacuation_Status'];
  $Household_ID = $_POST['Household_ID'];

  // if Name is empty, throw error because it is required
  if (!$First_Name) {
    $errors[] = 'Please Enter First Name';
  }
  if (!$Last_Name) {
    $errors[] = 'Please Enter Last Name';
  }
  if (!$Sex) {
    $errors[] = 'Please Enter Gender';
  }
  if (!$Birthday) {
    $errors[] = 'Please Enter Birthday';
  }
  if (!$Contact_No) {
    $errors[] = 'Please Enter Contact No';
  }
  if (!$Evacuation_Status) {
    $errors[] = 'Please Enter Evacuation Status';
  }
  if (!$Household_ID) {
    $errors[] = 'Please Enter Household_ID';
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
    $statement = $pdo->prepare("CALL updateEvacuee(:Evacuee_ID, :First_Name, :Middle_Name, :Last_Name, :Sex, :Birthday, :Contact_No, :Household_ID, :Evacuation_Status)");
    $statement->bindValue(':Evacuee_ID', $Evacuee_ID);
    $statement->bindValue(':First_Name', $First_Name);
    $statement->bindValue(':Middle_Name', $Middle_Name);
    $statement->bindValue(':Last_Name', $Last_Name);
    $statement->bindValue(':Sex', $Sex);
    $statement->bindValue(':Birthday', $Birthday);
    $statement->bindValue(':Contact_No', $Contact_No);
    $statement->bindValue(':Household_ID', $Household_ID);
    $statement->bindValue(':Evacuation_Status', $Evacuation_Status);
    $statement->execute();

    // redirect user after creating
    header('Location: evacuees.php');
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
    <div class="container">
        <aside>

        </aside>
        <!===================== END OF ASIDE =======================!>

        <main>


            <div class="add-evacuees">
                <h1>Update Evacuee <?php echo $First_Name. ' '. $Middle_Name. ' '. $Last_Name?></h1>
                <form action="" method="post" enctype="multipart/form-data">
                <div class="add-evacuees-form">
                    <div class="add-evacuees-row-1">
                        <div class="firstname">
                        <input type="text" name="First_Name" class="text-box" placeholder="Enter First Name" value="<?php echo $First_Name ?>">
                        <h3 class="text-muted">First Name</h3>
                        </div>

                        <div class="middlename">
                        <input type="text" name="Middle_Name" class="text-box" placeholder="Enter Middle Name" value="<?php echo $Middle_Name ?>">
                        <h3 class="text-muted">Middle Name</h3>
                        </div>

                        <div class="lastname">
                        <input type="text" name="Last_Name" class="text-box" placeholder="Enter Last Name" value="<?php echo $Last_Name ?>">
                        <h3 class="text-muted">Last Name</h3>
                        </div>
                    </div>
                    <div class="add-evacuees-row-2">
                        <div>
                        <input type="date" name="Birthday" class="text-box" value="<?php echo $Birthday ?>">
                        <h3 class="text-muted">Birthday</h3>
                        </div>
                        
                        <div>
                        <select name="Sex" value="<?php echo $Sex ?>">
                        <option value="<?php echo $Sex ?>" selected="<?php echo $Sex ?>"><?php echo $Sex ?></option>
                            <option value="M">Male</option>
                            <option value="F">Female</option>
                        </select>
                        <h3 class="text-muted">Sex</h3>
                        </div>
                        <div>
                        <input type="text" name="Contact_No" class="text-box" placeholder="Enter Contact" value="<?php echo $Contact_No ?>">
                        <h3 class="text-muted">Contact No</h3>
                        </div>
                        <div class="household-field">
                        <select name="Household_ID" value="<?php echo $Household_ID ?>"><br>
                            <option value="<?php echo $Household_ID ?>" selected="<?php echo $Household_ID ?>"><?php echo $Household_ID ?></option>
                            <?php foreach ($household as $i => $rr) :?>
                                    <option value="<?php echo $rr['Household_ID'];?>"><?php echo $rr['Household_ID'] ?></option>
                                    <?php endforeach;?>
                        </select>
                        <h3 class="text-muted">Household ID</h3>
                        </div>
                    </div>
                    <div class="add-evacuees-row-3">
                        <div class="household-field">
                            <select name="Evacuation_Status" value="<?php echo $Evacuation_Status ?>"><br>
                                <option value="Evacuated">Evacuated</option>
                                <option value="DEPARTED">DEPARTED</option>
                                <option value="DIED">DIED</option>
                            </select>
                            <h3 class="text-muted">Evacuation Status</h3>
                        </div></div>
                    <br>
                        <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                        <a href="evacuees.php">Back</a>
                    </div>
                </form>
                </div>
            </div>
        </main>
        <!  ------------------- END OF MAIN -----------------------  !>



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