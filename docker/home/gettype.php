<?php
header('Content-Type-type: application/json');
include 'db.php';



$cinemaNumber =  $_GET['cinemaNumber'];

$sql = "SELECT * FROM cinema WHERE cinemaNumber = '$cinemaNumber';";
$result = mysqli_query($db,$sql);
$result_array = array();

while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    $result_array[] = $row;
}

echo json_encode($result_array);




mysqli_close($db);

