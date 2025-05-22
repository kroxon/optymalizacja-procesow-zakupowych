require('dotenv').config({ path: '/home/linux/repos/optymalizacja-procesow-zakupowych/.env' });

const express = require('express');
const { Client } = require('pg');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const client = new Client({
    user: process.env.DATABASE_USER,
    host: process.env.DATABASE_HOST,
    database: process.env.DATABASE_NAME,
    password: process.env.DATABASE_PASSWORD,
    port: process.env.DATABASE_PORT,
});

client.connect()
    .then(() => console.log(`Połączono z PostgreSQL ${client.database}`))
    .catch(err => console.error('Błąd połączenia z PostgreSQL', err));

app.get('/api/dane', async (req, res) => {
    try {
        const query = `
            SELECT
                s.id AS id_surowca,
                s.nazwa,
                s.jednostka_zakupu,
                s.jednostka_miary,
                COALESCE(sm.ilosc, 0) AS stan_magazynowy
            FROM surowce s
            LEFT JOIN stan_magazynowy sm ON s.id = sm.id_surowca
            ORDER BY s.id
        `;
        const result = await client.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error('Błąd podczas pobierania danych', err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.post('/api/:table', async (req, res) => {
    const { table } = req.params;
    const data = req.body;

    try {
        const keys = Object.keys(data).join(', ');
        const values = Object.values(data);
        const placeholders = values.map((_, i) => `$${i + 1}`).join(', ');

        const query = `INSERT INTO ${table} (${keys}) VALUES (${placeholders}) RETURNING *`;
        const result = await client.query(query, values);
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error(`Błąd podczas dodawania do tabeli ${table}`, err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.put('/api/:table/:id', async (req, res) => {
    const { table, id } = req.params;
    const data = req.body;

    try {
        const updates = Object.keys(data)
            .map((key, i) => `${key} = $${i + 1}`)
            .join(', ');
        const values = Object.values(data);

        const query = `UPDATE ${table} SET ${updates} WHERE id = $${values.length + 1} RETURNING *`;
        const result = await client.query(query, [...values, id]);

        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Nie znaleziono rekordu' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error(`Błąd podczas aktualizacji tabeli ${table}`, err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.delete('/api/:table/:id', async (req, res) => {
    const { table, id } = req.params;

    try {
        const query = `DELETE FROM ${table} WHERE id = $1 RETURNING *`;
        const result = await client.query(query, [id]);

        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Nie znaleziono rekordu' });
        }
        res.json({ message: 'Rekord został usunięty' });
    } catch (err) {
        console.error(`Błąd podczas usuwania z tabeli ${table}`, err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.post('/api/zuzycie', async (req, res) => {
    const { id_surowca, zuzycie, data } = req.body;

    try {
        const zuzycieQuery = `
            INSERT INTO zuzycie (id_surowca, zuzycie, data)
            VALUES ($1, $2, $3)
            RETURNING *`;
        const zuzycieValues = [id_surowca, zuzycie, data];
        const zuzycieResult = await client.query(zuzycieQuery, zuzycieValues);

        res.status(201).json(zuzycieResult.rows[0]);
    } catch (err) {
        console.error('Błąd podczas dodawania zużycia:', err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.post('/api/dostawy', async (req, res) => {
    const { id_surowca, ilosc, data } = req.body;

    try {
        const dostawaQuery = `
            INSERT INTO dostawy (id_surowca, ilosc, data)
            VALUES ($1, $2, $3)
            RETURNING *`;
        const dostawaValues = [id_surowca, ilosc, data];
        const dostawaResult = await client.query(dostawaQuery, dostawaValues);

        res.status(201).json(dostawaResult.rows[0]);
    } catch (err) {
        console.error('Błąd podczas dodawania dostawy:', err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.get('/api/zuzycie', async (req, res) => {
    try {
        const query = `
            SELECT
                z.id,
                z.id_surowca,
                z.zuzycie,
                z.data,
                s.nazwa AS nazwa_surowca
            FROM zuzycie z
            JOIN surowce s ON z.id_surowca = s.id
            ORDER BY z.data DESC
        `;
        const result = await client.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error('Błąd podczas pobierania zużyć:', err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.get('/api/dostawy', async (req, res) => {
    try {
        const query = `
            SELECT
                d.id,
                d.id_surowca,
                d.ilosc,
                d.data,
                s.nazwa AS nazwa_surowca
            FROM dostawy d
            JOIN surowce s ON d.id_surowca = s.id
            ORDER BY d.data DESC
        `;
        const result = await client.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error('Błąd podczas pobierania dostaw:', err);
        res.status(500).json({ error: 'Wystąpił błąd serwera' });
    }
});

app.listen(port, () => {
    console.log(`Serwer backendowy działa na http://localhost:${port}`);
});