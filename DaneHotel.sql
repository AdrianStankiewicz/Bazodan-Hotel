/* Trigger do liczenia Total w Platnosciach */

DELIMITER //

  CREATE TRIGGER t_Payments BEFORE INSERT ON Payments
  FOR EACH ROW
    BEGIN

/* Ciagniemy numer rezerwacji (ZALOZENIE: TYLKO JEDNO ZRODLO ROBIENIA REZERWACJI) */

  SET @bookID=0;
  SELECT
    b.BookID INTO @bookID
  FROM Bookings b
  ORDER BY b.BookID DESC
  LIMIT 1;
        
/* Sam pokój */

  SET @room=0.01;
  SELECT
    TRUNCATE((DATEDIFF(b.DepDate,b.ArrDate)*r.Price),2) INTO @room
  FROM Rooms r
    INNER JOIN Bookings b ON r.RoomID = b.RoomID
  WHERE 
    b.BookID = @bookID;

/* Wyciągamy standard */

  SET @stan="Normal";
  SELECT
    b.Standard INTO @stan
  FROM
    Bookings b
  WHERE 
    b.BookID = @bookID;

/* Liczenie Standardu */

  SELECT 
    CASE
      WHEN @stan = "Normal" THEN @room*1.1
      WHEN @stan = "B&B" THEN @room*0.8
      WHEN @stan = "All-Inclusive" THEN @room*2
      WHEN @stan = "Half-Pension" THEN @room*1.2
      WHEN @stan = "Full-Pension" THEN @room*1.5
    END
  INTO @room;

/* Calosc Uslug */

  SET @serv=0;
  SELECT
    TRUNCATE(SUM(si.price),2) INTO @serv
  FROM Bookings b
    INNER JOIN Services se ON b.BookID = se.BookID 
    INNER JOIN ServInfo si ON se.code = si.code
  WHERE 
    b.BookID = @bookID;

/* Kod wbicia w Payments Total*/

  SET NEW.Total = @room+@serv;
  END //

DELIMITER ;

/* Dane do Pracownikow */

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Adam','Nowak','Recepcjonista','309346631','Jana Pustelnika 13B','Wejherowo');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Malgorzata','Kowalczyk','Recepcjonistka','764843913','Koronkarska 1','Poznan');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Bartek','Wisniewski','Recepcjonista','914063807','Slemien 108','Slemien');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Jeremi','Zieba','Recepcjonista','388688116','Zaulek 2','Rzeszow');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Aleksander','Majewski','Recepcjonista','626079841','Odrodzenia 12','Raciborz');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Julia','Jablonska','Recepcjonistka','934299245','Ziemska 66','Szczecin');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Michal','Majewski','Recepcjonista','407984800','Pasterska 68','Dodz');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Anna','Golebiowska','Recepcjonistka','466034212','Grzegorza Dekarza 13B','Wejherowo');

INSERT  INTO Employees (fName, lName, Position, PhoneNumber, Address, City)
VALUES ('Noemi','Szymanska','Recepcjonistka','829043221','Marka Ancymona 13B','Wejherowo');

/* Dane do Pokojow */

INSERT INTO Rooms (PLaces, price, AC)
VALUES (1, '100', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (1, '100', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (1, '100', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (1, '100', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (2, '200', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (2, '200', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (2, '200', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (2, '200', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (3, '300', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (3, '300', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (3, '300', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (3, '300', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (4, '400', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (4, '400', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (4, '400', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (4, '400', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (5, '500', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (5, '500', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (5, '500', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (5, '500', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (6, '600', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (6, '600', 'Tak');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (6, '600', 'Nie');

INSERT INTO Rooms (PLaces, price, AC)
VALUES (6, '600', 'Nie');

/* Dane do Gościa */

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Dawid', 'Wasielke', 'Rumia',886526789);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Janoz', 'Nozownik', 'Sosnowiec', 975312468);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Kuba', 'Rozprowacz', 'Londyn', 198321854);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Michael', 'Wisla', 'Koszalin', 882650937);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Bobby', 'De Montownik', 'Compiegne', 123654879);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Pioter', 'Pajecznik', 'Sosnowiec', 975333293);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Andy', 'Chudysiewicz', 'New York', 776357912);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Zbigniew', 'Kowalski', 'Gdynia', 777326182);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Dawid', 'Nowak', 'Sopot', 999765424);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Remigiusz', 'Kocialski', 'Zakopane', 462873737);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Janusz', 'Andrzejak', 'New York', 232434532);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Tadeusz', 'Adamowski', 'Gdynia', 647274626);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Kamil', 'Bartyzel', 'Gdynia', 847284824);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Andy', 'Aleksandrowicz', 'Praga', 930323032);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Anton', 'Badowski', 'Berlin', 672378872);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('John', 'Arctowski', 'New York', 436772626);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Janusz', 'Garbowski', 'Sopot', 632727272);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Zbigniew', 'Kocialski', 'New York', 303920322);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Paulina', 'Gawlik', 'Gdynia', 403400433);

INSERT INTO Guests (fName, lName, City, PhoneNumber)
VALUES ('Karolina', 'Gardocka', 'Zakopane', 132940424);

/* Dane do UslugiInfo*/

INSERT INTO ServInfo (code,price,descr)
VALUES ('KAR','10','Wyrobienie karty pokojowej.');

INSERT INTO ServInfo (code,price,descr)
VALUES ('PAR','20','Miejsce parkingowe w podziemnej hali parkingowej.');

INSERT INTO ServInfo (code,price,descr)
VALUES ('ROW','50','Elegancki rower elektryczny, idealny do zwiedzania okolicy.');

INSERT INTO ServInfo (code,price,descr)
VALUES ('SPO','1000','Samochod sportowy wraz z miejscem parkingowym w podziemnej hali parkingowej.');

INSERT INTO ServInfo (code,price,descr)
VALUES ('SUV','1000','Samochod terenowy wraz z miejscem parkingowym w podziemnej hali parkingowej.');

INSERT INTO ServInfo (code,price,descr)
VALUES ('BEZ','1000','Samochod kabriolet wraz z miejscem parkingowym w podziemnej hali parkingowej.');

INSERT INTO ServInfo (code,price,descr)
VALUES ('NOR','1000','Samochod rodzinny wraz z miejscem parkingowym w podziemnej hali parkingowej.');

/* Dane do Rezerwacji *//* Dane do Uslugi *//* Dane do Platnosci */

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (1,3,2,1,'All-Inclusive',"2019-01-01","2019-01-05","2019-01-12");

INSERT INTO Services (BookID, code)
VALUES (1, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (1, 'PAR');

INSERT INTO Services (BookID, code)
VALUES (1, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (1, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (1, 'SPO');

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (2,2,8,2,'Normal',"2019-01-21","2019-01-27","2019-01-28");

INSERT INTO Services (BookID, code)
VALUES (2, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (2, 'PAR');

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (3,6,1,3,'B&B',"2019-03-11","2019-03-21","2019-03-30");

INSERT INTO Services (BookID, code)
VALUES (3, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (3, 'SUV');

INSERT INTO Services (BookID, code)
VALUES (3, 'ROW');

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (4,4,3,4,'Full-Pension',"2019-03-11","2019-03-22","2019-03-28");

INSERT INTO Services (BookID, code)
VALUES (4, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (4, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (4, 'ROW');

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (5,4,20,5,'Normal',"2019-04-27","2019-04-28","2019-04-30");

INSERT INTO Services (BookID, code)
VALUES (5, "KAR");

INSERT INTO Services (BookID, code)
VALUES (5, "BEZ");

INSERT INTO Services (BookID, code)
VALUES (5, "NOR");

INSERT INTO Services (BookID, code)
VALUES (5, "NOR");

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (6,9,14,6,'B&B',"2019-04-28","2019-05-03","2019-05-23");

INSERT INTO Services (BookID, code)
VALUES (6, "KAR");

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (7,7,15,7,'Half-Pension',"2019-05-09","2019-05-11","2019-05-17");

INSERT INTO Services (BookID, code)
VALUES (7, "KAR");

INSERT INTO Services (BookID, code)
VALUES (7, "NOR");

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (8,1,9,8,'Full-Pension',"2019-05-18","2019-05-25","2019-05-28");

INSERT INTO Services (BookID, code)
VALUES (8, "KAR");

INSERT INTO Services (BookID, code)
VALUES (8, "ROW");

INSERT INTO Services (BookID, code)
VALUES (8, "ROW");

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (9,3,11,9,'Normal',"2019-05-27","2019-06-01","2019-06-07");

INSERT INTO Services (BookID, code)
VALUES (9, "KAR");

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (10,5,13,10,'All-Inclusive',"2019-05-29","2019-06-05","2019-06-28");

INSERT INTO Services (BookID, code)
VALUES (10, "KAR");

INSERT INTO Services (BookID, code)
VALUES (10, "SUV");

INSERT INTO Services (BookID, code)
VALUES (10, "ROW");

INSERT INTO Services (BookID, code)
VALUES (10, "ROW");

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (1,8,9,11,'B&B',"2019-07-02","2019-07-09","2019-07-11");

INSERT INTO Services (BookID, code)
VALUES (11, "KAR");

INSERT INTO Services (BookID, code)
VALUES (11, "SUV");

INSERT INTO Services (BookID, code)
VALUES (11, "SUV");

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (3,3,18,12,'Normal',"2019-07-09","2019-07-19","2019-07-28");

INSERT INTO Services (BookID, code)
VALUES (12, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (12, "SUV");

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (10,1,1,13,'Normal',"2019-08-05","2019-08-06","2019-08-10");

INSERT INTO Services (BookID, code)
VALUES (13, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (13, 'SUV');

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (8,2,8,14,'B&B',"2019-08-17","2019-08-19","2019-08-23");

INSERT INTO Services (BookID, code)
VALUES (14, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (14, "ROW");

INSERT INTO Services (BookID, code)
VALUES (14, "ROW");

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (5,3,3,15,'All-Inclusive',"2019-08-27","2019-09-16","2019-09-29");

INSERT INTO Services (BookID, code)
VALUES (15, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (15, "SPO");

INSERT INTO Services (BookID, code)
VALUES (15, "SPO");

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (9,4,5,16,'Half-Pension',"2019-08-29","2019-09-11","2019-09-16");

INSERT INTO Services (BookID, code)
VALUES (16, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (16, "BEZ");

INSERT INTO Services (BookID, code)
VALUES (16, "NOR");

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (1,5,5,17,'Full-Pension',"2019-09-27","2019-10-17","2019-10-29");

INSERT INTO Services (BookID, code)
VALUES (17, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (17, 'PAR');

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (2,6,20,18,'B&B',"2019-10-01","2019-10-16","2019-10-26");

INSERT INTO Services (BookID, code)
VALUES (18, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (18, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (18, 'SPO');

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (3,7,15,19,'Full-Pension',"2019-11-02","2019-11-17","2019-11-19");

INSERT INTO Services (BookID, code)
VALUES (19, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (19, 'SPO');

INSERT INTO Services (BookID, code)
VALUES (19, 'NOR');

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (5,7,8,20,'Full-Pension',"2019-11-21","2019-11-28","2019-11-30");

INSERT INTO Services (BookID, code)
VALUES (20, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (20, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (20, 'SUV');

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (5,8,4,21,'Half-Pension',"2019-12-23","2019-12-24","2019-12-28");

INSERT INTO Services (BookID, code)
VALUES (21, 'KAR');

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (11,5,13,22,'All-Inclusive',"2020-01-03","2020-01-11","2020-01-28");

INSERT INTO Services (BookID, code)
VALUES (22, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (22, 'PAR');

INSERT INTO Services (BookID, code)
VALUES (22, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (22, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (22, 'SPO');

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (12,8,9,23,'B&B',"2020-02-02","2020-02-09","2020-02-11");

INSERT INTO Services (BookID, code)
VALUES (23, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (23, 'PAR');

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (13,3,18,24,'Normal',"2020-03-09","2020-03-19","2020-03-28");

INSERT INTO Services (BookID, code)
VALUES (24, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (24, 'SUV');

INSERT INTO Services (BookID, code)
VALUES (24, 'ROW');

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (14,1,1,25,'Normal',"2020-04-05","2020-04-06","2020-04-10");

INSERT INTO Services (BookID, code)
VALUES (25, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (25, 'ROW');

INSERT INTO Services (BookID, code)
VALUES (25, 'ROW');

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (15,2,8,26,'B&B',"2020-05-17","2020-05-19","2020-05-23");

INSERT INTO Services (BookID, code)
VALUES (26, "KAR");

INSERT INTO Services (BookID, code)
VALUES (26, "BEZ");

INSERT INTO Services (BookID, code)
VALUES (26, "NOR");

INSERT INTO Services (BookID, code)
VALUES (26, "NOR");

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (16,3,3,27,'All-Inclusive',"2020-06-01","2020-06-16","2020-06-29");

INSERT INTO Services (BookID, code)
VALUES (27, "KAR");

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (17,4,5,28,'Half-Pension',"2020-07-07","2020-07-11","2020-07-16");

INSERT INTO Services (BookID, code)
VALUES (28, "KAR");

INSERT INTO Services (BookID, code)
VALUES (28, "NOR");

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (18,5,5,29,'Full-Pension',"2020-08-14","2020-08-17","2020-08-29");

INSERT INTO Services (BookID, code)
VALUES (29, "KAR");

INSERT INTO Services (BookID, code)
VALUES (29, "ROW");

INSERT INTO Services (BookID, code)
VALUES (29, "ROW");

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (19,6,20,30,'B&B',"2020-09-01","2020-09-16","2020-09-26");

INSERT INTO Services (BookID, code)
VALUES (30, "KAR");

INSERT INTO Payments (Way)
VALUES ('Przelew');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (20,7,15,31,'Full-Pension',"2020-10-02","2020-10-17","2020-10-19");

INSERT INTO Services (BookID, code)
VALUES (31, "KAR");

INSERT INTO Services (BookID, code)
VALUES (31, "SUV");

INSERT INTO Services (BookID, code)
VALUES (31, "ROW");

INSERT INTO Payments (Way)
VALUES ('Gotowka');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (11,7,8,32,'Full-Pension',"2020-11-21","2020-11-28","2020-11-30");

INSERT INTO Services (BookID, code)
VALUES (32, "KAR");

INSERT INTO Services (BookID, code)
VALUES (32, "SUV");

INSERT INTO Services (BookID, code)
VALUES (32, "SUV");

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (12,8,4,33,'Half-Pension',"2020-12-23","2020-12-24","2020-12-28");

INSERT INTO Services (BookID, code)
VALUES (33, 'KAR');

INSERT INTO Payments (Way)
VALUES ('Karta');

INSERT INTO Bookings (GuestID, WorkID, RoomID, PaymentID, Standard, BooDate, ArrDate, DepDate)
VALUES (20,5,7,34,'Half-Pension',"2020-12-26","2020-12-27","2020-12-30");

INSERT INTO Services (BookID, code)
VALUES (34, 'KAR');

INSERT INTO Services (BookID, code)
VALUES (34, 'PAR');

INSERT INTO Services (BookID, code)
VALUES (34, 'ROW');

INSERT INTO Payments (Way)
VALUES ('Przelew');

