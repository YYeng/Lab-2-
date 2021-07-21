<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$oldpwd = sha1($_POST['oldpwd']);
$newpwd = sha1($_POST['newpwd']);

$sql = "SELECT * FROM tbl_user WHERE user_email = '$email' AND password = '$oldpwd'";
    
$result = $conn->query($sql);

 if ($result->num_rows > 0) {

    $sqlupdate = "UPDATE tbl_user SET password = '$newpwd' WHERE user_email = '$email'";
    
   if ($conn->query($sqlupdate) === TRUE){
       echo "success";
       
   }else {
       echo "failed";
   }

}else{
    echo "failed";
}


?>