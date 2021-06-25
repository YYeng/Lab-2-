<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$btryid = $_POST['btryid'];

$sqldelete = "DELETE FROM tbl_cart WHERE user_email='$email' AND battery_id = '$btryid'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>