<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";

// Area
$statement2 = $pdo->prepare('CALL viewArea');
$statement2->execute();
$rooms = $statement2->fetchAll(PDO::FETCH_ASSOC);
$statement2->closeCursor();

// if FirstName is empty, throw error because it is required
$errors = [];

// solution when FirstName, etc is empty
// $Room_ID = '';
$R_Name = '';
$Area_ID = '';
$R_Total_Capacity = '';

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//   $Room_ID = $_POST['Room_ID'];
  $R_Name = $_POST['R_Name'];
  $Area_ID = $_POST['Area_ID'];
  $R_Total_Capacity = $_POST['R_Total_Capacity'];


  // if FirstName is empty, throw error because it is required
//   if (!$Room_ID) {
//     $errors[] = 'Please enter Room_ID';
//   }
  if (!$R_Name) {
    $errors[] = 'Please enter R_Name';
  }
  if (!$Area_ID) {
    $errors[] = 'Please enter Area_ID';
  }
  if (!$R_Total_Capacity) {
    $errors[] = 'Please enter your R_Total_Capacity';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    $statement = $pdo->prepare("CALL addRoom(:R_Name, :Area_ID, :R_Total_Capacity);
                                
                  ");
    // $statement->bindValue(':Room_ID', $Room_ID);
    $statement->bindValue(':R_Name', $R_Name);
    $statement->bindValue(':Area_ID', $Area_ID);
    $statement->bindValue(':R_Total_Capacity', $R_Total_Capacity);
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
                <a href="inventory.php" class="btn-inventory">
                    <span class="material-icons-sharp">inventory</span>
                    <h3>Inventory</h3>
                </a>
                <a href="#" class="btn-settings">
                    <span class="material-icons-sharp">settings</span>
                    <h3>Settings</h3>
                </a>

                <a href="#" class="btn-logout">
                    <span class="material-icons-sharp">logout</span>
                    <h3>Logout</h3>
                </a>
            </div>
        </aside>
        <!===================== END OF ASIDE =======================!>

        <main>

            <h1>Room Manager</h1>
            <div class="add-evacuees">
                <h2>---Add Room</h2>
                <form action="" method="post" enctype="multipart/form-data">
                <div class="add-evacuees-form">

                    <!-- Display error -->
                <?php if (!empty($errors)): ?>
                                <div class="alert alert-danger">
                                    <?php foreach ($errors as $error) :?>
                                    <div><?php echo $error ?></div>
                                    <?php endforeach; ?>
                                </div>
                                <?php endif ?>
                                
                    <div class="add-evacuees-row-1">
                        <div class="R_Name">
                        <input type="text" name="R_Name" class="text-box" placeholder="Enter Room Name" value="<?php echo $R_Name ?>">
                        <h3 class="text-muted">Room Name</h3>
                        </div>

                        <div class="R_Total_Capacity">
                        <input type="number" name="R_Total_Capacity" class="text-box" placeholder="Enter Room Total Capacity" value="<?php echo $R_Total_Capacity ?>">
                        <h3 class="text-muted">Room Total Capacity</h3>
                        </div>
                    </div>
                    <div class="add-evacuees-row-2">
                        

                        <div class="Area_ID">
                        <!-- <select name="Area_ID" value="<?php //echo $Area_ID ?>"><br>
                            <option value="A-0001">A-0001</option>
                            <option value="A-0002">A-0002</option>
                            <option value="A-0003">A-0003</option>
                            <option value="A-0004">A-0004</option>
                        </select> -->

                        <select name="Area_ID" value="<?php echo $Area_ID ?>"><br>
                                <?php foreach ($rooms as $r => $rr) :?>
                                    <option value="<?php echo $rr['Area_ID'];?>"><?php echo $rr['Area_ID'] ?></option>
                                <?php endforeach;?>
                        </select>

                        <h3 class="text-muted">Area_ID</h3>
                        </div>
                    </div>
                    <br><br>
                    <div class="add-evacuees-row-3">
                        
                        <button type="submit" id="sub" class="btn btn-primary">Submit</button>
                        <a href="center.php">Clear</a>
                    </div>
                </form>
                </div>
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
                    <h2>Analytics</h2>
                    <div class="evacuee analysis">
                        <div class="icon">
                            <span class= "material-icons-sharp">groups</span>
                        </div>
                        <div class="right">
                            <div class="info">
                                <h3>EVACUEES</h3>
                                <small class="text-muted">Last 24 Hours</small>
                            </div>
                            <h5 class="success">+26%</h5>
                            <h3>854</h3>
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
                            <h5 class="danger">-15%</h5>
                            <h3>23</h3>
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
                            <h5 class="warning">+0.7%</h5>
                            <h3>1,523</h3>
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