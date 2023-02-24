<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$Household_ID = $_GET['Household_ID'] ?? null;
if (!$Household_ID) {
  header('Location: evacuees.php');
  exit;
}

$statement = $pdo->prepare('SELECT * FROM household WHERE Household_ID = :Household_ID');
$statement->bindValue(':Household_ID', $Household_ID);
$statement->execute();
$household2 = $statement->fetch(PDO::FETCH_ASSOC);
$statement->closeCursor();

$statement2 = $pdo->prepare('CALL viewEvacueeJoinHousehold');
$statement2->execute();
$evacuee = $statement2->fetchAll(PDO::FETCH_ASSOC);
$statement2->closeCursor();

$statement3 = $pdo->prepare('CALL viewRoom');
$statement3->execute();
$rooms = $statement3->fetchAll(PDO::FETCH_ASSOC);
$statement3->closeCursor();

// if Name is empty, throw error because it is required
$errors = [];
$isDeparted = '';
// solution when Name etch is empty
$Household_ID = $household2['Household_ID'];
$Address = $household2['Address'];
$Family_Head = $household2['Family_Head'];
$Room_ID = $household2['Room_ID'];
$Date_Evacuated = $household2['Date_Evacuated'];
// $isDeparted = $household2['isDeparted'];

// show request method
// echo $_SERVER['REQUEST_METHOD']. '<br>';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $Household_ID = $_POST['Household_ID'];
  $Address = $_POST['Address'];
  $Family_Head = $_POST['Family_Head'];
  $Room_ID = $_POST['Room_ID'];
  $Date_Evacuated = $_POST['Date_Evacuated'];
  $isDeparted = $_POST['isDeparted'];

  // if Name is empty, throw error because it is required
  if (!$Family_Head) {
    $errors[] = 'Please Enter Family_Head';
  }
  if (!$Room_ID) {
    $errors[] = 'Please Enter Room_ID';
  }
  if (!$Date_Evacuated) {
    $errors[] = 'Please Enter Date_Evacuated';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {
            $statement = $pdo->prepare("CALL updateHousehold(:Household_ID, :Address, :Family_Head, :Room_ID, :Date_Evacuated, :isDeparted)");

    $statement->bindValue(':Household_ID', $Household_ID);
    $statement->bindValue(':Address', $Address);
    $statement->bindValue(':Family_Head', $Family_Head);
    $statement->bindValue(':Room_ID', $Room_ID);
    $statement->bindValue(':Date_Evacuated', $Date_Evacuated);
    $statement->bindValue(':isDeparted', $isDeparted);
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
                                <!-- // $Address = '';
                                // $Family_Head = '';
                                // $Room_ID = '';
                                // $Date_Evacuated = '';
                                // Household_ID -->
                <h1>Update Household <?php echo $Household_ID?></h1>
                <form action="" method="post" enctype="multipart/form-data">
                <div class="add-evacuees-form">
                    <div class="add-evacuees-row-1">
                        <div class="Address">
                            <input type="text" name="Address" class="text-box" placeholder="Enter Address" value="<?php echo $Address ?>">
                            <h3 class="text-muted">Address</h3>
                        </div>

                        <div class="Family_Head">
                        <!-- <input type="text" name="Family_Head" class="text-box" placeholder="Enter Family_Head" value="<?php //echo $Family_Head ?>"> -->
                        <select class="custom-select" id="inputGroupSelect02" name="Family_Head" value="<?php echo $Family_Head ?>">
                            <option value="<?php echo $Family_Head ?>" selected="<?php echo $Family_Head ?>" selected><?php echo $Family_Head ?></option>
                            <option value="">Default(None)</option>
                                    <?php foreach ($evacuee as $e => $ee) :?>
                                        <option value="<?php echo $ee['Evacuee_ID'];?>"><?php echo $ee['Evacuee_ID'].' ('.$ee['Full_Name'].')' ?></option>
                                    <?php endforeach;?>
                                </select>
                        <h3 class="text-muted">Family_Head</h3>
                        </div>

                        <div class="Room_ID">
                            <select name="Room_ID" value="<?php echo $Room_ID ?>"><br>
                                <option value="<?php echo $Room_ID ?>" selected="<?php echo $Room_ID ?>"><?php echo $Room_ID ?></option>
                                <?php foreach ($rooms as $i => $rr) :?>
                                    <option value="<?php echo $rr['Room_ID'];?>"><?php echo $rr['Room_ID'] ?></option>
                                    <?php endforeach;?>
                            </select>
                            <h3 class="text-muted">Room ID</h3>
                        </div>
                    </div>
                    <div class="add-evacuees-row-2">
                        <div>
                            <input type="date" name="Date_Evacuated" class="text-box" value="<?php echo $Date_Evacuated ?>">
                            <h3 class="text-muted">Date_Evacuated</h3>
                        </div>

                        
                    </div>
                    <br>
                    <div class="add-evacuees-row-3">
                    
                    <div class="Family_Head">
                        <!-- <input type="text" name="Family_Head" class="text-box" placeholder="Enter Family_Head" value="<?php //echo $Family_Head ?>"> -->
                        <select class="custom-select" id="inputGroupSelect02" name="isDeparted" value="<?php echo $isDeparted ?>">
                            <option value="0" selected>Default(No)</option>
                            <option value="1">Yes</option>

                                </select>
                        <h3 class="text-muted">Depart All?</h3>
                        </div>
                    </div>
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