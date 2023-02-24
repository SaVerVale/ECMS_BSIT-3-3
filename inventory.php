<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

// if FirstName is empty, throw error because it is required
$errors = [];

// solution when FirstName, etc is empty
// $Item_ID = '';
$I_Name = '';
$Expiry = '';
$Quantity = '';

// add evac
$First_Name = '';
$Middle_Name = '';
$Last_Name = '';
$Sex = '';
$Birthday = '';
$Contact_No = '';
$Household_ID = '';

// add pack zxc
$Relief_ID = '';
$Item_ID = '';
$Date_Packed = '';
$R_Quantity = '';

// // search function for inventory
// $search = $_GET['search'] ?? '';
// if ($search) {
//   $statement = $pdo->prepare('call searchEvacuee(:First_Name)');
//   $statement->bindValue(':First_Name', "%$search%");
// } else{
//   $statement = $pdo->prepare('CALL viewEvacueeJoinHousehold');
// }

$search = $_GET['search'] ?? '';
if ($search) {
  $statement = $pdo->prepare('CALL searchItem(:In_Text)');
  $statement->bindValue(':In_Text', "$search");
  $statement->execute();
  $item = $statement->fetchAll(PDO::FETCH_ASSOC);
    $statement->closeCursor();
} else{
    $statement = $pdo->prepare('CALL viewItem');
    $statement->execute();
    $item = $statement->fetchAll(PDO::FETCH_ASSOC);
    $statement->closeCursor();
}
// $statement = $pdo->prepare('CALL viewItem');
// $statement->execute();
// $item = $statement->fetchAll(PDO::FETCH_ASSOC);
// $statement->closeCursor();

$sort = $_GET['sort'] ?? '';
if ($sort) {
  $statement4 = $pdo->prepare('CALL viewItemSortBy(:Field_Name)');
  $statement4->bindValue(':Field_Name', "$sort");
  $statement->closeCursor();
  $statement4->execute();
  $item = $statement4->fetchAll(PDO::FETCH_ASSOC);
  $statement4->closeCursor();
}

$statement2 = $pdo->prepare('CALL viewReliefGood');
$statement2->execute();
$statement->closeCursor();
$good = $statement2->fetchAll(PDO::FETCH_ASSOC);

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
                <a href="#" class="btn-inventory active">
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
            <h1>Inventory Manager</h1>

            <div class="recent-updates">
                <h2>Item Inventory</h2>
                <div class="recent-update">
                
                <div class="input-group mb-3">
                        <!-- search item -->
                        <form>
                            <input type="text" class="form-control text-box" 
                                    placeholder="Search for Item Name" 
                                    name="search" value="<?php echo $search ?>" style="float: left;">
                            <!-- <div class="input-group-append"> -->
                            <button class="btn btn-outline-secondary" type="submit" style="float: left;">Search</button>
                        </form>

                        <form>
                        <button class="btn btn-outline-secondary" type="submit" style="float: right;">Sort</button>
                        <select name="sort" value="<?php echo $sort ?>"  style="float: right;">
                                    <option value="Item_ID" disabled selected value>Choose Sort by</option>
                                    <option value="Item_ID" selected="Item_ID">Item_ID</option>
                                    <option value="Expiry">Expiry</option>
                                    <option value="I_Quantity">I_Quantity</option> 
                                    
                                </select>
                        </form>
                        <!-- </div> -->
                        <!-- End search item -->
                    </div>
                    <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">I_Name</th>
                        <th scope="col">Expiry</th>
                        <th scope="col">I_Quantity</th>
                        <!-- <th scope="col">Contact_No</th> -->
                        <th scope="col">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($item as $j => $ii) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $ii['Item_ID'] ?></td>
                        <td><?php echo $ii['I_Name'];?></td>
                        <td><?php echo $ii['Expiry'] ?></td>
                        <td><?php echo $ii['I_Quantity'] ?></td>

                        <td>
                            <!-- Edit button -->
                            <a href="item_update.php?Item_ID=<?php echo $ii['Item_ID'] ?>" id="sub" class="btn btn-primary">Edit</a>

                            
                            <!-- Delete button -->
                            <form style="display:inline-block" method="post" action="item_delete.php">
                            <input type="hidden" name="Item_ID" value="<?php echo $ii['Item_ID'] ?>">
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
            <!-- End of Item Inventory -->
            </div>
            
            <div class="recent-updates">
                <h2>Relief Packs</h2>
                    <form>
                    <div class="recent-update">
                    <div class="input-group mb-3">
                        <!-- Search household -->
                        <!-- <input type="text" class="form-control" 
                                placeholder="Search for Household" 
                                name="search2" value="<?php //echo $search2 ?>"> -->
                        <div class="input-group-append">
                        <!-- <button class="btn btn-outline-secondary" type="submit">Search</button> -->
                        <!-- <button class="btn btn-outline-secondary" type="submit" style="float: right;">View By Household</button> -->
                        </div>
                    </div>
                    </form>
                <div class="main-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">Relief_ID</th>
                        <th scope="col">Item/s</th>
                        <!-- <th scope="col">Action</th> -->
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($good as $x => $xx) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $xx['Relief_ID'] ?></td>
                        <td><?php echo $xx['Item/s'];?></td>

                        <!-- <td> -->
                            <!-- Edit button -->
                            <!-- <a href="household_update.php?Household_ID=<?php //echo $hh['Household_ID'] ?>" id="sub" class="btn btn-primary">Edit</a> -->

                            
                            <!-- Delete button -->
                            <!-- <form style="display:inline-block" method="post" action="household_delete.php">
                            <input type="hidden" name="Household_ID" value="<?php //echo $hh['Household_ID'] ?>">
                            <button type="submit">Delete</button> -->
                            
                            </form>
                        <!-- </td> -->

                        </tr>
                    <?php
                    endforeach;
                    ?>

                    </tbody>
                </table>
                </div>
                </div>
                <a href="#">Show All</a>
            <!-- End of Relief Pack -->
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
                <h2>Add Item</h2>
                <div class="announcements">
                    
                        <div class="add-items-form">
                        <form action="item_add.php" method="post" enctype="multipart/form-data">
                            <div class="I_Name">
                            <input type="text" name="I_Name" class="text-box" placeholder="Enter Item Name" value="<?php echo $I_Name ?>">
                            <h3 class="text-muted">Item Name</h3>
                            </div>
                            <div class="Expiry">
                                <input type="date" name="Expiry" class="text-box" value="<?php echo $Expiry ?>">
                                <h3 class="text-muted">Expiry</h3>
                            </div>
                            <div class="Quantity">
                                <input type="number" name="Quantity" class="text-box" placeholder="Enter Quantity" value="<?php echo $Quantity ?>">
                                <h3 class="text-muted">Quantity</h3>
                            </div>

                            <div class="add-items-row-3">
                                <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                                <a href="inventory.php">Clear</a>
                            </div>
                        </form>
                        </div>
                    
                </div>
            </div>
            <!-- --------------------------------------------------------------- -->
            <!-- <div class="recent-announcements">
                <h2>Add Evacuees</h2>
                <div class="announcements">
                    <form action="evacuee_add.php" method="post" enctype="multipart/form-data">
                    <div class="add-evacuees-form">
                            <div class="firstname">
                                <input type="text" name="First_Name" class="text-box" placeholder="Enter First Name" value="<?php echo $First_Name ?>">
                                <h3 class="text-muted">First Name</h3><br>
                            </div>
    
                            <div class="middlename">
                            <input type="text" name="Middle_Name" class="text-box" placeholder="Enter Middle Name" value="<?php echo $Middle_Name ?>">
                                <h3 class="text-muted">Middle Name</h3><br>
                            </div>
    
                            <div class="lastname">
                            <input type="text" name="Last_Name" class="text-box" placeholder="Enter Last Name" value="<?php echo $Last_Name ?>">
                                <h3 class="text-muted">Last Name</h3>
                            </div>

                        <div class="add-evacuees-row">
                            
                            <div>
                                <select name="Sex" value="<?php //echo $Sex ?>">
                                    <option value="M">Male</option>
                                    <option value="F">Female</option>
                                </select>
                                <h3 class="text-muted">Sex</h3>
                            </div> -->
                        <!-- Close row -->
                        <!-- </div>
                            <div>
                                <input type="date" name="Birthday" class="text-box" value="<?php //echo $Birthday ?>">
                                <h3 class="text-muted">Birthday</h3>
                            </div>

                            <div>
                            <input type="text" name="Contact_No" class="text-box" placeholder="Enter Contact Number" value="<?php echo $Contact_No ?>">
                                <h3 class="text-muted">Contact No</h3>
                            </div>
                        
                        <div class="add-evacuees-row-3">
                            <div class="household-field">
                                <select name="Household_ID" value="<?php //echo $Household_ID ?>"><br>
                                    <option value="HHOLD-0001">HHOLD-0001</option>
                                    <option value="HHOLD-0002">HHOLD-0002</option>
                                    <option value="HHOLD-0003">HHOLD-0003</option>
                                    <option value="HHOLD-0004">HHOLD-0004</option>
                                    <option value="HHOLD-0005">HHOLD-0005</option>
                                    <option value="HHOLD-0006">HHOLD-0006</option>
                                    <option value="HHOLD-0007">HHOLD-0007</option>
                                    <option value="HHOLD-0008">HHOLD-0008</option>
                                    <option value="HHOLD-0009">HHOLD-0009</option>
                                </select>
                                <h3 class="text-muted">Household</h3> -->
                            <!-- Close household-field -->
                            <!-- </div> -->
                            <!-- Buttons -->
                            <!-- <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                            <a href="evacuees.php">Clear</a> -->
                        <!-- close add-evacuees-row-3 -->
                        <!-- </div>
                    </div>
                    </form> -->
                <!-- Close Announcements -->
                <!-- </div> -->
            <!-- Close recent Announcements -->
            <!-- </div> -->
            <!-- --------------------------------------------------------------- -->
            
            <!-- zxc -->
            <div class="recent-announcements">
                <h2>Relief Packing</h2>
                <div class="announcements">
                    
                        <div class="add-items-form">
                        <form action="reliefpack_add.php" method="post" enctype="multipart/form-data">
                            <div class="Relief_ID">
                                <input type="text" name="Relief_ID" class="text-box" placeholder="Enter Relief_ID" value="<?php echo $Relief_ID ?>">
                                <h3 class="text-muted">Relief_ID</h3>
                            </div>
                            <div class="Item_ID">
                                <!-- <input type="text" name="Item_ID" class="text-box" placeholder="Enter Item_ID" value="<?php //echo $Item_ID ?>"> -->
                                <select name="Item_ID" value="<?php echo $Item_ID ?>"><br>
                                <?php foreach ($item as $i => $rr) :?>
                                    <option value="<?php echo $rr['Item_ID'];?>"><?php echo $rr['Item_ID']."\t(".$rr['I_Name'].")" ?></option>
                                    <?php endforeach;?>
                                </select>
                                <h3 class="text-muted">Item_ID</h3>
                            </div>
                            <div class="Date_Packed">
                                <input type="date" name="Date_Packed" class="text-box" value="<?php echo $Date_Packed ?>">
                                <h3 class="text-muted">Date_Packed</h3>
                            </div>
                            <div class="R_Quantity">
                                <input type="number" name="R_Quantity" class="text-box" placeholder="Enter R_Quantity" value="<?php echo $R_Quantity ?>">
                                <h3 class="text-muted">R_Quantity</h3>
                            </div>

                            <div class="add-items-row-3">
                                <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                                <a href="inventory.php">Clear</a>
                            </div>
                        </form>
                        </div>
                    
                </div>
            </div>
        
            <! ---------------- End of Announcements ---------------- !>
            <!-- <div class="recent-announcements">
                <h2>Relief Packing</h2>
                <div class="announcements">
                    
                        <div class="relief-packing-form">
                           
                            <div class="relief-item-table">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Item</th>
                                        <th>Quantity</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Noodles</td>
                                        <td>2</td>
                                        <td><button>Remove</button></td>
                                    </tr>
                                    <tr>
                                        <td>Corned Beef</td>
                                        <td>2</td>
                                        <td><button>Remove</button></td>
                                    </tr>
                                    <tr>
                                        <td>Rice</td>
                                        <td>2</td>
                                        <td><button>Remove</button></td>
                                    </tr>
                                    <tr>
                                        <td>Nescafe 3n1</td>
                                        <td>2</td>
                                        <td><button>Remove</button></td>
                                    </tr>
                                    <tr>
                                        <td>Alaska</td>
                                        <td>2</td>
                                        <td><button>Remove</button></td>
                                    </tr>
                                </tbody>
                            </table>
                            </div>
                            <div class="relief-packing-row-1">
                                    <div class="item-field">
                                        <datalist id="item-suggestions" >
                                            <option>Noodles</option>
                                            <option>Corned Beef</option>
                                            <option>Sardines</option>
                                            <option>Meat Loaf</option>
                                            <option>Rice</option>
                                        </datalist>
                                        <input  autoComplete="on" list="item-suggestions" class="txt-item"/> 
                                        <h3 class="text-muted">Item</h3>
                                    </div>
                                    <div class="itemqty">
                                        <input type="number" name="quantity" class="text-box" >
                                        <h3 class="text-muted">Quantity</h3>
                                    </div>
                                    <button>Add</button>             
                            </div>
                            <div class="relief-packing-last-row">
                                <div class="relief-multiplier">
                                    <input type="number" name="multiplier" class="text-box" >
                                    <h3 class="text-muted">Multiplier</h3>
                                </div>
                                <button>Submit</button>
                                <button>Clear</button>
                            </div>
                </div> -->
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