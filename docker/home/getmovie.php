<?php
header('Content-Type-type: application/json');
include 'db.php';



$movieNumber =  $_POST['movieNumber'];

$result = mysqli_query($db,"SELECT * FROM movie WHERE movie.movieNumber = $movieNumber;");


$result_array = array();

while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    $result_array[] = $row;
}
echo json_encode($result_array);

mysqli_close($db);

