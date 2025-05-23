-- Po dodaniu dostawy surowca, aktualizuj stan magazynowy

CREATE OR REPLACE FUNCTION aktualizuj_stan_magazynowy_po_dostawie()
RETURNS TRIGGER AS $$
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
        INSERT INTO stan_magazynowy (id_surowca, ilosc)
        VALUES (NEW.id_surowca, -NEW.zuzycie);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER po_dodaniu_zuzycia
AFTER INSERT ON zuzycie
FOR EACH ROW
EXECUTE FUNCTION aktualizuj_stan_magazynowy_po_zuzyciu();

-- Po dodaniu surowca do surowce dodaje wpis do stan magazynowy
CREATE OR REPLACE FUNCTION dodaj_stan_magazynowy_po_surowcu()
RETURNS TRIGGER AS $$
BEGIN
    -- Dodaj nowy wpis do stan_magazynowy z ilością 0
    INSERT INTO stan_magazynowy (id_surowca, ilosc)
    VALUES (NEW.id, 0);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER po_dodaniu_surowca
AFTER INSERT ON surowce
FOR EACH ROW
EXECUTE FUNCTION dodaj_stan_magazynowy_po_surowcu();