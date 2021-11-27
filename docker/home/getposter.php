<?php
header("Content-Type: image/jpeg");
include 'db.php';



$movieNumber =  $_GET['movieNumber'];

$sql = "SELECT * FROM movie WHERE movie.movieNumber = '$movieNumber';";
$result = mysqli_query($db,$sql);
$result_array = array();

while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    echo $row['poster'];
}


mysqli_close($db);

