INSERT INTO surowce (nazwa, jednostka_zakupu, jednostka_miary) VALUES
('Stal', 7850.00, 'kg'),
('Aluminium', 2700.00, 'kg'),
('Miedź', 8960.00, 'kg'),
('Cynk', 7135.00, 'kg'),
('Ołów', 11340.00, 'kg'),
('Magnez', 1740.00, 'kg'),
('Tytan', 4500.00, 'kg'),
('Nikiel', 8908.00, 'kg'),
('Węgiel', 1600.00, 'kg'),
('Srebro', 10490.00, 'kg'),
('Kwas siarkowy', 1840.00, 'l'),
('Aceton', 790.00, 'l'),
('Etanol', 789.00, 'l'),
('Gliceryna', 1260.00, 'l'),
('Amoniak', 682.00, 'l'),
('Sód', 968.00, 'l'),
('Kwas solny', 1185.00, 'l'),
('Kwas azotowy', 1420.00, 'l'),
('Kwas fosforowy', 10.00, 'kg'),
('Kwas octowy', 1040.00, 'l'),
('Kwas cytrynowy', 1.00, 'kg');

INSERT INTO stan_magazynowy (id_surowca, ilosc) VALUES
(1, 100.00),
(2, 150.00),
(3, 200.00),
(4, 250.00),
(5, 300.00),
(6, 350.00),
(7, 400.00),
(8, 450.00),
(9, 500.00),
(10, 550.00),
(11, 600.00),
(12, 650.00),
(13, 700.00),
(14, 750.00),
(15, 800.00),
(16, 850.00),
(17, 900.00),
(18, 950.00),
(19, 1000.00),
(20, 1050.00),
(21, 200);

INSERT INTO zuzycie (id_surowca, zuzycie, data) VALUES
(1, 100.00, '2023-01-15'),
(2, 50.00, '2023-01-16'),
(3, 200.00, '2023-01-17'),
(4, 75.00, '2023-01-18'),
(5, 30.00, '2023-01-19'),
(6, 120.00, '2023-01-20'),
(7, 90.00, '2023-01-21'),
(8, 60.00, '2023-01-22'),
(9, 150.00, '2023-01-23'),
(10, 80.00, '2023-01-24'),
(11, 40.00, '2023-01-25'),
(12, 110.00, '2023-01-26'),
(13, 70.00, '2023-01-27'),
(14, 130.00, '2023-01-28'),
(15, 55.00, '2023-01-29'),
(16, 95.00, '2023-01-30'),
(17, 85.00, '2023-02-01'),
(18, 45.00, '2023-02-02'),
(19, 135.00, '2023-02-03'),
(20, 65.00, '2023-02-04'),
(1, 150.00, '2023-02-05'),
(2, 80.00, '2023-02-06'),
(3, 120.00, '2023-02-07'),
(4, 90.00, '2023-02-08'),
(5, 60.00, '2023-02-09'),
(6, 100.00, '2023-02-10'),
(7, 70.00, '2023-02-11'),
(8, 130.00, '2023-02-12'),
(9, 40.00, '2023-02-13'),
(10, 110.00, '2023-02-14'),
(11, 50.00, '2023-02-15'),
(12, 140.00, '2023-02-16'),
(13, 75.00, '2023-02-17'),
(14, 95.00, '2023-02-18'),
(15, 55.00, '2023-02-19'),
(16, 85.00, '2023-02-20'),
(17, 45.00, '2023-02-21'),
(18, 135.00, '2023-02-22'),
(19, 65.00, '2023-02-23'),
(20, 150.00, '2023-02-24'),
(1, 80.00, '2023-02-25'),
(2, 120.00, '2023-02-26'),
(3, 90.00, '2023-02-27'),
(4, 60.00, '2023-02-28'),
(5, 100.00, '2023-03-01'),
(6, 70.00, '2023-03-02'),
(7, 130.00, '2023-03-03'),
(8, 40.00, '2023-03-04'),
(9, 110.00, '2023-03-05'),
(10, 50.00, '2023-03-06'),
(11, 140.00, '2023-03-07'),
(12, 75.00, '2023-03-08'),
(13, 95.00, '2023-03-09'),
(14, 55.00, '2023-03-10'),
(15, 85.00, '2023-03-11'),
(16, 45.00, '2023-03-12');

INSERT INTO dostawy (id_surowca, ilosc, data) VALUES
(1, 200.00, '2023-01-10'),
(2, 100.00, '2023-01-11'),
(3, 300.00, '2023-01-12'),
(4, 150.00, '2023-01-13'),
(5, 60.00, '2023-01-14'),
(6, 250.00, '2023-01-15'),
(7, 180.00, '2023-01-16'),
(8, 120.00, '2023-01-17'),
(9, 400.00, '2023-01-18'),
(10, 200.00, '2023-01-19'),
(11, 90.00, '2023-01-20'),
(12, 220.00, '2023-01-21'),
(13, 130.00, '2023-01-22'),
(14, 300.00, '2023-01-23'),
(15, 70.00, '2023-01-24'),
(16, 160.00, '2023-01-25'),
(17, 140.00, '2023-01-26'),
(18, 80.00, '2023-01-27'),
(19, 350.00, '2023-01-28'),
(20, 190.00, '2023-01-29'),
(1, 220.00, '2023-02-01'),
(2, 130.00, '2023-02-02'),
(3, 170.00, '2023-02-03'),
(4, 110.00, '2023-02-04'),
(5, 90.00, '2023-02-05'),
(6, 140.00, '2023-02-06'),
(7, 160.00, '2023-02-07'),
(8, 200.00, '2023-02-08'),
(9, 300.00, '2023-02-09'),
(10, 150.00, '2023-02-10'),
(11, 80.00, '2023-02-11'),
(12, 190.00, '2023-02-12'),
(13, 120.00, '2023-02-13'),
(14, 250.00, '2023-02-14'),
(15, 100.00, '2023-02-15'),
(16, 130.00, '2023-02-16'),
(17, 110.00, '2023-02-17'),
(18, 70.00, '2023-02-18'),
(19, 180.00, '2023-02-19'),
(20, 160.00, '2023-02-20'),
(1, 210.00, '2023-03-01'),
(2, 140.00, '2023-03-02'),
(3, 190.00, '2023-03-03'),
(4, 130.00, '2023-03-04'),
(5, 80.00, '2023-03-05'),
(6, 170.00, '2023-03-06');

INSERT INTO min_stany (id_surowca, min_ilosc) VALUES
(1, 50.00),
(2, 75.00),
(3, 100.00),
(4, 125.00),
(5, 150.00);