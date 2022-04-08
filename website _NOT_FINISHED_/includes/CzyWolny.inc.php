<?php

    include_once 'dbh.inc.php';

    $ArrDate = $_POST['przyjazd']
    $DepDate = $_POST['wyjazd']

    $sql = "CALL czyWolne($ArrDate, $DepDate);";

    mysqli_query($conn, $sql);

    header("Location: ../wolnePokoje.html?Search=success");
?>