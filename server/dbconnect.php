<?php
$servername = "localhost";
$username = "crimsonw_cvbatteryadmin" ;
$password = "D7+n!Z(Bh)kW";
$dbname = "crimsonw_cvbatterydb";

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}

?>