<?php
 
include_once("dbconnect.php");
$namebattery = $_POST['namebattery'];

if ($namebattery == "all"){
    $sql = "SELECT * FROM tbl_batteries ORDER BY battery_id DESC";
    
}else{
    $sql = "SELECT * FROM tbl_batteries WHERE name_battery LIKE '%$namebattery %' ORDER BY battery_id DESC";
}


 $result = $conn->query($sql);

if ($result->num_rows > 0){
    $products["products"] = array();
    while ($row = $result -> fetch_assoc()){
       
        $prlist['battery_id'] = $row['battery_id'];
        $prlist['name_battery'] = $row['name_battery'];
        $prlist['vehicle_type'] = $row['vehicle_type'];
        $prlist['price'] = $row['price'];
        $prlist['quantity']= $row['quantity'];
        $prlist['picture'] =  '/cvbattery/images/' .$row['picture'];
        $prlist['warranty_months']= $row['warranty_months'];
    
       array_push($products['products'] , $prlist);
    }

   echo json_encode($products);

}else{
     echo "nodata";
}
?>