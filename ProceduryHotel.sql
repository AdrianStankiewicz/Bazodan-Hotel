/* 1. PROCEDURA SPRAWDZAJĄCA CZY SĄ WOLNE POKOJE */

DELIMITER //

CREATE PROCEDURE wolnePokoje(IN ilosc int, IN poczatek date, IN koniec date)
BEGIN
SELECT 
  r.RoomID AS "Numer pokoju", 
  r.Places AS "Ilosc lozek"
FROM Rooms r LEFT JOIN Bookings b ON r.RoomID = b.RoomID
WHERE 
  NOT EXISTS (
    SELECT 1 FROM Bookings b1
    WHERE 
      b1.RoomID = r.RoomID
      AND (
        poczatek BETWEEN ArrDate AND DepDate
        OR
        koniec BETWEEN ArrDate AND DepDate
        OR
        poczatek <= ArrDate AND koniec >= DepDate
      )
  ) 
AND
  ilosc <= r.Places
GROUP BY r.RoomID;
END //

DELIMITER ;

/* 2. PROCEDURA POKAZUJĄCA WSZYSTKIE USŁUGI KTÓRE ZOSTAŁY DOPIĘTE DO DANEJ REZERWACJI,​ RAZEM Z ICH ŁĄCZNYM KOSZTEM​ */

DELIMITER //

CREATE PROCEDURE BooServ(IN nrRezerwacji int)
BEGIN
SELECT
  se.code AS "Kod uslugi",
  si.Descr AS "Opis uslugi"
FROM (Bookings b
  INNER JOIN Services se ON b.BookID = se.BookID) 
  INNER JOIN ServInfo si ON se.code = si.code
WHERE  nrRezerwacji = b.BookID;

SELECT
  b.BookID AS "Numer",
  SUM(si.price) AS "Cena razem"
FROM Bookings b
  INNER JOIN Services se ON b.BookID = se.BookID 
  INNER JOIN ServInfo si ON se.code = si.code
WHERE b.BookID = nrRezerwacji;
END //

DELIMITER ;

/* 3. PROCEDURA POKAZUJĄCA RENTOWNOŚĆ POKOJÓW */

DELIMITER //

CREATE PROCEDURE rentpok()
BEGIN

SET @ileDni=0;
SET @ileZajetych=0;
SELECT DATEDIFF('2019-01-01',CURDATE())
  INTO @ileDni;

SELECT
  b.RoomID AS "Numer pokoju",
  DATEDIFF(b.ArrDate,b.DepDate)*-1 AS "Dni zajete",
  (@ileDni-DATEDIFF(b.ArrDate,b.DepDate))*(-1) AS "Ilosc dni niezajetych"
FROM Bookings b
GROUP BY b.RoomID;
END //

DELIMITER ;

/* 4. PROCEDURA LICZĄCA KOSZT DANEJ REZERWACJI */

DELIMITER //

CREATE PROCEDURE koszt(IN bookID int)
BEGIN   

SET @room=0.01;
SELECT
  TRUNCATE((DATEDIFF(b.DepDate,b.ArrDate)*r.Price),2) INTO @room
FROM Rooms r
  INNER JOIN Bookings b ON r.RoomID = b.RoomID
WHERE 
  b.BookID = bookID;

SET @stan="Normal";
SELECT
  b.Standard INTO @stan
FROM
  Bookings b
WHERE 
  b.BookID = bookID;

SELECT 
  CASE
    WHEN @stan = "Normal" THEN @room*1.1
    WHEN @stan = "B&B" THEN @room*0.8
    WHEN @stan = "All-Inclusive" THEN @room*2
    WHEN @stan = "Half-Pension" THEN @room*1.2
    WHEN @stan = "Full-Pension" THEN @room*1.5
  END
INTO @room;

SET @serv=0;
SELECT
  TRUNCATE(SUM(si.price),2)+@room into @serv
FROM Bookings b
  INNER JOIN Services se ON b.BookID = se.BookID 
  INNER JOIN ServInfo si ON se.code = si.code
WHERE 
  b.BookID = bookID;

Select 
  bookID AS 'Rezerwacja',
  @serv AS 'Koszt';
END//

DELIMITER ;

/* 5. PROCEDURA ZWRACAJĄCA NAJBARDZIEJ DOCHODOWY MIESIĄC */

DELIMITER //

CREATE PROCEDURE najZysk()
BEGIN
SELECT
  DATE_FORMAT(b.ArrDate, "%Y-%m") AS "Okres",
  SUM(p.Total) AS "Zysk"
FROM Bookings b
  INNER JOIN Payments p ON b.PaymentID = p.PaymentID
GROUP BY DATE_FORMAT(b.ArrDate, '%Y-%m')
ORDER BY SUM(p.Total) DESC
LIMIT 1;
END //

DELIMITER ;

/* 6. PROCEDURA POKAZUJĄCA STATYSTYKI ZAROBKÓW W DANYCH MIESIĄCACH */

DELIMITER //

CREATE PROCEDURE najZyskSt()
BEGIN
SELECT
  DATE_FORMAT(b.ArrDate, "%Y-%m") AS "Okres",
  SUM(p.Total) AS "Zysk"
FROM Bookings b
  INNER JOIN Payments p ON b.PaymentID = p.PaymentID
GROUP BY DATE_FORMAT(b.ArrDate, '%Y-%m')
ORDER BY DATE_FORMAT(b.ArrDate, "%Y-%m");
END //

DELIMITER ;

/* 7. PROCEDURA POKAZUJĄCA Z JAKICH MIEJSCOWOŚCI PRZYJEŻDŻA NAJWIĘCEJ GOŚCI W DANYM OKRESIE */

DELIMITER //

CREATE PROCEDURE najM(IN begDate date,IN endDate date)
BEGIN
SELECT 
  g.City AS "Miasto",
  COUNT(g.GuestID) AS "Ilość gości"
From Guests g 
  INNER JOIN Bookings b ON g.GuestID = b.GuestID
WHERE
  begDate<=b.ArrDate
    AND
  endDate>=b.DepDate
GROUP BY g.City
ORDER BY COUNT(g.GuestID) DESC
LIMIT 3;
END //

DELIMITER ;

/* 8. PROCEDURA POKAZUJĄCA Z JAKICH MIEJSCOWOŚCI PRZYJECHAŁO ILE GOŚCI */

DELIMITER //

CREATE PROCEDURE przyGoscie()
BEGIN
SELECT 
  g.City AS "Miasto",
  COUNT(g.GuestID) AS "Ilosc gosci"
FROM Guests g
GROUP BY g.City
ORDER BY COUNT(g.GuestID) DESC;
END //

DELIMITER ;

/* 9. PROCEDURA POKAZUJĄCA ILU PRACOWNIKÓW JEST Z DANEGO MIASTA */

DELIMITER //

CREATE PROCEDURE ilePzM()
BEGIN
SELECT
  e.City AS "Miasto",
  COUNT(e.WorkID) AS "Ilość pracowników"
FROM Employees e
GROUP BY e.City
ORDER BY COUNT(e.WorkID) DESC;
END //

DELIMITER ;

/* 10. PROCEDURA POKAZUJĄCA NAJCZĘŚCIEJ WYBIERANY STANDARD POKOJU */

DELIMITER //

CREATE PROCEDURE najStandard()
BEGIN
SELECT
  b.Standard AS "Standard",
  COUNT(b.BookID) AS "Ilość rezerwacji"
FROM Bookings b
GROUP BY b.Standard
ORDER BY COUNT(b.BookID) DESC
LIMIT 1;
END //

DELIMITER ;

/* 11. PROCEDURA POKAZUJĄCA ILU HOTEL POSIADA PRACOWNIKÓW RECEPCJI​ */

DELIMITER //

CREATE PROCEDURE ileP()
BEGIN
SELECT COUNT(e.WorkID) AS 'Ilość pracowników hotelu'
FROM Employees e;
END //

DELIMITER ;

/* 12. PROCEDURA POKAZUJĄCA NAJDŁUŻSZY POBYT W HOTELU */

DELIMITER //

CREATE PROCEDURE NajPobyt()
BEGIN
SELECT
  DATEDIFF(b.DepDate,b.ArrDate) AS "Długość pobytu"
FROM Bookings b
ORDER BY DATEDIFF(b.DepDate,b.ArrDate) DESC
LIMIT 1;
END //

DELIMITER ;

/* 13. PROCEDURA POKAZUJĄCA KTÓRY GOŚĆ NAJCZĘŚCIEJ PRZYJEŻDŻA DO HOTELU */ 

DELIMITER //

CREATE PROCEDURE NajGosc()
BEGIN
SELECT 
  g.fName AS "Imie", 
  g.lName AS "Nazwisko", 
  COUNT(b.GuestID) AS "Ilość"
FROM Bookings b
  INNER JOIN Guests g ON b.GuestID = g.GuestID
GROUP BY b.GuestID
ORDER BY COUNT(b.GuestID) DESC
LIMIT 1;
END //

DELIMITER ;

/* 14. PROCEDURA SPRAWDZAJĄCA CZY GOŚĆ JEST W NASZEJ BAZIE DANYCH */

DELIMITER //

CREATE PROCEDURE CzyJestGosc(IN imie varchar(20), IN nazwisko varchar(20))
BEGIN
SELECT 
  g.fName AS "Imie", 
  g.lName AS "Nazwisko",
  g.City AS "Miasto",
  g.PhoneNumber AS "Numer"
FROM Guests g
WHERE
  g.fName=imie
    AND
  g.lName=nazwisko;
END //

DELIMITER ;

/* 15. PROCEDURA POKAZUJĄCA NAJCZĘŚCIEJ WYBIERANY TYP USŁUGI */

DELIMITER //

CREATE PROCEDURE NajUs()
BEGIN
SELECT 
  COUNT(s.BookID) AS "Ilość",
  sf.Descr AS "Opis"
FROM Services s
  INNER JOIN ServInfo sf ON s.code = sf.code
WHERE NOT s.code='KAR'
GROUP BY sf.code
ORDER BY COUNT(s.BookID) DESC
LIMIT 1;
END //

DELIMITER ;

/* 16. PROCEDURA POKAZUJĄCA ZAROBEK W DANYM MIESIĄCU */

DELIMITER //

CREATE PROCEDURE ZarM(IN m int, IN r int)
BEGIN
SELECT 
  SUM(p.Total) AS "Zarobek w Danym Miesiącu"
FROM Bookings b
  INNER JOIN Payments p ON b.PaymentID=p.PaymentID
WHERE MONTH(b.ArrDate)=m AND YEAR(b.ArrDate)=r;
END //

DELIMITER ; 

/* 17. PROCEDURA POKAZUJĄCA NAJCZĘŚCIEJ WYBIERANY POKÓJ */ 

DELIMITER //

CREATE PROCEDURE NajPok()
BEGIN
SELECT
  b.RoomID AS "Nr Pokoju",
  r.Places AS "Wielkość",
  COUNT(b.RoomID) AS "Ilość wybrań"
FROM Rooms r
  INNER JOIN Bookings b ON r.RoomID = b.RoomID
GROUP BY b.RoomID
ORDER BY COUNT(b.RoomID) DESC
LIMIT 1;
END //

DELIMITER ;

/* 18. PROCEDURA POKAZUJĄCA ILOŚĆ REZERWACJI KTÓRE SIĘ ODBYŁY W DANYM MIESIĄCU */ 

DELIMITER //

CREATE PROCEDURE IleR(IN m int, IN r int)
BEGIN
SELECT 
  m AS "Miesiąc",
  COUNT(b.bookID) AS "Ilość rezerwacji"
FROM Bookings b
WHERE MONTH(b.ArrDate)=m AND YEAR(b.ArrDate)=r;
END //

DELIMITER ;

/* 19. PROCEDURA POKAZUJĄCA MIESIĄC W KTÓRYM BYŁO NAJWIĘCEJ ZŁOŻONYCH REZERWACJI */ 

DELIMITER //

CREATE PROCEDURE NajWRez(IN r int)
BEGIN
SELECT
  MONTH(BooDate) AS "Miesiąc",
  COUNT(b.BookID) AS "Ilość"
FROM Bookings b
WHERE YEAR(b.BooDate)=r
GROUP BY MONTH(BooDate)
ORDER BY COUNT(BookID) DESC
LIMIT 1;
END //

DELIMITER ;

/* 20. PROCEDURA POKAZUJĄCA ILE JEST AKTUALNIE GOŚCI W HOTELU */ 

DELIMITER //

CREATE PROCEDURE ileAkGosci()
BEGIN
SET @data=0;
SELECT CURDATE() INTO @data;

SELECT 
  COUNT(BookID) AS "Aktualna ilość gości"
FROM Bookings b
WHERE 
  @data BETWEEN b.ArrDate AND b.DepDate
    AND
  @data BETWEEN b.ArrDate AND b.DepDate;
END //

DELIMITER ;

/* 21. PROCEDURA POKAZUJĄCA JAK CZĘSTO GOŚCIE KORZYSTAJĄ Z DANEJ USŁUGI */ 

DELIMITER //

CREATE PROCEDURE CzestoscUs()
BEGIN
SELECT 
  sf.Descr AS "Opis", 
  COUNT(s.BookID) AS "Ilość"
FROM Services s
  INNER JOIN ServInfo sf ON s.code = sf.code
GROUP BY sf.Descr
ORDER BY COUNT(s.BookID) DESC;
END //

DELIMITER ;

/* 22. PROCEDURA POKAZUJĄCA NAJDROŻSZĄ REZERWACJE */

DELIMITER //

CREATE PROCEDURE NajRez()
BEGIN
SELECT 
  b.BookID AS 'Rezerwacja',
  p.Total AS 'Kwota'
FROM Bookings b
  INNER JOIN Payments p ON b.PaymentID = p.PaymentID
GROUP BY p.Total
ORDER BY p.Total DESC
LIMIT 1;
END //

DELIMITER ;

/* 23. PROCEDURA POKAZUJĄCA ŚREDNI RACHUNEK GOŚCIA HOTELU */ 

DELIMITER //

CREATE PROCEDURE SrRach() 
BEGIN
SELECT 
  ROUND(AVG(p.Total)) AS "Średni rachunek gościa"
FROM Payments p;
END //

DELIMITER ;

/* 24. PROCEDURA POKAZUJĄCA NAJCZĘŚCIEJ WYBIERANY RODZAJ PŁATNOŚCI */

DELIMITER //

CREATE PROCEDURE NajPl() 
BEGIN
SELECT 
  p.Way AS "Typ płatności", 
  count(p.PaymentID) AS "Ilość wybrań"
FROM Payments p
GROUP BY p.Way
ORDER BY count(p.PaymentID) DESC
LIMIT 1;
END //

DELIMITER ;

/* 25. PROCEDURA POKAZUJĄCA ŚREDNIE WYDATKI GOŚCIA HOTELU NA USŁUGI */

DELIMITER //

CREATE PROCEDURE SrKosztUs() 
BEGIN
SELECT 
  ROUND(AVG(sf.price)) AS "Średnie wydatki gości na usługi"
FROM Services s
  INNER JOIN ServInfo sf ON s.code = sf.code;
END //

DELIMITER ;
