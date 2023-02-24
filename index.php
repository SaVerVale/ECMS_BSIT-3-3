<?php 

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

// Evacuation center
$sql = "CALL viewEvacuationCenter";
$result = mysqli_query($conn, $sql);
$row = mysqli_fetch_assoc($result);

// Household Count
$sql2 = "SELECT * from household";
if ($result2 = mysqli_query($conn2, $sql2)) {
    // Return the number of rows in result set
    $rowcount = mysqli_num_rows( $result2 );
 }

// Relief Packs
$sql2 = "SELECT * from relief_goods";
if ($result2 = mysqli_query($conn2, $sql2)) {
    // Return the number of rows in result set
    $rowcount = mysqli_num_rows( $result2 );
 }

// Recent
// $statement = $pdo->prepare('SELECT * FROM recent ORDER BY Recent_ID DESC LIMIT 5');
$statement = $pdo->prepare('CALL viewRecentWithoutNull');
$statement->execute();
$recently = $statement->fetchAll(PDO::FETCH_ASSOC);
$statement->closeCursor();


// Create analyticsEvacuee
// $percentEVAC = '';
// $countEVAC = '';

// $sql2 = "CALL analyticsEvacuee(@percentEVAC, @countEVAC);";
// $result2 = mysqli_query($conn3, $sql);
// $row2 = mysqli_fetch_assoc($result2);
// $percentEVAC = @percentEVAC;

// $statement2 = $pdo->prepare('CALL analyticsEvacuee($percentEVAC, $countEVAC); SELECT @percentEVAC, @countEVAC;');
// $statement2 = $pdo->prepare('CALL analyticsEvacuee(@percentEVAC, @countEVAC);');
    // $statement->bindValue(':percentEVAC', $percentEVAC);
    // $statement->bindValue(':countEVAC', $countEVAC);

    // almost
// $statement2 = $pdo->prepare('CALL analyticsEvacuee(@percentEVAC, @countEVAC);');
// $statement2->execute();
// $evacanal = $statement2->fetchAll(PDO::FETCH_ASSOC);
// $statement2->closeCursor();


// $sql3 = 'CALL analyticsEvacuee(?, ?)';
// $stmt = $conn3->prepare($sql3);

// $second_name = "Rickety Ride";
// $weight = 0;

// $stmt->bindParam(1, $second_name, PDO::PARAM_STR|PDO::PARAM_INPUT_OUTPUT, 32);
// $stmt->bindParam(2, $weight, PDO::PARAM_INT, 10);

// print "Values of bound parameters _before_ CALL:\n";
// print "  1: {$second_name} 2: {$weight}\n";

// $stmt->execute();


// $stmt = $pdo->prepare("CALL sp_takes_string_returns_string(?)");
// $stmt = $pdo->prepare("CALL analyticsEvacuee(?, ?)");
// $value = '@percentEVAC';
// $stmt->bindParam(1, $value, PDO::PARAM_STR|PDO::PARAM_INPUT_OUTPUT, 4000); 

// $stmt = $pdo->prepare("CALL analyticsEvacuee(?, ?)");
// $stmt->bindParam(1, $percentEVAC, PDO::PARAM_STR|PDO::PARAM_INPUT_OUTPUT, 15); 
// $stmt->bindParam(2, $countEVAC, PDO::PARAM_INT|PDO::PARAM_INPUT_OUTPUT); 

// DI LUMABAS
// $stmt = $pdo->prepare("CALL analyticsEvacuee(?, ?); SELECT @percentEVAC, @countEVAC;");
// $stmt->bindParam(1, $percentEVAC, PDO::PARAM_STR, 15); 
// $stmt->bindParam(2, $countEVAC, PDO::PARAM_INT); 
// echo $percentEVAC;

$statement2 = $pdo->prepare('CALL analyticsEvacuee;');
$statement2->execute();
$evacanal = $statement2->fetchAll(PDO::FETCH_ASSOC);
$statement2->closeCursor();

$statement3 = $pdo->prepare('CALL analyticsReliefGoods;');
$statement3->execute();
$rganal = $statement3->fetchAll(PDO::FETCH_ASSOC);
$statement3->closeCursor();

$statement4 = $pdo->prepare('CALL analyticsVolunteers;');
$statement4->execute();
$vltranal = $statement4->fetchAll(PDO::FETCH_ASSOC);
$statement4->closeCursor();

$statement5 = $pdo->prepare('CALL countHousehold;');
$statement5->execute();
$counthh = $statement5->fetchAll(PDO::FETCH_ASSOC);
$statement5->closeCursor();

$statement6 = $pdo->prepare('CALL countReliefGoods;');
$statement6->execute();
$countrg = $statement6->fetchAll(PDO::FETCH_ASSOC);
$statement6->closeCursor();


?>
<!DOCTYPE html>
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
                    <a href="#" class="btn-dashboard active">
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
                <h1>Dashboard</h1>
                <div class="date">
                    <script>
                    date = new Date().toLocaleDateString();
                    document.write(date);
                    </script>
                </div>
                <div class="insights">
                    <!====================== CAPACITY ====================!>
                    <div class="cap">
                        <span class= "material-icons-sharp">night_shelter</span>
                        <div class="middle">
                            <div class="left">
                                 <h3>Total Capacity</h3>
                                <h1><?php echo $row['C_Current_Capacity'];?></h1>
                            </div>
                             
                        </div>
                        
                    </div>
                    <!====================== EVACUEES ====================!>

                    <div class="evacuees">
                        <span class= "material-icons-sharp">family_restroom</span>
                        <div class="middle">
                            <div class="left">
                                 <h3>Number of Families</h3>
                                 <?php foreach ($counthh as $j => $hh) :?>
                                <!-- <h1><?php //echo $rowcount; ?></h1> -->
                                <h1><?php echo $hh['COUNT(Household_ID)'];?></h1>
                                <?php endforeach;?>
                            </div>
                             
                        </div>
                        
                    </div>
                    <!====================== RELIEF ====================!>
                    <div class="inventory">
                        <span class= "material-icons-sharp">food_bank</span>
                        <div class="middle">
                            <div class="left">
                                 <h3>Relief Packs</h3>
                                 <?php foreach ($countrg as $j => $rg) :?>
                                    <!-- <h1>1,523</h1> -->
                                <h1><?php echo $rg['COUNT(DISTINCT Relief_ID)'];?></h1>
                                <?php endforeach;?>
                                
                            </div>
                             
                        </div>
                        
                    </div>
                    <!====================== CAPACITY ====================!>
                </div>

                <div class="recent-updates">
                    <h2>Recent Updates</h2>
                    <div class="recent-update">
                    <div class="main-table">
                    <table class="table">
                        <thead>
                        <tr>
                            <th scope="col">Recent ID</th>
                            <th scope="col">Transact ID</th>
                            <th scope="col">Transact Type</th>
                            <th scope="col">Transaction_DateTime</th>
                        </tr>
                        </thead>
                        <tbody>
                        <?php
                        foreach ($recently as $i => $r2) :
                        ?>
                            <tr>
                            <td><?php echo $r2['Recent_ID'] ?></td>
                            <td><?php echo $r2['Transact_ID'] ?></td>
                            <td><?php echo $r2['Transact_Type'] ?></td>
                            <td><?php echo $r2['Transaction_DateTime'] ?></td>
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
                    <h2>Announcements</h2>
                    <div class="announcements">
                        <div class="announcement">
                            <div class="profile-photo">
                                <img src="assets/profile-2.jpg">
                            </div>
                            <div class="message">
                                <p><b>NDRRMC</b> Alert Level 3 in Metro Manila and surrounding regions.</p>
                                <small class="text-muted">4 Minutes Ago</small>
                            </div>
                        </div>

                        <div class="announcement">
                            <div class="profile-photo">
                                <img src="assets/profile-2.jpg">
                            </div>
                            <div class="message">
                                <p><b>NDRRMC</b> Alert Level 4 in North Luzon and Central Luzon regions.</p>
                                <small class="text-muted">6 Minutes Ago</small>
                            </div>
                        </div>

                        <div class="announcement">
                            <div class="profile-photo">
                                <img src="assets/profile-2.jpg">
                            </div>
                            <div class="message">
                                <p><b>NDRRMC</b> Alert Level 2 in South Luzon and Northern Visayas regions.</p>
                                <small class="text-muted">11 Minutes Ago</small>
                            </div>
                        </div>
                    </div>
                </div>
                <! ---------------- End of Announcements ---------------- !>
                    <div class="evac-analytics">
                        <a href="Analytics.php"><h2>Analytics</h2></a>
                        <div class="evacuee analysis">
                            <div class="icon">
                                <span class= "material-icons-sharp">groups</span>
                            </div>
                            <div class="right">
                                <div class="info">
                                    <h3>EVACUEES</h3>
                                    <small class="text-muted">Last 24 Hours</small>
                                </div>
                                <?php foreach ($evacanal as $i => $vv) : ?>
                                <h5 class="success">+
                                    <?php echo $vv['@percentage'] ?> 
                                    <?php //echo $row2['@percentEVAC'];?>
                                    <?php //echo $percentEVAC.$countEVAC;?>
                                    <?php //echo $percentEVAC;?>
                                 </h5>
                                <h3><?php echo $vv['@currentCount'] ?> </h3>
                                <?php endforeach;?>
                            </div>
                        </div>

                        <div class="volunteer analysis">
                            <div class="icon">
                                <span class="material-icons-sharp">volunteer_activism</span>
                            </div>
                            <div class="right">
                                <div class="info">
                                    <h3>VOLUNTEERS</h3>
                                    
                                    <small class="text-muted">Last 24 Hours</small>
                                </div>
                                <?php foreach ($rganal as $i => $vv) : ?>
                                    <h5 class="success">+<?php echo $vv['@percentage'] ?> </h5>
                                    <h3><?php echo $vv['@currentCount'] ?></h3>
                                <?php endforeach;?>
                            </div>
                        </div>

                        <div class="inventory analysis">
                            <div class="icon">
                                <span class= "material-icons-sharp">set_meal</span>
                            </div>
                            <div class="right">
                                <div class="info">
                                    <h3>RELIEF GOODS</h3>
                                    <small class="text-muted">Last 24 Hours</small>
                                </div>
                                <?php foreach ($vltranal as $i => $vv) : ?>
                                    <h5 class="success">+<?php echo $vv['@percentage'] ?></h5>
                                    <h3><?php echo $vv['@currentCount'] ?></h3>
                                <?php endforeach;?>
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
