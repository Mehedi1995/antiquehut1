

<?php

include_once("dbconnect.php");
$shopid=$_POST["shopid"];
$shopname=$_POST["shopname"];
$catagory= $_POST["catagory"];
$name = $_POST["productname"];
$phone = $_POST["phone"];
$price= $_POST["price"];
$quantity= $_POST["quantity"];
$location = $_POST["location"];
$image = $_POST["image"];

$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/product_pic/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);

if ($is_written > 0) {
    $sqlregister = "INSERT INTO LOAD_PRODUCT(SHOPID,SHOPNAME,CATAGORY,PRODUCT_NAME,PHONE,PRICE,QUANTITY,LOCATION,IMAGE) VALUES('$shopid','$shopname','$catagory','$name','$phone','$price','$quantity','$location','$image')";
    if ($conn->query($sqlregister) === TRUE){
        
        echo "succes";
    }else{
        echo "failed";
    }
}else{
    echo "failed";
    
}

?>



