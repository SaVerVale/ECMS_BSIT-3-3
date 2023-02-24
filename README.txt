Pakidagdag nalang sa center.php itong code, kasi nasisira ko yung page kapag pinepaste ko.
Ito yung table para sa room managers.

<h1>Room Manager</h1><br><br>

<!-- create form -->
<p>
  <a href="evacuee_create.php" class="btn btn-success">Add Room</a>
</p>

<table class="table">
  <thead>
    <tr>
      <th scope="col">Room_ID</th>
      <th scope="col">R_Name</th>
      <th scope="col">Classification</th>
      <th scope="col">R_Total_Capacity</th>
      <th scope="col">R_Current_Capacity</th>
    </tr>
  </thead>
  <tbody>
    <?php
    foreach ($center2 as $i => $croom) :
    ?>
      <tr>
        <td scope="row"><?php echo $croom['Room_ID'] ?></td>
        <td><?php echo $croom['R_Name']?></td>
        <td><?php echo $croom['Classification'] ?></td>
        <td><?php echo $croom['R_Total_Capacity'] ?></td>
        <td><?php echo $croom['R_Current_Capacity'] ?></td>

        <td>
          <!-- Edit button -->
          <a href="evacuee_update.php?Evacuee_ID=<?php echo $croom['Room_ID'] ?>" id="btn-edit" class="btn btn-sm btn-primary">Edit</a>

          
          <!-- Delete button -->
          <form style="display:inline-block" method="post" action="evacuee_delete.php">
            <input type="hidden" name="Evacuee_ID" value="<?php echo $croom['Room_ID'] ?>">
            <button type="submit" id="btn-delete" class="btn btn-sm btn-danger">Delete</button>
          </form>
        </td>

      </tr>
    <?php
    endforeach;
    ?>

  </tbody>
</table>