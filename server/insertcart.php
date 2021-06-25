<?php
 
include_once("dbconnect.php");

$email = $_POST['email'];
$batteryid = $_POST['batteryid'];

$sqlcheckcart = "SELECT * FROM tbl_batteries WHERE battery_id = '$batteryid' "; 
//check battery in stock

$resultstock = $conn->query($sqlcheckcart);

if ($resultstock->num_rows > 0) {
     while ($row = $resultstock ->fetch_assoc()){
        $quantity = $row['quantity'];
        if ($quantity == 0) { //product is out of stock
            echo "failed"; 
            return;
        } else {
           echo $sqlcheckcart = "SELECT * FROM tbl_cart WHERE battery_id = '$batteryid' AND user_email = '$email'";         
          //check if the product is already in cart

            $resultcart = $conn->query($sqlcheckcart);
            if ($resultcart->num_rows == 0) {
           //product is not in the cart proceed with insert new
                 echo $sqladdtocart = "INSERT INTO tbl_cart (user_email, battery_id, cartqty) VALUES ('$email','$batteryid','1')";

                if ($conn->query($sqladdtocart) === TRUE) {
                    echo "success";
                } else {
                    echo "failed";
                }
            } else { 
               //if the product is in the cart, proceed with update
                echo $sqlupdatecart = "UPDATE tbl_cart SET cartqty = cartqty  +1 WHERE battery_id = '$batteryid' AND user_email = '$email'";
                if ($conn->query($sqlupdatecart) === TRUE) {
                    echo "success";
                } else {
                    echo "failed";
                }
            }
        }
    }
}else{
    echo "failed";
}
?>