<?php
error_reporting(0);
include_once("dbconnect.php");
$user_email = $_POST['email'];
$user_password = sha1($_POST['password']);

$sqllogin = "SELECT * FROM USER WHERE EMAIL = '$user_email' AND PASSWORD = '$user_password' AND OTP = '0'";
$result = $conn->query($sqllogin);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo $data = "success,".$row["NAME"].",".$row["PHONE"].",".$row["DATE"];
    }
}else{
    echo "failed";
}

?>