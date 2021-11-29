<?php
header('Content-Type-type: application/json');
include 'db.php';

$id = $_POST['id'];
$password = $_POST['password'];
$username = $_POST['username'];
$phone = $_POST['phone'];
$card =$_POST['card'];



$result = mysqli_query($db,"INSERT INTO user VALUES ('$id',SHA2('$password',256),'$username','$phone','SILVER','$card');");

mysqli_close($db);

