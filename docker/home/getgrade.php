<?php
header('Content-Type-type: application/json');
include 'db.php';

$userid = $_GET['userid'];


$sql = "SELECT * FROM discountrate WHERE grade = (SELECT grade FROM user WHERE userID='$userid');";
$result = mysqli_query($db,$sql);

$result_array = array();

while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
    $result_array = $row;
}
echo json_encode($result_array);

mysqli_close($db);

