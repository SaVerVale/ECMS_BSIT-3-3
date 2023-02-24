<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');
// require_once "household_add.php";

// Create Evacuee
// solution when FirstName, etc is empty
$First_Name = '';
$Middle_Name = '';
$Last_Name = '';
$Sex = '';
$Birthday = '';
$Contact_No = '';
$Household_ID = '';

// Create Household
// solution when FirstName, etc is empty
$Address = '';
$Family_Head = '';
$Room_ID = '';
$Date_Evacuated = '';

// search function for evacuee
$search = $_GET['search'] ?? '';
if ($search) {
  $statement = $pdo->prepare('call searchEvacuee(:First_Name)');
  $statement->bindValue(':First_Name', "%$search%");
  
} else{
  $statement = $pdo->prepare('CALL viewEvacueeJoinHousehold');
}

$statement2 = $pdo->prepare('CALL viewHousehold');
$statement2->execute();
$statement->closeCursor();
$statement->execute();
$evacuee = $statement->fetchAll(PDO::FETCH_ASSOC);
$household = $statement2->fetchAll(PDO::FETCH_ASSOC);
$statement2->closeCursor();

$sort = $_GET['sort'] ?? '';
if ($sort) {
  $statement4 = $pdo->prepare('CALL viewEvacueeJoinHouseholdSortBy(:Field_Name)');
  $statement4->bindValue(':Field_Name', "$sort");
  $statement->closeCursor();
  $statement4->execute();
  $evacuee = $statement4->fetchAll(PDO::FETCH_ASSOC);
  $statement4->closeCursor();
}

// if FirstName is empty, throw error because it is required
$errors = [];
$errors2 = [];

$statement5 = $pdo->prepare('CALL viewRoom');
$statement5->execute();
$rooms = $statement5->fetchAll(PDO::FETCH_ASSOC);
$statement5->closeCursor();
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
            <div class="top">
                <div class ="logo">
                    <img src="assets/logo.png">
                    <h2>ECMS</h2>
                </div>
                <div class="close" id="close-btn">
                    <span class="material-icons-sharp">close</span>
                </div>
            </div>

            <div class ="sidebar">
                <a href="index.php" class="btn-dashboard">
                    <span class="material-icons-sharp">grid_view</span>
                    <h3>Dashboard</h3>
                </a>
                <a href="center.php" class = "btn-center">
                    <span class="material-icons-sharp">apartment</span>
                    <h3>Center</h3>
                </a>
                <a href="#" class="btn-evacuees active">
                    <span class="material-icons-sharp">group</span>
                    <h3>Evacuees</h3>
                </a>
                <a href="volunteers.php" class="btn-volunteers">
                    <span class="material-icons-sharp">volunteer_activism</span>
                    <h3>Volunteers</h3>
                </a>
                <a href="inventory.php" class="btn-inventory">
                    <span class="material-icons-sharp">inventory</span>
                    <h3>Inventory</h3>
                </a>
                <a href="distribution.php" class="btn-distribution">
                    <span class="material-icons-sharp">local_shipping</span>
                    <h3>Distribution</h3>
                </a>
                <a href="analytics.php" class="btn-inventory">
                    <span class="material-icons-sharp">analytics</span>
                    <h3>Analytics</h3>
                </a>
                <a href="#" class="btn-settings">
                    <span class="material-icons-sharp">settings</span>
                    <h3>Settings</h3>
                </a>

                <a href = "session_logout.php" class="btn-logout">
                    <span class="material-icons-sharp">logout</span>
                    <h3>Logout</h3>
                </a>
            </div>
        </aside>
        <!===================== END OF ASIDE =======================!>

        <main>

            <h1>Evacuee Manager</h1>
            

            <!-- Start of household -->
            <div class="recent-updates">
                <h2>Household Information</h2>
                <div class="recent-update">
                <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Number of Members</th>
                        <th scope="col">Address</th>
                        <th scope="col">Family_Head</th>
                        <!-- <th scope="col">Contact_No</th> -->
                        <th scope="col">Room_ID</th>
                        <th scope="col">Date_Evacuated</th>
                        <th scope="col">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($household as $j => $hh) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $hh['Household_ID'] ?></td>
                        <td><?php echo $hh['Number_of_Members'];?></td>
                        <td><?php echo $hh['Address'] ?></td>
                        <td><?php echo $hh['Family_Head'] ?></td>
                        <td><?php echo $hh['Room_ID'] ?></td>
                        <td><?php echo $hh['Date_Evacuated'] ?></td>

                        <td>
                            <!-- Edit button -->
                            <a href="household_update.php?Household_ID=<?php echo $hh['Household_ID'] ?>" id="sub" class="btn btn-primary">Edit</a>

                            
                            <!-- Delete button -->
                            <form style="display:inline-block" method="post" action="household_delete.php">
                            <input type="hidden" name="Household_ID" value="<?php echo $hh['Household_ID'] ?>">
                            <button type="submit">Delete</button>
                            
                            </form>
                        </td>

                        </tr>
                    <?php
                    endforeach;
                    ?>

                    </tbody>
                </table>
                </div>
                </div>
                <a href="#">Show All</a>
            <!-- End of Household -->
            </div>

            <div class="recent-updates">
                <h2 id="anchor">Evacuees' Information</h2>

                <div class="recent-update">
                
                    <div class="input-group mb-3">
                        <!-- search evacuee -->
                        <div>
                        <form>
                            <input type="text" class="form-control text-box" placeholder="Search Name" 
                                    name="search" value="<?php echo $search ?>" style="float: left;">
                            <!-- <div class="input-group-append"> -->
                            <!-- <a href="#anchor"> -->
                                <button class="btn btn-outline-secondary" type="submit" onclick="window.location.href ='#anchor';" style="float: left;">Search</button>
                        <!-- </a> -->
                        </form>
                        </div>
                        <div>
                        <form>
                        <button class="btn btn-outline-secondary" type="submit" style="float: right;" onclick="window.location.href ='#anchor';">Sort</button>
                        <select name="sort" value="<?php echo $sort ?>"  style="float: right;">
                                    <option value="Evacuee_ID" disabled selected value>Choose Sort by</option>
                                    <option value="Evacuation_Status" selected="Evacuation_Status">Evacuation_Status</option>
                                    <option value="Room_Id">Room_Id</option>
                                    <option value="Household_ID">Household_ID</option> 
                                    <option value="Sex">Sex</option> 
                                    <option value="Full_Name">Full_Name</option> 
                                    <option value="Evacuee_ID">Evacuee_ID</option> 
                                    
                                </select>
                        </form>
                        </div>
                        <!-- </div> -->
                        <!-- End search evacuee -->
                    </div>
                    <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Full Name</th>
                        <th scope="col">Sex</th>
                        <th scope="col">Age</th>
                        <th scope="col">Contact_No</th>
                        <th scope="col">Room ID</th>
                        <th scope="col">Household_ID</th>
                        <th scope="col">Status</th>
                        <th scope="col">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($evacuee as $i => $evacuee2) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $evacuee2['Evacuee_ID'] ?></td>
                        <td><?php echo $evacuee2['Full_Name'];?></td>
                        <td><?php echo $evacuee2['Sex'] ?></td>
                        <td><?php echo $evacuee2['Age'] ?></td>
                        <td><?php echo $evacuee2['Contact_No'] ?></td>
                        <td><?php echo $evacuee2['Room_ID'] ?></td>
                        <td><?php echo $evacuee2['Household_ID'] ?></td>
                        <td><?php echo $evacuee2['Evacuation_Status'] ?></td>

                        <td>
                            <!-- Edit button -->
                            <a href="evacuee_update.php?Evacuee_ID=<?php echo $evacuee2['Evacuee_ID'] ?>" id="sub" class="btn btn-primary">Edit</a>

                            
                            <!-- Delete button -->
                            <form style="display:inline-block" method="post" action="evacuee_delete.php">
                            <input type="hidden" name="Evacuee_ID" value="<?php echo $evacuee2['Evacuee_ID'] ?>">
                            <button type="submit">Delete</button>
                            
                            </form>
                        </td>

                        </tr>
                    <?php
                    endforeach;
                    ?>

                    </tbody>
                </table>
                </div>
                </div>
                <a href="#">Show All</a>
            </div>
        </main>
        <!  ------------------- END OF MAIN -----------------------  !>

        <div class="right">
            <div class="top">
                <button id="menu-btn">
                    <span class= "material-icons-sharp">menu</span>
                </button>
                <div class="theme-toggler">
                    <span class= "material-icons-sharp active">light_mode</span>
                    <span class= "material-icons-sharp">dark_mode</span>
                </div>
                <div class="profile">
                    <div class="info">
                        <p>Hey, <b>Daniel</b></p>
                        <small class="text-muted">Admin</small>
                    </div>
                    <div class="profile-photo">
                        <img src="assets/profile-1.jpg">
                    </div>
                </div>

            </div>
            <! ---------------- End of Top ---------------- !>
            <div class="recent-announcements">
                <h2>Add Evacuees</h2>
                <div class="announcements">
                    <!-- Display error -->
                    <?php if (!empty($errors)): ?>
                                <div class="alert alert-danger">
                                    <?php foreach ($errors as $error) :?>
                                    <div><?php echo $error ?></div>
                                    <?php endforeach; ?>
                                </div>
                                <?php endif ?>

                    <form action="evacuee_add.php" method="post" enctype="multipart/form-data">
                    <div class="add-evacuees-form">
                            <div class="firstname">
                                <input type="text" name="First_Name" class="text-box" placeholder="Enter First Name" value="<?php echo $First_Name ?>">
                                <h3 class="text-muted">First Name</h3><br>
                            </div>
    
                            <div class="middle_name">
                            <input type="text" name="Middle_Name" class="text-box" placeholder="Enter Middle Name" value="<?php echo $Middle_Name ?>">
                                <h3 class="text-muted">Middle Name</h3><br>
                            </div>
    
                            <div class="lastname">
                            <input type="text" name="Last_Name" class="text-box" placeholder="Enter Last Name" value="<?php echo $Last_Name ?>">
                                <h3 class="text-muted">Last Name</h3>
                            </div>

                        
                            
                            <div>
                                <select name="Sex" value="<?php echo $Sex ?>">
                                    <option value="M">Male</option>
                                    <option value="F">Female</option>
                                </select>
                                <h3 class="text-muted">Sex</h3>
                            </div>
                        <!-- Close row -->
                        
                            <div>
                                <input type="date" name="Birthday" class="text-box" value="<?php echo $Birthday ?>">
                                <h3 class="text-muted">Birthday</h3>
                            </div>

                            <div>
                            <input type="text" name="Contact_No" class="text-box" placeholder="Enter Contact Number" value="<?php echo $Contact_No ?>">
                                <h3 class="text-muted">Contact No</h3>
                            </div>
                        
                        <div class="add-evacuees-row-3">
                            <div class="household-field">
                                <select name="Household_ID" value="<?php echo $Household_ID ?>"><br>
                                <?php foreach ($household as $i => $rr) :?>
                                    <option value="<?php echo $rr['Household_ID'];?>"><?php echo $rr['Household_ID'] ?></option>
                                    <?php endforeach;?>
                                </select>
                                <h3 class="text-muted">Household</h3>
                            <!-- Close household-field -->
                            </div>
                            <!-- Buttons -->
                            <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                            <a href="evacuees.php">Clear</a>
                        <!-- close add-evacuees-row-3 -->
                        </div>
                    </div>
                    </form>
                <!-- Close Announcements -->
                </div>
            <!-- Close recent Announcements -->
            </div>
            <! ------------------ End of Add Evacuees ---------------- !>
            <! ---------------- End of Announcements ---------------- !>
            <div class="recent-announcements">
            <!-- CALL addHousehold('Dolores', NULL, 'RM-002', '2023-02-14'); -->
            
                                <!-- Display error -->
                                <?php if (!empty($errors)): ?>
                                <div class="alert alert-danger">
                                    <?php foreach ($errors as $error) :?>
                                    <div><?php echo $error ?></div>
                                    <?php endforeach; ?>
                                </div>
                                <?php endif ?>

            <form action="household_add.php" method="post" enctype="multipart/form-data">
                <h2>Add Household</h2>
                <div class="announcements">
                    <div class="add-household-form">
                            <div class="Address">
                                <input type="text" name="Address" class="text-box" placeholder="Enter Address" value="<?php echo $Address ?>">
                                <h3 class="text-muted">Address</h3>
                            </div>

                            <div class="Family_Head">
                                <!-- <input type="text" name="Family_Head" class="text-box" placeholder="Enter Family_Head" value="<?php //echo $Family_Head ?>"> -->
                                
                                <div class="input-group mb-3">
                                <select class="custom-select" id="inputGroupSelect02" name="Family_Head" value="<?php echo $Family_Head ?>">
                                    <option value="" selected>Default(None)</option>
                                    <?php foreach ($evacuee as $e => $ee) :?>
                                        <option value="<?php echo $ee['Evacuee_ID'];?>"><?php echo $ee['Evacuee_ID'].' ('.$ee['Full_Name'].')' ?></option>
                                    <?php endforeach;?>
                                </select>
                                <div class="input-group-append">
                                    <h3 class="text-muted">Family Head</h3>
                                </div>
                                </div>

                                <!-- <select name="Family_Head" value="<?php //echo $Family_Head ?>"><br>
                                <?php //foreach ($evacuee as $e => $ee) :?>
                                    <option value="<?php //echo $ee['Evacuee_ID'];?>"><?php //echo $ee['Evacuee_ID'].' ('.$ee['Full_Name'].')' ?></option>
                                    <?php //endforeach;?>
                                </select>
                                <h3 class="text-muted">Family Head</h3> -->
                            </div>

                            <div class="Room_ID-field">
                                <!-- <select name="Room_ID" value="<?php //echo $Room_ID ?>" ><br>
                                    <option value="RM-001">RM-001</option>
                                    <option value="RM-002">RM-002</option>
                                    <option value="RM-003">RM-003</option>
                                    <option value="RM-004">RM-004</option>
                                    <option value="RM-005">RM-005</option>
                                    <option value="RM-006">RM-006</option>
                                    <option value="RM-007">RM-007</option>
                                    <option value="RM-008">RM-008</option>
                                    <option value="RM-009">RM-009</option>
                                </select> -->
                                <select name="Room_ID" value="<?php echo $Room_ID ?>"><br>
                                <?php foreach ($rooms as $x => $rx) :?>
                                    <option value="<?php echo $rx['Room_ID'];?>"><?php echo $rx['Room_ID'] ?></option>
                                    <?php endforeach;?>
                                </select>
                                <h3 class="text-muted">Room ID</h3>
                            </div>

                            <div>
                                <input type="date" name="Date_Evacuated" class="text-box" value="<?php echo $Date_Evacuated ?>">
                                <h3 class="text-muted">Date Evacuated</h3>
                            </div>

                        <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                        <a href="evacuees.php">Clear</a>
                    </div>
            </form>
                </div> 
                <div class="modal" id="modal-create-head">
                    <div class="modal-header">
                        
                      <div class="title"><span class= "material-icons-sharp">person_add</span>
                        <h2>Create Head</h2>
                        <h3 class="text-muted" id="room-id-edit"> </h3>
                    </div>
                      <button data-close-button class="close-button"><span class="material-icons-sharp">close</span></button>
                    </div>
                    <div class="modal-body">
                        <div class="modal-body-input">
                            <input type="text" name="name" class="text-box" placeholder="First Name">
                            <h3 class="text-muted">First Name</h3>

                            <input type="text" name="name" class="text-box" placeholder="Middle Name">
                            <h3 class="text-muted">Middle Name</h3>

                            <input type="text" name="name" class="text-box" placeholder="Last Name">
                            <h3 class="text-muted">Last Name</h3>

                            <input type="number" name="age" class="text-box" placeholder="Age">
                            <h3 class="text-muted">Age</h3>

                            <input type="text" name="sex" class="text-box" placeholder="Sex">
                            <h3 class="text-muted">Sex</h3>

                            <input type="date" name="birthday" class="text-box">
                            <h3 class="text-muted">Birthday</h3>

                            <input type="text" name="contact" class="text-box" placeholder="Contact">
                            <h3 class="text-muted">Contact No</h3>

                            <input type="text" name="address" class="text-box" placeholder="Address">
                            <h3 class="text-muted">Address</h3>

                            <div class="modal-buttons">
                                <button class="submit">Submit</button>
                                <button class="cancel">Cancel</button>
                            </div>
                        </div>
                    </div>
                    
                    </div>
                    <div id="overlay"></div>
                </div>   
            </div>
        </div>

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