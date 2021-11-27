<?php
header('Content-Type-type: application/json');
include 'db.php';

$sql = "SELECT userName FROM user WHERE user.password = SHA2(1234,256) AND user.userID = 'choochoo';";

$result = mysqli_query($db,$sql);
$result_array = array();

while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    $result_array[] = $row;
}

echo json_encode($result_array);

mysqli_close($db);
?>