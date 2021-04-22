<?php


use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s270737/cvbattery/php/PHPMailer/Exception.php';
require '/home8/crimsonw/public_html/s270737/cvbattery/php/PHPMailer/PHPMailer.php';
require '/home8/crimsonw/public_html/s270737/cvbattery/php/PHPMailer/SMTP.php';

include_once("dbconnect.php");
$username = $_POST['userName'];
$user_email = $_POST['user_email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);

$sqlsignup = "INSERT INTO tbl_user(user_name,user_email,password,otp) VALUES('$username','$user_email','$passha1','$otp')";

if ($conn->query($sqlsignup) === TRUE){
   
    echo "success";
    sendEmail($otp,$user_email);
    
}else{
    echo"failed";
}

    function sendEmail($otp,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'crimsonwebs.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'cvbattery@crimsonwebs.com';                  //SMTP username
    $mail->Password   = '*K[B[fMLIUvX';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "cvbattery@crimsonwebs.com";
    $to = $user_email;
    $subject = "From CV Battery. Please Verify your account";
    $message = "<p>Click the following link to verify your account<br><br>
    <a href='https://crimsonwebs.com/s270737/cvbattery/php/verify_account.php?email=".$user_email."&key=".$otp."'>Click Here</a>";
    
    $mail->setFrom($from,"CV Battery");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
    }

?>