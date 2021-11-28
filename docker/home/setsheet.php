<?php
header('Content-Type-type: application/json');
include 'db.php';


$result = mysqli_query($db,"INSERT INTO cinemaNumber ($,$,$);");


$result_array = array();

while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    $result_array[] = $row;
}
echo json_encode($result_array);

mysqli_close($db);

