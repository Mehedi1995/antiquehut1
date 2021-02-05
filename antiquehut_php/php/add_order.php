<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];
$qty = $_POST['qty'];




$sqlcheck = "SELECT * FROM PRODUCT_ORDER WHERE PRODUCTID = '$id' AND EMAIL = '$email'";
$result = $conn->query($sqlcheck);
if ($result->num_rows > 0) {
    $sqlupdate = "UPDATE PRODUCT_ORDER SET PRODUCTQTY = '$qty'  WHERE PRODUCTID = '$id' AND EMAIL = '$email'";
    if ($conn->query($sqlupdate) === TRUE){
       echo "success";
    }  
}else{

    $sqlinsert = "INSERT INTO PRODUCT_ORDER(EMAIL,PRODUCTID,PRODUCTQTY) VALUES ('$email','$id','$qty')";
    if ($conn->query($sqlinsert) === TRUE){
       echo "success";
    } else{
        echo "faild";
    }   
}

?>