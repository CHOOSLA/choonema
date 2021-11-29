<?php
header('Content-Type-type: application/json');
include 'db.php';

$cinemaNumber = $_GET['cinemaNumber'];
$rowNumber = $_GET['row'];
$colNumber = $_GET['col'];
$ab =$_GET['ab'];
$time =$_GET['time'];


echo $time;

$result = mysqli_query($db,"INSERT INTO cinemaSeat VALUES ('$cinemaNumber','$rowNumber','$colNumber','$ab','$time');");

mysqli_close($db);

