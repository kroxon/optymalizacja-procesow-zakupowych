CREATE TABLE surowce (
  id SERIAL PRIMARY KEY,
  nazwa VARCHAR(55) NOT NULL,
  jednostka_zakupu DECIMAL(10, 2) NOT NULL,
  jednostka_miary VARCHAR(10) NOT NULL
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
  id_surowca INT PRIMARY KEY,
  ilosc DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (id_surowca) REFERENCES surowce(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE min_stany (
  id_surowca INT PRIMARY KEY,
  min_ilosc DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (id_surowca) REFERENCES surowce(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);