CREATE TABLE surowce (
  id SERIAL PRIMARY KEY,
  nazwa VARCHAR(255) NOT NULL,
  waga_jednostkowa DECIMAL(10, 2) NOT NULL,
  jednostka VARCHAR(50)
);

CREATE TABLE zuzycie (
  id SERIAL PRIMARY KEY,
  id_surowca INT NOT NULL,
  zuzycie DECIMAL(10, 2) NOT NULL,
  data DATE NOT NULL,
  FOREIGN KEY (id_surowca) REFERENCES surowce(id)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
);

CREATE TABLE dostawy (
  id SERIAL PRIMARY KEY,
  id_surowca INT NOT NULL,
  ilosc DECIMAL(10, 2) NOT NULL,
  data DATE NOT NULL,
  FOREIGN KEY (id_surowca) REFERENCES surowce(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE stan_magazynowy (
  id SERIAL PRIMARY KEY,
  id_surowca INT NOT NULL,
  ilosc DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (id_surowca) REFERENCES surowce(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE min_stany (
  id SERIAL PRIMARY KEY,
  id_surowca INT NOT NULL,
  min_ilosc DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (id_surowca) REFERENCES surowce(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);