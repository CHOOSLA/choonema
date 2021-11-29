<?php
header('Content-Type-type: application/json');
include 'db.php';

$movieNumber = $_POST['movieNumber'];
$time =$_POST['time'];
$cinemaNumber = $_POST['cinemaNumber'];
$rowNumber = $_POST['row'];
$colNumber = $_POST['col'];
$ab =$_POST['ab'];
$userid =$_POST['userid'];
$reservationDate = $_POST['reservationDate'];
$fee = $_POST['fee'];


echo $fee;

$result = mysqli_query($db,"INSERT INTO reservationSeat VALUES ('$movieNumber','$time','$cinemaNumber','$rowNumber',
'$colNumber','$ab','$userid','$reservationDate','$fee');");

mysqli_close($db);

