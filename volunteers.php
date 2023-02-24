<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$search = $_GET['search'] ?? '';
if ($search) {
  $statement = $pdo->prepare('CALL searchVolunteer(:In_Text)');
  $statement->bindValue(':In_Text', "$search");
  $statement->execute();
  $vltr = $statement->fetchAll(PDO::FETCH_ASSOC);
  $statement->closeCursor();
} else{
    $statement = $pdo->prepare('CALL viewVolunteers');
    $statement->execute();
    $vltr = $statement->fetchAll(PDO::FETCH_ASSOC);
    $statement->closeCursor();
}

$sort = $_GET['sort'] ?? '';
if ($sort) {
  $statement4 = $pdo->prepare('CALL viewVolunteersSortBy(:Field_Name)');
  $statement4->bindValue(':Field_Name', "$sort");
  $statement4->closeCursor();
  $statement4->execute();
  $vltr = $statement4->fetchAll(PDO::FETCH_ASSOC);
  $statement4->closeCursor();
} 
// else{
//     $statement = $pdo->prepare('CALL viewVolunteers');
//     $statement->execute();
//     $vltr = $statement->fetchAll(PDO::FETCH_ASSOC);
//     $statement->closeCursor();
// }

$statement2 = $pdo->prepare('CALL viewVolunteerGroup');
$statement2->execute();
$vg = $statement2->fetchAll(PDO::FETCH_ASSOC);
$statement2->closeCursor();
// Create Volunteer
$V_Name = '';
$V_Birthday = '';
$V_Sex = '';
$V_Group = '';

// Create Volunteer Group
$G_Name = '';
$Area_ID = '';

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
                <a href="evacuees.php" class="btn-evacuees">
                    <span class="material-icons-sharp">group</span>
                    <h3>Evacuees</h3>
                </a>
                <a href="#" class="btn-volunteers active">
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
            <h1>Volunteer Manager</h1>

            <div class="recent-updates">
                <h2>Volunteers</h2>
                <div class="recent-update">
                
                <div class="input-group mb-3">

                        <form>
                            <input type="text" class="form-control text-box" 
                                    placeholder="Search Volunteer" 
                                    name="search" value="<?php echo $search ?>" style="float: left;">
                            <!-- <div class="input-group-append"> -->
                            <button class="btn btn-outline-secondary" type="submit" style="float: left;">Search</button>
                        </form>

                        <!-- search evacuee -->
                        <form>
                        <button class="btn btn-outline-secondary" type="submit" style="float: right;">Sort</button>
                        <select name="sort" value="<?php echo $sort ?>"  style="float: right;">
                                    <option value="V_ID" disabled selected value>Choose Sort by</option>
                                    <option value="V_ID" selected="V_ID">V_ID</option>
                                    <option value="V_Age">V_Age</option>
                                    <option value="V_Group">V_Group</option> 
                                    <option value="V_Sex">V_Sex</option> 
                                    <option value="V_Name">V_Name</option>  
                                </select>
                        </form>
                        <!-- </div> -->
                        <!-- End search evacuee -->
                    </div>
                    <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">V_ID</th>
                        <th scope="col">V_Name</th>
                        <th scope="col">V_Birthday</th>
                        <th scope="col">V_Age</th>
                        <th scope="col">V_Sex</th>
                        <th scope="col">V_Group</th>
                        <th scope="col">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($vltr as $i => $vv) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $vv['V_ID'] ?></td>
                        <td><?php echo $vv['V_Name'];?></td>
                        <td><?php echo $vv['V_Birthday'] ?></td>
                        <td><?php echo $vv['V_Age'] ?></td>
                        <td><?php echo $vv['V_Sex'] ?></td>
                        <td><?php echo $vv['V_Group'] ?></td>

                        <td>
                            <!-- Edit button -->
                            <a href="volunteers_update.php?V_ID=<?php echo $vv['V_ID'] ?>" id="sub" class="btn btn-primary">Edit</a>

                            
                            <!-- Delete button -->
                            <form style="display:inline-block" method="post" action="volunteers_delete.php">
                            <input type="hidden" name="V_ID" value="<?php echo $vv['V_ID'] ?>">
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
            </div>

            <!-- End of volunteers -->

            <!-- Start of Volunteer Group -->
            <div class="recent-updates">
                <h2>Volunteer Groups</h2>
                <div class="recent-update">
                <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">V_Group</th>
                        <th scope="col">G_Name</th>
                        <th scope="col">Area_ID</th>
                        <th scope="col">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($vg as $j => $vg2) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $vg2['V_Group'] ?></td>
                        <td><?php echo $vg2['G_Name'];?></td>
                        <td><?php echo $vg2['Area_ID'] ?></td>

                        <td>
                            <!-- Edit button -->
                            <a href="volunteergroup_update.php?V_Group=<?php echo $vg2['V_Group'] ?>" id="sub" class="btn btn-primary">Edit</a>

                            
                            <!-- Delete button -->
                            <form style="display:inline-block" method="post" action="volunteergroup_delete.php">
                            <input type="hidden" name="V_Group" value="<?php echo $vg2['V_Group'] ?>">
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
            </div>

            <!-- End of Volunteer Group -->

            


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
            <!-- Start add volunteer -->
            <div class="recent-announcements">
                <h2>Add Volunteers</h2>
                <div class="announcements">
                    <form action="volunteers_add.php" method="post" enctype="multipart/form-data">
                    <div class="add-evacuees-form">
                            <div class="V_Name">
                                <input type="text" name="V_Name" class="text-box" placeholder="Enter Volunteer Name" value="<?php echo $V_Name ?>">
                                <h3 class="text-muted">Volunteer Name</h3><br>
                            </div>

                            <div>
                                <input type="date" name="V_Birthday" class="text-box" value="<?php echo $V_Birthday ?>">
                                <h3 class="text-muted">Birthday</h3><br>
                            </div>

                            <div>
                                <select name="V_Sex" value="<?php echo $V_Sex ?>">
                                    <option value="M">Male</option>
                                    <option value="F">Female</option>
                                </select>
                                <h3 class="text-muted">V_Sex</h3><br>
                            </div>

                            <div class="V_Group">
                                <!-- <select name="V_Group" value="<?php //echo $V_Group ?>"><br>
                                    <option value="VG-001">VG-001</option>
                                    <option value="VG-002">VG-002</option>
                                    <option value="VG-003">VG-003</option>
                                    <option value="VG-004">VG-004</option>
                                    <option value="VG-005">VG-005</option>
                                </select> -->
                                <select name="V_Group" value="<?php echo $V_Group ?>"><br>
                                <?php foreach ($vg as $v => $vv) :?>
                                    <option value="<?php echo $vv['V_Group'];?>"><?php echo $vv['V_Group']." (".$vv['G_Name'].")" ?></option>
                                    <?php endforeach;?>
                                </select>
                                <h3 class="text-muted">Volunteer Group</h3>
                            <!-- Close V_Group -->
                            </div>
                        
                        <div class="add-volunteers-row-3">
                            <!-- Buttons -->
                            <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                            <a href="volunteers.php">Clear</a>
                        <!-- close add-volunteers-row-3 -->
                        </div>
                    </div>
                    </form>
                </div>
            <!-- End Add Volunteer -->
            <!-- Start add Group  -->
            <div class="recent-announcements">
                <h2>Add Volunteer Group</h2>
                <div class="announcements">
                    <form action="volunteergroup_add.php" method="post" enctype="multipart/form-data">
                    <div class="volunteergroup_add-form">
                            <div class="G_Name">
                                <input type="text" name="G_Name" class="text-box" placeholder="Enter Group Name" value="<?php echo $G_Name ?>">
                                <h3 class="text-muted">Volunteer Group Name</h3><br>
                            </div>

                            <div class="Area_ID">
                                <select name="Area_ID" value="<?php echo $Area_ID ?>"><br>
                                    <option value="A-0001">A-0001</option>
                                    <option value="A-0002">A-0002</option>
                                    <option value="A-0003">A-0003</option>
                                    <option value="A-0004">A-0004</option>
                                    <option value="A-0005">A-0005</option>
                                </select>
                                <h3 class="text-muted">Area_ID</h3>
                            <!-- Close V_Group -->
                            </div>
                        
                        <div class="add-volunteers-row-3">
                            <!-- Buttons -->
                            <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                            <a href="volunteers.php">Clear</a>
                        <!-- close add-volunteers-row-3 -->
                        </div>
                    </div>
                    </form>
                </div>
            <!-- End Add Volunteer -->

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