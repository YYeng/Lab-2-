<?php
include_once("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$messages = $_POST['messages'];


$sqlinsert = "INSERT INTO tbl_message(user_name, email, messages) VALUES('$name','$email','$messages')";
if ($conn->query($sqlinsert) === TRUE){
   
    echo "success";
    
}else{

    echo "failed";
}

?>