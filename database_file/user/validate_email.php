<?php

include '../connection.php';

$userEmail = $_POST['user_email'];

$sqlQuery = "SELECT * FROM users_table WHERE user_email = '$userEmail'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) {
    //num rows length == 1 --- email already in someone slse use --- Error
    echo json_encode(array("emailFound"=>true));
}
else {
    //num rows length == 0 --- email is NOT already in someone slse use
    // a user will allow to signUp successfully
    echo json_encode(array("emailFound"=>false));
}