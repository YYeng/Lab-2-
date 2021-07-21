<?php
include_once("dbconnect.php");
$email = $_POST["email"];
$encoded_string = $_POST["encoded_string"];

$sql = "SELECT * FROM tbl_user WHERE user_email = '$email'";
$result = $conn->query($sql);

if($result -> num_rows > 0){
    
    $decoded_string = base64_decode($encoded_string);
    $filename = mysqli_insert_id($conn);
    $path = '../images/'.$filename.'.png';
    $is_written = file_put_contents($path, $decoded_string);
    echo "success";
}else{
    echo "failed";
}

?>