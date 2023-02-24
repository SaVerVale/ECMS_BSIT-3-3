<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$V_Group = $_GET['V_Group'] ?? null;
if (!$V_Group) {
  header('Location: volunteers.php');
  exit;
}

$statement = $pdo->prepare('SELECT * FROM volunteer_group WHERE V_Group = :V_Group');
$statement->bindValue(':V_Group', $V_Group);
$statement->execute();
$vltr = $statement->fetch(PDO::FETCH_ASSOC);

// if Name is empty, throw error because it is required
$errors = [];

// solution when Name etch is empty
$V_Group = $vltr['V_Group'];
$G_Name = $vltr['G_Name'];
$Area_ID = $vltr['Area_ID'];

// show request method
// echo $_SERVER['REQUEST_METHOD']. '<br>';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $V_Group = $_POST['V_Group'];
  $G_Name = $_POST['G_Name'];
  $Area_ID = $_POST['Area_ID'];

  // if Name is empty, throw error because it is required
  if (!$G_Name) {
    $errors[] = 'Please Enter Volunteer Name';
  }
  if (!$Area_ID) {
    $errors[] = 'Please Enter Birthday';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {
    $statement = $pdo->prepare("CALL updateVolunteerGroup(:V_Group, :G_Name, :Area_ID)");
    $statement->bindValue(':V_Group', $V_Group);
    $statement->bindValue(':G_Name', $G_Name);
    $statement->bindValue(':Area_ID', $Area_ID);
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



            <div class="add-evacuees">
                <h1>Update Volunteer Group <?php echo $V_Group?></h1>
                <form action="" method="post" enctype="multipart/form-data">
                <div class="add-evacuees-form">
                    <div class="add-evacuees-row-1">
                        <div class="G_Name">
                        <input type="text" name="G_Name" class="text-box" placeholder="Enter Volunteer Group Name" value="<?php echo $G_Name ?>">
                        <h3 class="text-muted">Volunteer Group Name</h3><br>
                        </div>
                    </div>

                    <div class="add-evacuees-row-2">
                        <div class="household-field">
                            <select name="Area_ID" value="<?php echo $Area_ID ?>"><br>
                                <option value="<?php echo $Area_ID ?>" selected="<?php echo $Area_ID ?>"><?php echo $Area_ID ?></option>
                                <option value="A-0001">A-0001</option>
                                <option value="A-0002">A-0002</option>
                                <option value="A-0003">A-0003</option>
                                <option value="A-0004">A-0004</option>
                                <option value="A-0005">A-0005</option>
                            </select>
                            <h3 class="text-muted">Area_ID</h3>
                        </div>
                    </div>

                    <br>
                        <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                        <a href="volunteers.php">Back</a>
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