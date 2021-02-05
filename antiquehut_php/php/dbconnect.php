<?php
$servername = "localhost";
$username   = "shababit_antique";
$password   = "OhUZY=vUQPi=";
$dbname     = "shababit_antiquehut";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>