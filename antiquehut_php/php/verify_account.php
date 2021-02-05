<?php
    error_reporting(0);
    include_once("dbconnect.php");
    $user_email = $_GET['email'];
    $otp = $_GET['key'];
    
    $sql = "SELECT * FROM USER WHERE EMAIL = '$user_email'";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE USER SET OTP = '0' WHERE EMAIL = '$user_email' AND OTP = '$otp'";
        if ($conn->query($sqlupdate) === TRUE){
            echo 'success';
        }else{
            echo 'failed';
        }   
    }else{
        echo "failed";
    }
    
    
?>