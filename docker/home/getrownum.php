<?php
header('Content-Type-type: text/plain');
include 'db.php';



$table =  $_GET['table'];


$result = mysqli_query($db,"SELECT * FROM $table;");

echo mysqli_num_rows($result);

mysqli_close($db);

