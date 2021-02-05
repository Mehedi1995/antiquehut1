<?php
include_once("dbconnect.php");
$user_name = $_POST['name'];
$user_email = $_POST['email'];
$user_phone_no = $_POST['phone'];
$user_password = sha1($_POST['password']);
$user_deluaddress=$_POST['DELYADDRESS'];
$otp = rand(1000,9999);


$sqlregister = "INSERT INTO USER(NAME,EMAIL,PHONE,PASSWORD,DELYADDRESS,OTP) VALUES('$user_name','$user_email','$user_phone_no','$user_password','$user_deluaddress','$otp')";

if ($conn->query($sqlregister) === TRUE){
     sendEmail($otp,$user_email);
   
    echo "succes";
}else{
    echo "failed";
}
function sendEmail($otp,$user_email){
    $from = "noreply@antiquehut.com";
    $to = $user_email;
    $subject = "From antiquehut. Verify your account";
    $message = "Use the following link to verify your account :"."\n http://shabab-it.com/antiquehut/php/verify_account.php?email=".$user_email."&key=".$otp;
    $headers = "From:" . $from;
    mail($user_email,$subject,$message, $headers);
}


?>