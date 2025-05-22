-- Po dodaniu dostawy surowca, aktualizuj stan magazynowy

CREATE OR REPLACE FUNCTION aktualizuj_stan_magazynowy_po_dostawie()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM stan_magazynowy WHERE id_surowca = NEW.id_surowca) THEN
        UPDATE stan_magazynowy
        SET ilosc = ilosc + NEW.ilosc
        WHERE id_surowca = NEW.id_surowca;
    ELSE
        RAISE NOTICE 'Dostawa dla surowca o ID % nie została zarejestrowana w magazynie', NEW.id_surowca;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER po_dodaniu_dostawy
AFTER INSERT ON dostawy
FOR EACH ROW
EXECUTE FUNCTION aktualizuj_stan_magazynowy_po_dostawie();

-- Po dodaniu zużycia surowca, aktualizuj stan magazynowy

CREATE OR REPLACE FUNCTION aktualizuj_stan_magazynowy_po_zuzyciu()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM stan_magazynowy WHERE id_surowca = NEW.id_surowca) THEN
        UPDATE stan_magazynowy
        SET ilosc = ilosc - NEW.zuzycie  
        WHERE id_surowca = NEW.id_surowca;
    ELSE
        RAISE NOTICE 'Zużycie dla surowca o ID % nie zostało zarejestrowane w magazynie', NEW.id_surowca;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER po_dodaniu_zuzycia
AFTER INSERT ON zuzycie
FOR EACH ROW
EXECUTE FUNCTION aktualizuj_stan_magazynowy_po_zuzyciu();

