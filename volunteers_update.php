<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$V_ID = $_GET['V_ID'] ?? null;
if (!$V_ID) {
  header('Location: volunteers.php');
  exit;
}

$statement = $pdo->prepare('SELECT * FROM volunteers WHERE V_ID = :V_ID');
$statement->bindValue(':V_ID', $V_ID);
$statement->execute();
$vltr = $statement->fetch(PDO::FETCH_ASSOC);

// if Name is empty, throw error because it is required
$errors = [];

// solution when Name etch is empty
$V_ID = $vltr['V_ID'];
$V_Name = $vltr['V_Name'];
$V_Birthday = $vltr['V_Birthday'];
$V_Sex = $vltr['V_Sex'];
$V_Group = $vltr['V_Group'];

// show request method
// echo $_SERVER['REQUEST_METHOD']. '<br>';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $V_ID = $_POST['V_ID'];
  $V_Name = $_POST['V_Name'];
  $V_Birthday = $_POST['V_Birthday'];
  $V_Sex = $_POST['V_Sex'];
  $V_Group = $_POST['V_Group'];

  // if Name is empty, throw error because it is required
  if (!$V_Name) {
    $errors[] = 'Please Enter Volunteer Name';
  }
  if (!$V_Birthday) {
    $errors[] = 'Please Enter Birthday';
  }
  if (!$V_Sex) {
    $errors[] = 'Please Enter Gender';
  }
  if (!$V_Group) {
    $errors[] = 'Please Enter V_Group';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {
    $statement = $pdo->prepare("CALL updateVolunteer(:V_ID, :V_Name, :V_Birthday, :V_Sex, :V_Group)");
    $statement->bindValue(':V_ID', $V_ID);
    $statement->bindValue(':V_Name', $V_Name);
    $statement->bindValue(':V_Birthday', $V_Birthday);
    $statement->bindValue(':V_Sex', $V_Sex);
    $statement->bindValue(':V_Group', $V_Group);
    $statement->execute();

    // redirect user after creating
    header('Location: volunteers.php');
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


        <!===================== END OF ASIDE =======================!>


            <div class="add-evacuees">
                <h1>Update Volunteer <?php echo $V_Name?></h1>
                <form action="" method="post" enctype="multipart/form-data">
                <div class="add-evacuees-form">
                    <div class="add-evacuees-row-1">
                        <div class="V_Name">
                        <input type="text" name="V_Name" class="text-box" placeholder="Enter Volunteer Name" value="<?php echo $V_Name ?>">
                        <h3 class="text-muted">Volunteer Name</h3>
                        </div>
                    </div>

                    <div class="add-evacuees-row-2">
                        <div>
                        <input type="date" name="V_Birthday" class="text-box" value="<?php echo $V_Birthday ?>">
                        <h3 class="text-muted">V_Birthday</h3>
                        </div>
                        
                        <div>
                        <select name="V_Sex" value="<?php echo $V_Sex ?>">
                        <option value="<?php echo $V_Sex ?>" selected="<?php echo $V_Sex ?>"><?php echo $V_Sex ?></option>
                            <option value="M">Male</option>
                            <option value="F">Female</option>
                        </select>
                        <h3 class="text-muted">Sex</h3>
                        </div>
                        <div class="household-field">
                            <select name="V_Group" value="<?php echo $V_Group ?>"><br>
                                <option value="<?php echo $V_Group ?>" selected="<?php echo $V_Group ?>"><?php echo $V_Group ?></option>
                                <option value="VG-001">VG-001</option>
                                <option value="VG-002">VG-002</option>
                                <option value="VG-003">VG-003</option>
                                <option value="VG-004">VG-004</option>
                                <option value="VG-005">VG-005</option>
                            </select>
                            <h3 class="text-muted">V_Group</h3>
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
                        <a href="volunteers.php">Back</a>
                    </div>
                </form>
                </div>
            </div>

        <!  ------------------- END OF MAIN -----------------------  !>



   

    

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