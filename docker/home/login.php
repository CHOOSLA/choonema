<?php
header('Content-Type-type: application/json');
include 'db.php';



$id =  $_POST['id'];
$pwd = (int) $_POST['pwd'];

$result = mysqli_query($db,"SELECT userName FROM user WHERE user.password = SHA2('$pwd',256) AND user.userID = '$id';");


$result_array = array();

while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    $result_array[] = $row;
}
echo json_encode($result_array);

mysqli_close($db);

