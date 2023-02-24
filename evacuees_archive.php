<?php

// <!-- create connection to database -->
/** @var $pdo \PDO */
require_once "database.php";
include('session.php');

// you can use exec() but not good, only to make changes on database schema
// to select                CALL addEvacuee(:First_Name, :Middle_Name, :Last_Name, :Sex, :Birthday, :Contact_No, :Household_ID);
// $statement = $pdo->prepare("CALL ViewEvacuee();");

// search function
$search = $_GET['search'] ?? '';
if ($search) {
  $statement = $pdo->prepare('SELECT * FROM evacuee_archive WHERE First_Name LIKE :First_Name');
  $statement->bindValue(':First_Name', "%$search%");
} else{
  $statement = $pdo->prepare('SELECT * FROM evacuee_archive');
}                               
                            // CALL ViewEvacuee()

$statement->execute();
$evacuee = $statement->fetchAll(PDO::FETCH_ASSOC);

// if FirstName is empty, throw error because it is required
$errors = [];

// solution when FirstName, etc is empty
$First_Name = '';
$Middle_Name = '';
$Last_Name = '';
$Sex = '';
$Birthday = '';
$Contact_No = '';
$Household_ID = '';

// show request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $First_Name = $_POST['First_Name'];
  $Middle_Name = $_POST['Middle_Name'];
  $Last_Name = $_POST['Last_Name'];
  $Sex = $_POST['Sex'];
  $Birthday = $_POST['Birthday'];
  $Contact_No = $_POST['Contact_No'];
  $Household_ID = $_POST['Household_ID'];


  // if FirstName is empty, throw error because it is required
  if (!$First_Name) {
    $errors[] = 'Please enter your First Name';
  }
  if (!$Last_Name) {
    $errors[] = 'Please enter your Last Name';
  }
  if (!$Sex) {
    $errors[] = 'Please enter your Gender';
  }
  if (!$Contact_No) {
    $errors[] = 'Please enter your Contact No';
  }

  // Only Submit to sql when it is not empty
  if (empty($errors)) {

    // double quotations are used so I can use variables in strings
    // exec() instead of prepare() should be avoided because it is unsafe
    // I created named parameters
    // $statement = $pdo->prepare("CALL addEvacuee(:First_Name, :Middle_Name, :Last_Name, :Sex, :Birthday, :Contact_No, :Household_ID);
                                
    //               ");
    //             //   SELECT Household_ID FROM dagdaghh ORDER BY Household_ID ASC
    // $statement->bindValue(':First_Name', $First_Name);
    // $statement->bindValue(':Middle_Name', $Middle_Name);
    // $statement->bindValue(':Last_Name', $Last_Name);
    // $statement->bindValue(':Sex', $Sex);
    // $statement->bindValue(':Birthday', $Birthday);
    // $statement->bindValue(':Contact_No', $Contact_No);
    // $statement->bindValue(':Household_ID', $Household_ID);
    // $statement->execute();

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

                <a href = "session_logout.php" class="btn-logout">
                    <span class="material-icons-sharp">logout</span>
                    <h3>Logout</h3>
                </a>
            </div>
        </aside>
        <!===================== END OF ASIDE =======================!>

        <main>

            <h1>Evacuee Archive</h1>
            <div class="add-evacuees">
                <h2></h2>
                
            </div>
            <div class="recent-updates">
                <h2>Evacuees' Archive Information</h2>
                    <form>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" 
                                placeholder="Search for Evacuee Name" 
                                name="search" value="<?php echo $search ?>">
                        <div class="input-group-append">
                        <button class="btn btn-outline-secondary" type="submit">Search</button>
                        </div>
                    </div>
                    </form>
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Full Name</th>
                        <th scope="col">Sex</th>
                        <!-- <th scope="col">Age</th> -->
                        <th scope="col">Birthday</th>
                        <th scope="col">Contact_No</th>
                        <th scope="col">Status</th>
                        <th scope="col">Household_ID</th>
                        <th scope="col">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    foreach ($evacuee as $i => $evacuee2) :
                    ?>
                        <tr>
                        <td scope="row"><?php echo $evacuee2['Evacuee_ID'] ?></td>
                        <td><?php echo $evacuee2['Last_Name']; echo ", "; echo $evacuee2['First_Name']; echo " "; echo $evacuee2['Middle_Name']?></td>
                        <td><?php echo $evacuee2['Sex'] ?></td>
                        <!-- <td><?php //echo $evacuee2['Age'] ?></td> -->
                        <td><?php echo $evacuee2['Birthday'] ?></td>
                        <td><?php echo $evacuee2['Contact_No'] ?></td>
                        <td><?php echo $evacuee2['Evacuation_Status'] ?></td>
                        <td><?php echo $evacuee2['Household_ID'] ?></td>

                        <td>
                            <!-- Edit button -->
                            <!-- <a href="evacuee_update.php?Evacuee_ID=<?php echo $evacuee2['Evacuee_ID'] ?>" id="sub" class="btn btn-primary">Edit</a> -->

                            
                            <!-- Delete button -->
                            <form style="display:inline-block" method="post" action="evacuee_delete.php">
                            <input type="hidden" name="Evacuee_ID" value="<?php echo $evacuee2['Evacuee_ID'] ?>">
                            <!-- <button type="submit">Delete</button> -->
                            
                            </form>
                        </td>

                        </tr>
                    <?php
                    endforeach;
                    ?>

                    </tbody>
                </table>
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