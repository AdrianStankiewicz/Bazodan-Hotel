<?php

    include_once 'dbh.inc.php';

    #Tworzymy zmienną *$nazwa*, która jest równa zmiennej o nazwie kwota przekazanej przez FORM z POSTu, nazwa zmiennej z POSTu to "name=..."
        $total = $_POST['kwota'];
        $way = $_POST['sposob'];
    #Tu wbijamy do zmiennej kwerendę jaką chcemy wykonać
        $sql = "INSERT INTO payments (Total, Way) VALUES ('$total', '$way');";
    
    #mysqli_query przekazuje kwerendę do wykonania bazie MySQL
        mysqli_query($conn, $sql);
    
    #header ustawia drogę po wykonaniu kodu, ../ cofa o folder w tył, ?pokazuje jakiś komunikat
        header("Location: ../index.html?Payment=success");
?>