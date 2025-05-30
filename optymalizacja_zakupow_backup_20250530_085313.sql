--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: aktualizuj_stan_magazynowy_po_dostawie(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aktualizuj_stan_magazynowy_po_dostawie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM stan_magazynowy WHERE id_surowca = NEW.id_surowca) THEN
        UPDATE stan_magazynowy
        SET ilosc = ilosc + NEW.ilosc
        WHERE id_surowca = NEW.id_surowca;
    ELSE
        INSERT INTO stan_magazynowy (id_surowca, ilosc)
        VALUES (NEW.id_surowca, NEW.ilosc);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.aktualizuj_stan_magazynowy_po_dostawie() OWNER TO postgres;

--
-- Name: aktualizuj_stan_magazynowy_po_zuzyciu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aktualizuj_stan_magazynowy_po_zuzyciu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM stan_magazynowy WHERE id_surowca = NEW.id_surowca) THEN
        UPDATE stan_magazynowy
        SET ilosc = ilosc - NEW.zuzycie  
        WHERE id_surowca = NEW.id_surowca;
    ELSE
        INSERT INTO stan_magazynowy (id_surowca, ilosc)
        VALUES (NEW.id_surowca, -NEW.zuzycie);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.aktualizuj_stan_magazynowy_po_zuzyciu() OWNER TO postgres;

--
-- Name: dodaj_stan_magazynowy_po_surowcu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dodaj_stan_magazynowy_po_surowcu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO stan_magazynowy (id_surowca, ilosc)
    VALUES (NEW.id, 0);

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.dodaj_stan_magazynowy_po_surowcu() OWNER TO postgres;

--
-- Name: reset_and_load_sample_data(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.reset_and_load_sample_data()
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


ALTER PROCEDURE public.reset_and_load_sample_data() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dostawy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dostawy (
    id integer NOT NULL,
    id_surowca integer NOT NULL,
    ilosc numeric(10,2) NOT NULL,
    data date NOT NULL
);


ALTER TABLE public.dostawy OWNER TO postgres;

--
-- Name: dostawy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dostawy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dostawy_id_seq OWNER TO postgres;

--
-- Name: dostawy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dostawy_id_seq OWNED BY public.dostawy.id;


--
-- Name: min_stany; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.min_stany (
    id_surowca integer NOT NULL,
    min_ilosc numeric(10,2) NOT NULL
);


ALTER TABLE public.min_stany OWNER TO postgres;

--
-- Name: stan_magazynowy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stan_magazynowy (
    id_surowca integer NOT NULL,
    ilosc numeric(10,2) NOT NULL
);


ALTER TABLE public.stan_magazynowy OWNER TO postgres;

--
-- Name: surowce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.surowce (
    id integer NOT NULL,
    nazwa character varying(55) NOT NULL,
    jednostka_zakupu numeric(10,2) NOT NULL,
    jednostka_miary character varying(10) NOT NULL
);


ALTER TABLE public.surowce OWNER TO postgres;

--
-- Name: surowce_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.surowce_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.surowce_id_seq OWNER TO postgres;

--
-- Name: surowce_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.surowce_id_seq OWNED BY public.surowce.id;


--
-- Name: zuzycie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zuzycie (
    id integer NOT NULL,
    id_surowca integer NOT NULL,
    zuzycie numeric(10,2) NOT NULL,
    data date NOT NULL
);


ALTER TABLE public.zuzycie OWNER TO postgres;

--
-- Name: zuzycie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.zuzycie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zuzycie_id_seq OWNER TO postgres;

--
-- Name: zuzycie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.zuzycie_id_seq OWNED BY public.zuzycie.id;


--
-- Name: dostawy id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dostawy ALTER COLUMN id SET DEFAULT nextval('public.dostawy_id_seq'::regclass);


--
-- Name: surowce id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surowce ALTER COLUMN id SET DEFAULT nextval('public.surowce_id_seq'::regclass);


--
-- Name: zuzycie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zuzycie ALTER COLUMN id SET DEFAULT nextval('public.zuzycie_id_seq'::regclass);


--
-- Data for Name: dostawy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dostawy (id, id_surowca, ilosc, data) FROM stdin;
1	1	150.00	2025-01-02
2	2	210.00	2025-01-04
3	3	80.00	2025-01-06
4	4	240.00	2025-01-08
5	5	110.00	2025-01-10
6	6	180.00	2025-01-12
7	7	70.00	2025-01-14
8	8	200.00	2025-01-16
9	9	90.00	2025-01-18
10	10	230.00	2025-01-20
11	11	120.00	2025-01-22
12	12	190.00	2025-01-24
13	13	85.00	2025-01-26
14	14	220.00	2025-01-28
15	15	100.00	2025-01-30
16	16	170.00	2025-02-01
17	17	60.00	2025-02-03
18	18	250.00	2025-02-05
19	19	130.00	2025-02-07
20	20	160.00	2025-02-09
21	21	55.00	2025-02-11
22	1	205.00	2025-02-13
23	2	95.00	2025-02-15
24	3	175.00	2025-02-17
25	4	65.00	2025-02-19
26	5	245.00	2025-02-21
27	6	115.00	2025-02-23
28	7	185.00	2025-02-25
29	8	75.00	2025-02-27
30	9	215.00	2025-03-01
31	10	105.00	2025-03-03
32	11	195.00	2025-03-05
33	12	80.00	2025-03-07
34	13	235.00	2025-03-09
35	14	125.00	2025-03-11
36	15	155.00	2025-03-13
37	16	60.00	2025-03-15
38	17	200.00	2025-03-17
39	18	90.00	2025-03-19
40	19	170.00	2025-03-21
41	20	70.00	2025-03-23
42	21	240.00	2025-03-25
43	1	110.00	2025-03-27
44	2	180.00	2025-03-29
45	3	75.00	2025-03-31
46	4	210.00	2025-04-02
47	5	100.00	2025-04-04
48	6	190.00	2025-04-06
49	7	85.00	2025-04-08
50	8	220.00	2025-04-10
51	9	120.00	2025-04-12
52	10	160.00	2025-04-14
53	11	65.00	2025-04-16
54	12	230.00	2025-04-18
55	13	135.00	2025-04-20
56	14	175.00	2025-04-22
57	15	50.00	2025-04-24
58	16	215.00	2025-04-26
59	17	95.00	2025-04-28
60	18	185.00	2025-04-30
61	19	70.00	2025-05-02
62	20	245.00	2025-05-04
63	21	115.00	2025-05-06
64	1	195.00	2025-05-08
65	2	80.00	2025-05-10
66	3	225.00	2025-05-12
67	4	125.00	2025-05-14
68	5	150.00	2025-05-16
69	6	55.00	2025-05-18
70	7	205.00	2025-05-20
71	8	105.00	2025-05-22
72	9	170.00	2025-05-24
73	10	60.00	2025-05-26
74	11	230.00	2025-05-28
75	12	130.00	2025-01-01
76	13	160.00	2025-01-03
77	14	55.00	2025-01-05
78	15	220.00	2025-01-07
79	16	100.00	2025-01-09
80	17	180.00	2025-01-11
81	18	75.00	2025-01-13
82	19	210.00	2025-01-15
83	20	110.00	2025-01-17
84	21	190.00	2025-01-19
\.


--
-- Data for Name: min_stany; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.min_stany (id_surowca, min_ilosc) FROM stdin;
1	50.00
2	75.00
3	100.00
4	125.00
5	150.00
\.


--
-- Data for Name: stan_magazynowy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stan_magazynowy (id_surowca, ilosc) FROM stdin;
1	100.00
2	150.00
3	200.00
4	250.00
5	300.00
6	350.00
7	400.00
8	450.00
9	500.00
10	550.00
11	600.00
12	650.00
13	700.00
14	750.00
15	800.00
16	850.00
17	900.00
18	950.00
19	1000.00
20	1050.00
21	200.00
\.


--
-- Data for Name: surowce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.surowce (id, nazwa, jednostka_zakupu, jednostka_miary) FROM stdin;
1	Stal	7850.00	kg
2	Aluminium	2700.00	kg
3	Miedź	8960.00	kg
4	Cynk	7135.00	kg
5	Ołów	11340.00	kg
6	Magnez	1740.00	kg
7	Tytan	4500.00	kg
8	Nikiel	8908.00	kg
9	Węgiel	1600.00	kg
10	Srebro	10490.00	kg
11	Kwas siarkowy	1840.00	l
12	Aceton	790.00	l
13	Etanol	789.00	l
14	Gliceryna	1260.00	l
15	Amoniak	682.00	l
16	Sód	968.00	l
17	Kwas solny	1185.00	l
18	Kwas azotowy	1420.00	l
19	Kwas fosforowy	10.00	kg
20	Kwas octowy	1040.00	l
21	Kwas cytrynowy	1.00	kg
\.


--
-- Data for Name: zuzycie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zuzycie (id, id_surowca, zuzycie, data) FROM stdin;
1	1	45.50	2025-01-03
2	2	78.20	2025-01-05
3	3	112.00	2025-01-07
4	4	60.10	2025-01-09
5	5	33.80	2025-01-11
6	6	91.40	2025-01-13
7	7	55.70	2025-01-15
8	8	89.90	2025-01-17
9	9	105.30	2025-01-19
10	10	48.10	2025-01-21
11	11	72.60	2025-01-23
12	12	108.70	2025-01-25
13	13	66.20	2025-01-27
14	14	39.50	2025-01-29
15	15	95.80	2025-01-31
16	16	52.30	2025-02-02
17	17	88.00	2025-02-04
18	18	101.90	2025-02-06
19	19	47.70	2025-02-08
20	20	75.10	2025-02-10
21	21	110.50	2025-02-12
22	1	63.40	2025-02-14
23	2	36.90	2025-02-16
24	3	90.20	2025-02-18
25	4	58.60	2025-02-20
26	5	87.30	2025-02-22
27	6	104.10	2025-02-24
28	7	49.00	2025-02-26
29	8	71.50	2025-02-28
30	9	115.60	2025-03-02
31	10	68.80	2025-03-04
32	11	41.20	2025-03-06
33	12	98.30	2025-03-08
34	13	53.90	2025-03-10
35	14	86.50	2025-03-12
36	15	107.00	2025-03-14
37	16	50.40	2025-03-16
38	17	74.80	2025-03-18
39	18	111.10	2025-03-20
40	19	61.70	2025-03-22
41	20	35.60	2025-03-24
42	21	93.00	2025-03-26
43	1	56.50	2025-03-28
44	2	85.00	2025-03-30
45	3	109.80	2025-04-01
46	4	51.10	2025-04-03
47	5	70.30	2025-04-05
48	6	114.20	2025-04-07
49	7	67.90	2025-04-09
50	8	40.00	2025-04-11
51	9	97.00	2025-04-13
52	10	54.50	2025-04-15
53	11	84.00	2025-04-17
54	12	106.30	2025-04-19
55	13	49.30	2025-04-21
56	14	76.70	2025-04-23
57	15	113.80	2025-04-25
58	16	62.00	2025-04-27
59	17	37.10	2025-04-29
60	18	94.60	2025-05-01
61	19	57.80	2025-05-03
62	20	89.10	2025-05-05
63	21	102.50	2025-05-07
64	1	46.90	2025-05-09
65	2	79.00	2025-05-11
66	3	116.00	2025-05-13
67	4	64.50	2025-05-15
68	5	32.70	2025-05-17
69	6	96.10	2025-05-19
70	7	51.00	2025-05-21
71	8	83.50	2025-05-23
72	9	100.80	2025-05-25
73	10	48.50	2025-05-27
74	11	77.20	2025-05-29
75	12	110.00	2025-01-02
76	13	65.00	2025-01-04
77	14	38.00	2025-01-06
78	15	92.00	2025-01-08
79	16	50.00	2025-01-10
80	17	80.00	2025-01-12
81	18	100.00	2025-01-14
82	19	45.00	2025-01-16
83	20	70.00	2025-01-18
84	21	105.00	2025-01-20
\.


--
-- Name: dostawy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dostawy_id_seq', 84, true);


--
-- Name: surowce_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.surowce_id_seq', 21, true);


--
-- Name: zuzycie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zuzycie_id_seq', 84, true);


--
-- Name: dostawy dostawy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dostawy
    ADD CONSTRAINT dostawy_pkey PRIMARY KEY (id);


--
-- Name: min_stany min_stany_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.min_stany
    ADD CONSTRAINT min_stany_pkey PRIMARY KEY (id_surowca);


--
-- Name: stan_magazynowy stan_magazynowy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stan_magazynowy
    ADD CONSTRAINT stan_magazynowy_pkey PRIMARY KEY (id_surowca);


--
-- Name: surowce surowce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surowce
    ADD CONSTRAINT surowce_pkey PRIMARY KEY (id);


--
-- Name: zuzycie zuzycie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zuzycie
    ADD CONSTRAINT zuzycie_pkey PRIMARY KEY (id);


--
-- Name: dostawy po_dodaniu_dostawy; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER po_dodaniu_dostawy AFTER INSERT ON public.dostawy FOR EACH ROW EXECUTE FUNCTION public.aktualizuj_stan_magazynowy_po_dostawie();


--
-- Name: surowce po_dodaniu_surowca; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER po_dodaniu_surowca AFTER INSERT ON public.surowce FOR EACH ROW EXECUTE FUNCTION public.dodaj_stan_magazynowy_po_surowcu();


--
-- Name: zuzycie po_dodaniu_zuzycia; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER po_dodaniu_zuzycia AFTER INSERT ON public.zuzycie FOR EACH ROW EXECUTE FUNCTION public.aktualizuj_stan_magazynowy_po_zuzyciu();


--
-- Name: dostawy dostawy_id_surowca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dostawy
    ADD CONSTRAINT dostawy_id_surowca_fkey FOREIGN KEY (id_surowca) REFERENCES public.surowce(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: min_stany min_stany_id_surowca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.min_stany
    ADD CONSTRAINT min_stany_id_surowca_fkey FOREIGN KEY (id_surowca) REFERENCES public.surowce(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: stan_magazynowy stan_magazynowy_id_surowca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stan_magazynowy
    ADD CONSTRAINT stan_magazynowy_id_surowca_fkey FOREIGN KEY (id_surowca) REFERENCES public.surowce(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: zuzycie zuzycie_id_surowca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zuzycie
    ADD CONSTRAINT zuzycie_id_surowca_fkey FOREIGN KEY (id_surowca) REFERENCES public.surowce(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT CREATE ON SCHEMA public TO admin_user;
GRANT USAGE ON SCHEMA public TO analityk_user;


--
-- Name: FUNCTION aktualizuj_stan_magazynowy_po_dostawie(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.aktualizuj_stan_magazynowy_po_dostawie() TO admin_user;


--
-- Name: FUNCTION aktualizuj_stan_magazynowy_po_zuzyciu(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.aktualizuj_stan_magazynowy_po_zuzyciu() TO admin_user;


--
-- Name: FUNCTION dodaj_stan_magazynowy_po_surowcu(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.dodaj_stan_magazynowy_po_surowcu() TO admin_user;


--
-- Name: TABLE dostawy; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.dostawy TO admin_user;
GRANT SELECT ON TABLE public.dostawy TO analityk_user;


--
-- Name: SEQUENCE dostawy_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.dostawy_id_seq TO admin_user;


--
-- Name: TABLE min_stany; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.min_stany TO admin_user;
GRANT SELECT ON TABLE public.min_stany TO analityk_user;


--
-- Name: TABLE stan_magazynowy; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.stan_magazynowy TO admin_user;
GRANT SELECT ON TABLE public.stan_magazynowy TO analityk_user;


--
-- Name: TABLE surowce; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.surowce TO admin_user;
GRANT SELECT ON TABLE public.surowce TO analityk_user;


--
-- Name: SEQUENCE surowce_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.surowce_id_seq TO admin_user;


--
-- Name: TABLE zuzycie; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.zuzycie TO admin_user;
GRANT SELECT ON TABLE public.zuzycie TO analityk_user;


--
-- Name: SEQUENCE zuzycie_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.zuzycie_id_seq TO admin_user;


--
-- PostgreSQL database dump complete
--

