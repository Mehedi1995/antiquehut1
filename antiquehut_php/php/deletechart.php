<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];
    $sqldelete = "DELETE FROM PRODUCT_ORDER WHERE EMAIL = '$email' AND PRODUCTID='$id'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>