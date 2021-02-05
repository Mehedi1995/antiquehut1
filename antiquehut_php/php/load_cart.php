<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

//$sql = "SELECT * FROM CART WHERE EMAIL = '$email'";

$sql = "SELECT PRODUCT_ORDER.PRODUCTID, PRODUCT_ORDER.PRODUCTQTY, LOAD_PRODUCT.CATAGORY, LOAD_PRODUCT.PRODUCT_NAME,LOAD_PRODUCT.PRICE,LOAD_PRODUCT.IMAGE  
FROM PRODUCT_ORDER 
INNER JOIN LOAD_PRODUCT ON LOAD_PRODUCT.PRODUCT_ID = PRODUCT_ORDER.PRODUCTID
WHERE PRODUCT_ORDER.EMAIL = '$email'";


$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["cart"] = array();
    while ($row = $result ->fetch_assoc()){
        $cartlist = array();
        $cartlist[id] = $row["PRODUCTID"];
       
        $cartlist[catagory] = $row["CATAGORY"];
        $cartlist[qty] = $row["PRODUCTQTY"];
        $cartlist[name] = $row["PRODUCT_NAME"];
        $cartlist[price] = $row["PRICE"];
        
       
         $cartlist[image] = $row["IMAGE"];
 
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>