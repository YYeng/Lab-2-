<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s270737/cvbattery/php/PHPMailer/Exception.php';
require '/home8/crimsonw/public_html/s270737/cvbattery/php/PHPMailer/PHPMailer.php';
require '/home8/crimsonw/public_html/s270737/cvbattery/php/PHPMailer/SMTP.php';

include_once("dbconnect.php");
$user_email = $_POST['email'];
$newpass = random_password(9);
$passha = sha1($newpass);
$newotp = rand(1000,9999);

$sql = "SELECT * FROM tbl_user WHERE user_email = '$user_email'";

    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE tbl_user SET password = '$passha', otp = '$newotp' WHERE user_email = '$user_email'";
        if ($conn->query($sqlupdate) === TRUE){
                echo 'success';
                sendEmail($newotp,$newpass,$user_email);
        }else{
                echo 'failed';
        }
    }else{
        echo "failed";
    }

function sendEmail($otp,$newpass,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'crimsonwebs.com';                         //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'cvbattery@crimsonwebs.com';                  //SMTP username
    $mail->Password   = '*K[B[fMLIUvX';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "cvbattery@crimsonwebs.com";
    $to = $user_email;
    $subject = "From CV Battery. Reset your password ";
    $message = "<p>Your account password has been reset. Please login using the information below.</p><br><br>
                <h3>Password:".$newpass."</h3><br><br>
    <a href='https://crimsonwebs.com/s270737/cvbattery/php/verify_account.php?email=".$user_email."&key=".$otp."'>Click Here to reactivate your account</a>";
    
    $mail->setFrom($from,"CV Batery");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

function random_password($length){
    
    $data = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz';
    $password = '';
    //Get the index of the last character in our $characters string
    $dataListLength = mb_strlen($data, '8bit') - 1;
    //Loop from 1 to the length that was specified
    foreach(range(1,$length) as $i){
        $password .=$data[rand(0,$dataListLength)];
    }
    return $password;
}


?>