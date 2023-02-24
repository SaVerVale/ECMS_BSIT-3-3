<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

$search = $_GET['search'] ?? '';
if ($search) {
  $statement = $pdo->prepare('CALL viewRoom');
  $statement->execute();
  $room = $statement->fetchAll(PDO::FETCH_ASSOC);
  $statement->closeCursor();

  //$rr['Room_ID']
  //foreach ($room as $i => $rr) :
  $statement2 = $pdo->prepare('CALL viewHouseholdByRoom(:Field_Name)');
  $statement2->bindValue(':Field_Name', "$search");
  //endforeach;
  $statement2->execute();
  $household = $statement2->fetchAll(PDO::FETCH_ASSOC);
  $statement2->closeCursor();


} else{
  $statement = $pdo->prepare('CALL viewRoom');
  $statement->execute();
  $room = $statement->fetchAll(PDO::FETCH_ASSOC);
  $statement->closeCursor();
  $statement2 = $pdo->prepare('CALL viewHousehold');
  $statement2->execute();
  $household = $statement2->fetchAll(PDO::FETCH_ASSOC);
  $statement2->closeCursor();
}

  $statement3 = $pdo->prepare('CALL viewDistributionHistory');
  $statement3->execute();
  $History = $statement3->fetchAll(PDO::FETCH_ASSOC);
  $statement3->closeCursor();

  $statement4 = $pdo->prepare('CALL viewReliefGoodGrouped');
  $statement4->execute();
  $pack= $statement4->fetchAll(PDO::FETCH_ASSOC);
  $statement4->closeCursor();

  $statement5 = $pdo->prepare('CALL viewHousehold');
  $statement5->execute();
  $household2 = $statement5->fetchAll(PDO::FETCH_ASSOC);
  $statement5->closeCursor();

// if FirstName is empty, throw error because it is required
$errors = [];

// solution when FirstName, etc is empty
// $Item_ID = '';
$I_Name = '';
$Expiry = '';
$Quantity = '';

// Create Evacuee
// solution when FirstName, etc is empty
$Household_ID = '';
$Items = '';
$Date_Given = '';
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
                <a href="volunteers.php" class="btn-volunteers">
                    <span class="material-icons-sharp">volunteer_activism</span>
                    <h3>Volunteers</h3>
                </a>
                <a href="inventory.php" class="btn-inventory">
                    <span class="material-icons-sharp">inventory</span>
                    <h3>Inventory</h3>
                </a>
                <a href="#" class="btn-distribution active">
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
            <h1>Relief Distribution Manager</h1>
            

            <div class="recent-updates">
            <h2>Rooms</h2>
                
                <div class="recent-update">
                    <!-- <br> -->
                    <form>
                    <!-- <div class="input-group mb-3"> -->
                        <!-- <input type="text" class="form-control" 
                                placeholder="" 
                                name="search" value="<?php //echo $search ?>" readonly><br> -->

                                <select name="search" value="<?php echo $search ?>" style="float:left;">
                                    <?php foreach ($room as $i => $rr) :?>
                                    <option value="<?php echo $rr['Room_ID'];?>"><?php echo $rr['R_Name'] ?></option>
                                    <?php endforeach;?>
                                </select>

                        <!-- <div class="input-group-append"> -->
                        <button class="btn btn-outline-secondary" type="submit" style="float:left;">Search</button>
                        <!-- <button class="btn btn-outline-secondary" type="submit" style="float: right;">View By Household</button> -->
                        <!-- </div> -->
                    <!-- </div> -->
                    </form>
                

                <!-- Form distribution add -->
                <form action="distribution_adds.php" method="post" enctype="multipart/form-data">
                <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <!-- <th scope="col">/</th> -->
                        <th scope="col">Household_ID</th>
                        <th scope="col">Family_Head</th>
                        <th scope="col">Members</th>
                        <!-- <th scope="col">Contact_No</th> -->
                        <!-- <th scope="col">Action</th> -->
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($household as $i => $hh) :
                    ?>
                        <tr>
                        <!-- <td scope="row"><input type="checkbox" name="lols[]" value="<?php //echo $hh['Household_ID'];?>"/></td> -->
                        <td scope="row"><?php echo $hh['Household_ID'] ?></td>
                        <td><?php echo $hh['Family_Head'];?></td>
                        <td><?php echo $hh['Number_of_Members'] ?></td>

                        <!-- <td> -->
                            <!-- Edit button -->
                            <!-- <a href="item_update.php?Item_ID=<?php //echo $ii['Item_ID'] ?>" id="sub" class="btn btn-primary">Edit</a> -->

                            
                            <!-- Delete button -->
                            <!-- <form style="display:inline-block" method="post" action="item_delete.php">
                            <input type="hidden" name="Item_ID" value="<?php //echo $ii['Item_ID'] ?>">
                            <button type="submit">Delete</button>
                            
                            </form> -->
                        <!-- </td> -->

                        </tr>
                    <?php
                    endforeach;
                    ?>

                    </tbody>
                </table>
                </div>
                </div>
                <!-- Delete  -->
                <!-- <button type="submit" id="sub" class="btn btn-primary">Submit</button> -->
                </form>
            </div>

            <!-- End of Household -->
            <!-- Start of Distribution History -->

            <div class="recent-updates">
                <h2 id="anchor">Distribution History</h2>
                <div class="recent-update">
                <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">Distribution_ID</th>
                        <th scope="col">Relief_ID</th>
                        <th scope="col">Household_ID</th>
                        <th scope="col">Family_Head</th>
                        <th scope="col">Date_Given</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($History as $x => $xx) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $xx['Distribution_ID'] ?></td>
                        <td scope="row"><?php echo $xx['Relief_ID'] ?></td>
                        <td><?php echo $xx['Household_ID'];?></td>
                        <td><?php echo $xx['Family_Head'] ?></td>
                        <td><?php echo $xx['Date_Given'] ?></td>


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
                <h2>Relief Goods</h2>
                <form action="distribution_add1.php" method="post" enctype="multipart/form-data">

                <div class="announcements">
                    <div class="add-items-form">
                    <select name="Household_ID" value="<?php echo $Household_ID ?>" >
                                    <?php foreach ($household2 as $i => $rr) :?>
                                    <option value="<?php echo $rr['Household_ID'];?>"><?php echo $rr['Household_ID'] ?></option>
                                    <?php endforeach;?>
                                </select><br>
                                <h3 class="text-muted">Enter Household</h3><br>

                                <select name="Items" value="<?php echo $Items ?>" >
                                    <?php foreach ($pack as $p => $pp):?>
                                    <option value="<?php echo $pp['Items'];?>"><?php echo $pp['Items'] ?> (Packs left: <?php echo $pp['COUNT(*)'] ?>)</option>
                                    <?php endforeach;?>
                                </select><br>
                                <h3 class="text-muted">Enter Pack</h3><br>
                        <div class="distribute-form">
                <!-- Table -->
                    <!-- <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">/</th>
                        <th scope="col">Packs left</th>
                        <th scope="col">Items</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php //foreach ($pack as $p => $pp) :?>
                        <tr>
                        <td scope="row"><input type="checkbox" name="Items" value="<?php //echo $Items;?>"/></td>
                        <td scope="row"><?php //echo $pp['COUNT(*)'] ?></td>
                        <td><?php //echo $pp['Items'];?></td>
                        </tr>
                    <?php //endforeach; ?>

                    </tbody>
                </table> -->
                            <div>
                                <input type="date" name="Date_Given" class="text-box" value="<?php echo $Date_Given ?>">
                                <h3 class="text-muted">Date_Given</h3>
                            </div>

                            <div class="distribute-row-2">
                                <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                                <a href="distribution.php">Clear</a>
                            </div>
    
                        </div>
                    </div>
                    <!-- iterateform -->
                    </form>
                </div>
            </div>
            <!-- End Relief Goods -->
            <! ---------------- End of Announcements ---------------- !>
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