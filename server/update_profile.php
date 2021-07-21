<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];

if(isset($_POST['phoneNo'])){

    $phoneNo = $_POST['phoneNo'];
    
    $sqlupdate = "UPDATE tbl_user SET phone_no = '$phoneNo' WHERE user_email = '$email'";

}elseif (isset($_POST['address'])){

    $address = $_POST['address'];

    $sqlupdate = "UPDATE tbl_user SET address = '$address' WHERE user_email = '$email'";

}


if ($conn->query($sqlupdate) === TRUE){
   
    echo "success";
    
}else{

    echo"failed";

}   
?>