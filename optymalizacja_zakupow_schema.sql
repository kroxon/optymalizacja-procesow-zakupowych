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

