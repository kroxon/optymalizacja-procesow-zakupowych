-- Utworzenie użytkownika admina
CREATE USER admin_user WITH PASSWORD 'admin';
GRANT ALL PRIVILEGES ON DATABASE optymalizacja_zakupow TO admin_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_user;
GRANT CREATE ON SCHEMA public TO admin_user;s
ALTER USER admin_user CREATEROLE CREATEDB;

-- Utworzenie użytkownika analityka
CREATE USER analityk_user WITH PASSWORD 'analityk';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analityk_user;
GRANT USAGE ON SCHEMA public TO analityk_user; 