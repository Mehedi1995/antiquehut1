<?php
error_reporting(0);
include_once("dbconnect.php");
$sql = "SELECT * FROM LOAD_PRODUCT";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
 $response["rest"] = array();
while ($row = $result ->fetch_assoc()){
 $products = array();
 $products[shopid] = $row["SHOPID"];
 $products[shopname] = $row["SHOPNAME"];
 $products[id] = $row["PRODUCT_ID"];
 $products[catagory] = $row["CATAGORY"];
 $products[name] = $row["PRODUCT_NAME"];
 $products[phone] = $row["PHONE"];
 $products[quantity] = $row["QUANTITY"];
 $products[price] = $row["PRICE"];
 $products[location] = $row["LOCATION"];
 $products[image] = $row["IMAGE"];
 array_push($response["rest"], $products);
}
 echo json_encode($response);
}else{
 echo "nodata";
}
?> 