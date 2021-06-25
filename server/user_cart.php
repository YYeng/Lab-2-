<?php
include_once("dbconnect.php");

$email = $_POST['email'];

$sqlloadcart = "SELECT * FROM tbl_cart INNER JOIN tbl_batteries ON tbl_cart.battery_id = tbl_batteries.battery_id WHERE tbl_cart.user_email = '$email' ";

$result = $conn->query($sqlloadcart);

if ($result->num_rows > 0) {
    $pr['cart'] = array();

    while ($row = $result->fetch_assoc()) {

       $prlist['battery_id'] = $row['battery_id'];
        $prlist['name_battery'] = $row['name_battery'];
        $prlist['vehicle_type'] = $row['vehicle_type'];
        $prlist['price'] = $row['price'];
        $prlist['quantity']= $row['quantity'];
        $prlist['cartqty'] = $row['cartqty'];
        $prlist['picture'] =  '/cvbattery/images/' .$row['picture'];
        $prlist['warranty_months']= $row['warranty_months'];
    
       array_push($pr['cart'] , $prlist);
    }
    echo json_encode($pr);

} else {
    echo "nodata";
}

?>