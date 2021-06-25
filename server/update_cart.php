<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$btryid = $_POST['btryid'];
$op = $_POST['op'];
$qty = $_POST['qty'];

if ($op == "addcart") {
    $sqlupdatecart = "UPDATE tbl_cart SET cartqty = cartqty +1 WHERE battery_id = '$btryid ' AND user_email = '$email'";
    if ($conn->query($sqlupdatecart) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
}
if ($op == "removecart") {
    if ($qty == 1) {
        echo "failed";
    } else {
        $sqlupdatecart = "UPDATE tbl_cart SET cartqty = cartqty -1 WHERE battery_id = '$btryid '  AND user_email = '$email'";
        if ($conn->query($sqlupdatecart) === TRUE) {
            echo "success";
        } else {
            echo "failed";
        }
    }
}
?>