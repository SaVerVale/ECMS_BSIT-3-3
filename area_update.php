<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
/** @var $conn \PDO */
require_once "database.php";

$Area_ID = $_GET['Area_ID'] ?? null;
if (!$Area_ID) {
  header('Location: center.php');
  exit;
}

$statement = $pdo->prepare('SELECT * FROM area WHERE Area_ID = :Area_ID;');
$statement->bindValue(':Area_ID', $Area_ID);
$statement->execute();
$croom = $statement->fetch(PDO::FETCH_ASSOC);

// if Name is empty, throw error because it is required
$errors = [];

// solution when Name etch is empty
$Area_ID = $croom['Area_ID'];
$A_Name = $croom['A_Name'];
$Area_ID = $croom['Area_ID'];
$Center_ID = $croom['Center_ID'];

// show request method
// echo $_SERVER['REQUEST_METHOD']. '<br>';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $Area_ID = $_POST['Area_ID'];
  $A_Name = $_POST['A_Name'];
  $Area_ID = $_POST['Area_ID'];
  $Center_ID = $_POST['Center_ID'];

  // if Name is empty, throw error because it is required
  if (!$A_Name) {
    $errors[] = 'Please Enter A_Name';
  }
  if (!$Area_ID) {
    $errors[] = 'Please Enter Area_ID';
  }
  if (!$Center_ID) {
    $errors[] = 'Please Enter Center_ID';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {
    $statement = $pdo->prepare("CALL updateArea(:Area_ID, :A_Name, :Center_ID)");
        $statement->bindValue(':Area_ID', $Area_ID);
        $statement->bindValue(':A_Name', $A_Name);
        $statement->bindValue(':Center_ID', $Center_ID);
    $statement->execute();

    // redirect user after creating
    header('Location: center.php');
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
                <h1>Update Room <?php echo $A_Name?></h1>
                <form action="" method="post" enctype="multipart/form-data">
                <div class="add-evacuees-form">

                    <?php if (!empty($errors)) : ?>
                        <!-- Display error -->
                        <div class="alert alert-danger">
                        <?php foreach ($errors as $error) : ?>
                            <div><?php echo $error ?></div>
                        <?php endforeach; ?>
                        </div>
                    <?php endif ?>
                    
                    <div class="add-evacuees-row-1">

                                <div class="Area_ID">
                                <input type="text" name="Area_ID" class="text-box" value="<?php echo $Area_ID ?>" readonly>
                                <h3 class="text-muted">Room ID</h3>
                                </div>
                        <div class="firstname">
                        <input type="text" name="A_Name" class="text-box" placeholder="Enter Room Name" value="<?php echo $A_Name ?>">
                        <h3 class="text-muted">Room Name</h3>
                        </div>
                    </div>
                    <div class="add-evacuees-row-2">
                        <div class="Center_ID">
                                <input type="text" name="Center_ID" class="text-box" value="<?php echo $Center_ID ?>" readonly>
                                <h3 class="text-muted">Center ID</h3>
                        </div>
                        
                    
                    </div>
                    <div class="add-evacuees-row-3"></div>
                    <br>
                        <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                        <a href="center.php">Back</a>
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