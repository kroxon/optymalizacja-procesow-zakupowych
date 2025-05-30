CREATE OR REPLACE PROCEDURE reset_and_load_sample_data()
LANGUAGE plpgsql
AS $$
BEGIN

    TRUNCATE TABLE zuzycie RESTART IDENTITY;
    TRUNCATE TABLE dostawy RESTART IDENTITY;
    TRUNCATE TABLE stan_magazynowy RESTART IDENTITY;
    TRUNCATE TABLE min_stany RESTART IDENTITY;
    TRUNCATE TABLE surowce RESTART IDENTITY CASCADE;

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

    UPDATE stan_magazynowy AS sm
    SET ilosc = new_values.ilosc
    FROM (VALUES
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
        (21, 200.00)
    ) AS new_values(id_surowca, ilosc)
    WHERE sm.id_surowca = new_values.id_surowca;

    TRUNCATE TABLE zuzycie RESTART IDENTITY CASCADE;
    TRUNCATE TABLE dostawy RESTART IDENTITY CASCADE;

    INSERT INTO zuzycie (id_surowca, zuzycie, data)
    SELECT s.id, (RANDOM() * 100 + 20)::NUMERIC(10,2), gs.data
    FROM generate_series('2025-01-01'::DATE, '2025-05-29'::DATE, '1 day'::INTERVAL) AS gs(data), surowce s
    WHERE (RANDOM() * 3)::INT >= 1 
    AND s.id <= 21 
ORDER BY
    gs.data, s.id, RANDOM()
LIMIT 5000; 


INSERT INTO dostawy (id_surowca, ilosc, data)
SELECT
    s.id,
    (RANDOM() * 200 + 50)::NUMERIC(10,2), 
    gs.data
FROM
    generate_series('2025-01-01'::DATE, '2025-05-29'::DATE, '1 day'::INTERVAL) AS gs(data),
    surowce s
WHERE
    (RANDOM() * 3)::INT >= 1 
    AND s.id <= 21
ORDER BY
    gs.data, s.id, RANDOM()
LIMIT 5000; 

RAISE NOTICE 'Resetowanie i ładowanie danych przykładowych zakończone pomyślnie.';

    INSERT INTO min_stany (id_surowca, min_ilosc) VALUES
    (1, 50.00),
    (2, 75.00),
    (3, 100.00),
    (4, 125.00),
    (5, 150.00),
    (6, 175.00),
    (7, 200.00);
    
    RAISE NOTICE 'Resetowanie i ładowanie danych przykładowych zakończone pomyślnie.';

END;
$$;