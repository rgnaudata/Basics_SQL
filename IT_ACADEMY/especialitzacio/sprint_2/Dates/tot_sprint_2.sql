		-- NIVELL 1
        
        
-- EXERCICI 2 (Utilitzant JOIN)
USE transactions;

-- Llistat dels països que estan generant vendes.
SELECT DISTINCT (country) FROM company;

SELECT DISTINCT c.country
FROM `transaction` AS t
JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0;

-- Des de quants països es generen les vendes.
SELECT count(DISTINCT c.country) AS total_paises
FROM `transaction` AS t
JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0;

-- Identifica la companyia amb la mitjana més gran de vendes.
SELECT c.id, company_name, round(avg(amount),2) as avg_vendes
FROM `transaction` AS t
JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.id, company_name
ORDER BY avg_vendes DESC
LIMIT 1;


-- EXERCICI 3 (Utilitzant només subconsultes) 
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT t.id AS transaccion, company_id 
FROM `transaction` AS t 
WHERE 
EXISTS (SELECT c.id
FROM company AS c
WHERE c.id=t.company_id 
AND country='Germany'
);

    
-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT c.id, c.company_name 
FROM `company` AS c
WHERE EXISTS(
			SELECT t.id FROM `transaction` AS t
			WHERE t.company_id = c.id
			AND t.amount >  (
							SELECT AVG(amount) 
							FROM `transaction` WHERE declined=0)
AND declined = 0);


-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT id, company_name 
FROM company AS c
WHERE NOT EXISTS
	(SELECT company_id 
	FROM `transaction` AS t 
	WHERE c.id = t.company_id
    AND declined= 0);


-- Exercici 4
/*
La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.
*/
USE transactions;

CREATE TABLE IF NOT EXISTS credit_card(
	id VARCHAR (15) PRIMARY KEY, 
    iban VARCHAR (34) NOT NULL, 
    pan VARCHAR(30),
    pin CHAR(4),
    cvv CHAR(3),
    expiring_date DATE
);

-- modifico tipo dato en columna expiring_date, pues no me deja importar datos con este tipo
ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(15);

-- primero necesito modificar el formato, lo paso correctamente a date 
UPDATE credit_card
SET expiring_date = STR_TO_DATE (expiring_date, '%m/%d/%y')
LIMIT 6000;

-- ahora modifico el tipo de dato de la columna a DATE
ALTER TABLE credit_card
MODIFY COLUMN expiring_date DATE;

-- compruevo este bien
SELECT * FROM credit_card;

-- intento establecer la relación entre tablas pero no me deja
ALTER TABLE `transaction`
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id) 
REFERENCES credit_card(id);

-- compruebo mediante una LEFT JOIN si alguna targeta que aparece en transaction no aparece en la tabla credit_card
SELECT DISTINCT t.credit_card_id
FROM `transaction` AS t
LEFT JOIN credit_card AS cc
ON t.credit_card_id = cc.id
WHERE cc.id IS NULL;

-- inserto en credit_card la targeta en cuestión dandole un valor temporal a iban
INSERT INTO credit_card
(id, iban) VALUES ('CcU-9999', 'temporary__need_update');

-- ejecuto la relación entre las tablas al configurar la FK
ALTER TABLE `transaction`
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id) 
REFERENCES credit_card(id);

-- Exercici 5
-- El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card SET iban = 'TR323456312213576817699999' 
WHERE id = 'CcU-2938';

SELECT * FROM credit_card
WHERE id = 'CcU-2938'; 


-- Exercici 6
-- En la taula "transaction" ingressa una nova transacció amb la següent informació:
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
VALUEs ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999', 'b-9999', '9999', '829.999', '-117.999', current_timestamp(), '111.11', '0');

SELECT * FROM `transaction`WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';


-- Exercici 7
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
	DROP COLUMN pan;
    
-- Exercici 8
-- creo la base de dades
CREATE DATABASE mi_negocio;
USE mi_negocio;

/*
Em dona problemes en carregar la taula desde el client (workbench), llavors ho faig desde el terminal: mysql --local-infile=1 -u root -p mi_negocio
	-- primer entro a mysql, activo local_infile i entro a la bbdd exercici_8
    -- després ja cargo la taula:
LOAD DATA LOCAL INFILE '/home/arnau/IT_ACADEMY/especialitzacio/sprint_2/N1-Ex.1__dades_introduir.sql'
INTO TABLE american_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/

-- creo la taula american_users
CREATE TABLE american_users(
	id INT PRIMARY KEY,
	name VARCHAR (25), 
	surname VARCHAR (50), 
	phone VARCHAR (25),
	email VARCHAR(50), 
	birth_date VARCHAR(22),
	country VARCHAR (30),
	city VARCHAR(30),
	postal_code VARCHAR(25),
	address VARCHAR (50)
	);


-- creo la taula european_users
CREATE TABLE european_users(
id INT PRIMARY KEY,
name VARCHAR (25), 
surname VARCHAR (50), 
phone VARCHAR (25),
email VARCHAR(50), 
birth_date VARCHAR(22),
country VARCHAR (30),
city VARCHAR(30),
postal_code VARCHAR(25),
address VARCHAR (50)
);


-- creo la taula companies
CREATE TABLE companies (
	company_id VARCHAR (8) NOT NULL,
	company_name VARCHAR (40),
	phone VARCHAR(15),
	email VARCHAR(70),
	country VARCHAR(30),
	website VARCHAR(50),
    PRIMARY KEY (company_id)
	);


-- creo taula credit_cards
CREATE TABLE credit_cards (
	id VARCHAR(10) PRIMARY KEY,
	user_id INT,
	iban VARCHAR(50), 
	pan VARCHAR(20), 
	pin SMALLINT, 
	cvv SMALLINT,
	track1 VARCHAR(100),
	track2 VARCHAR(100),
	expiring_date VARCHAR(10)
	);



-- creo taula transactions
CREATE TABLE transactions (
	id VARCHAR(255) NOT NULL, 
	card_id VARCHAR(10), 
	business_id VARCHAR(8), 
	timestamp TIMESTAMP,
	amount DECIMAL (10,2), 
	declined TINYINT, 
	product_ids VARCHAR (50),
	user_id INT,
	lat FLOAT(24), 
	longitude FLOAT(24), 
    PRIMARY KEY (id)
	);


-- creo la columna continent en european 
ALTER TABLE european_users
	ADD continent CHAR (10);

UPDATE european_users 
	SET continent = 'europe'
    LIMIT 5000;

SELECT * FROM european_users;

-- creo la columna continent en american
ALTER TABLE american_users
	ADD continent CHAR (10);

UPDATE american_users 
	SET continent = 'america'
    LIMIT 5000;

SELECT * FROM american_users;


-- faig la unio de la taula american_users amb european_users perque tenen tots els camps iguals
CREATE TABLE users AS
	SELECT * FROM american_users
	UNION
	SELECT * FROM european_users;
    
-- afegeixo la PK a la taula users
ALTER TABLE users
ADD PRIMARY KEY (id);

-- comprovo s'hagin carregat bé les dades
SELECT * FROM users;

-- BORRO les taules american_users i european_users
DROP TABLE american_users;
DROP TABLE european_users;

-- Vamos a establecer las relaciones
-- transactions-credit_cards
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_credit_cards
FOREIGN KEY (card_id)
REFERENCES credit_cards (id);


 -- transactions-users
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_users
FOREIGN KEY (user_id)
REFERENCES users (id);

 -- transactions-companies
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_companies
FOREIGN KEY (business_id)
REFERENCES companies (company_id);


-- Exercici 9
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT u.id, u.`name`, n.n_trans
FROM users AS u, 
				(SELECT user_id, count(*) AS n_trans
                FROM transactions AS t
				WHERE t.declined = 0
				GROUP BY user_id) AS n
WHERE u.id = n.user_id
HAVING n.n_trans > 80
ORDER BY n.n_trans DESC;

-- Exercici 10
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
SELECT cc.iban, ROUND (avg(t.amount),2) AS media
FROM transactions AS t
JOIN companies AS c
ON t.business_id = c.company_id
JOIN credit_cards AS cc
ON cc.id = t. card_id
WHERE company_name = 'Donec Ltd' AND 
t.declined = 0
GROUP BY cc.iban
ORDER BY avg(amount) DESC;



	-- Nivell 2

-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT date(t.`timestamp`) AS fecha, sum(amount) total_ventas
FROM transactions AS t
JOIN companies AS c
ON t.business_id = c.company_id
WHERE declined = 0
GROUP BY date(t.`timestamp`) 
ORDER BY total_ventas DESC
LIMIT 5;

-- Exercici 2
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 
-- 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. 
-- Ordena els resultats de major a menor quantitat.

SELECT c.company_name, c.phone, c.country, date(t.`timestamp`) AS fecha, t.amount AS cantidad
FROM companies AS c
JOIN transactions AS t
ON c.company_id = t.business_id
WHERE declined = 0
AND (date(t.`timestamp`) IN ('2015-04-29', '2018-7-20','2024-03-13'))
AND (t.amount BETWEEN 350 AND 400)
ORDER BY t.amount DESC;


-- Exercici 3
/*Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 400 transaccions o menys.
*/
SELECT *, ROW_NUMBER() OVER (
							PARTITION BY categoria 
                            ORDER BY num_transactions ASC
                            ) AS lista
FROM
	(SELECT *, CASE
			WHEN num_transactions < 400 THEN 'Por debajo'
			ELSE 'Por encima'
			END AS categoria
	FROM
			(SELECT 
				c.company_id, 
				c.company_name, 
				count(*) AS num_transactions
			FROM transactions AS t
			JOIN companies AS c
			ON t.business_id = c.company_id
            WHERE declined = 0
			GROUP BY c.company_id, c.company_name) AS nt) AS nu;


-- Exercici 4
-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.
DELETE FROM transactions 
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT * FROM transactions
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


-- Exercici 5
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
-- Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE OR REPLACE VIEW VistaMarketing AS
SELECT c.company_name, 
		c.phone, c.country, 
		ROUND(AVG(amount),2) AS media
FROM companies AS c
JOIN transactions AS t
ON c.company_id = t.business_id
WHERE t.declined = 0
GROUP BY c.company_id, c.company_name, c.phone, c.country
ORDER BY ROUND(AVG(amount),2) DESC; 

SELECT *
FROM VistaMarketing
ORDER BY media DESC;



	-- Nivell 3

-- Exercici 1
/* Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions 
han estat declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:
Quantes targetes estan actives?
*/

CREATE TABLE card_status AS
SELECT * 
FROM

	(SELECT card_id, 
			CASE 
				WHEN transacciones_declinadas = '3' THEN 'inactiva'
				ELSE 'activa'
			END AS estado_targeta
	FROM
				(SELECT *, SUM(declined) OVER (PARTITION BY card_id ORDER BY lista) AS transacciones_declinadas
				FROM
						(SELECT card_id, declined, `timestamp`,
						ROW_NUMBER() OVER(PARTITION BY card_id ORDER BY `timestamp` DESC) AS lista
						FROM transactions) AS ls
				WHERE lista BETWEEN '1' AND '3') AS suma_acumulativa 
	WHERE lista = '3') tabla_final;


-- query en la nueva tabla
SELECT count(*)
FROM taula_nova
WHERE estado_targeta = 'activa';



/*
Exercici 2
Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, 
tenint en compte que des de transaction tens product_ids. Genera la següent consulta:
Necessitem conèixer el nombre de vegades que s'ha venut cada producte.
*/


CREATE TABLE products(
id INT NOT NULL, 
product_name VARCHAR (30), 
price VARCHAR(10), 
colour VARCHAR (12), 
weight VARCHAR(10),
warehouse_id VARCHAR (9),
PRIMARY KEY (id));


-- importo les dades desde el terminal
/*
LOAD DATA LOCAL INFILE '/home/arnau/IT_ACADEMY/especialitzacio/sprint_2/N3.Ex.2__ products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/

-- elimino simbol dolar de la colmna price
UPDATE products 
SET price =
REPLACE (price, '$', '')
LIMIT 500;

-- comprovo els canvis
SELECT price FROM products;

-- modifico el tipo de dato de la columna
ALTER TABLE products
MODIFY COLUMN price DECIMAL(6,2);


-- creo tabla secundaria
CREATE TABLE transactions_products (
transaction_id VARCHAR(255),
product_id INT,
PRIMARY KEY (transaction_id, product_id),
FOREIGN KEY (transaction_id) REFERENCES transactions(id),
FOREIGN KEY (product_id) REFERENCES products(id)
);


-- introdueixo les files expandides a la nova taula
INSERT INTO transactions_products(transaction_id, product_id)
	(SELECT t.id AS transactions_id, jt.product_id
	FROM transactions AS t,
	JSON_TABLE (
		CONCAT('["', REPLACE (product_ids, ',' , '","'), '"]'),
		'$[*]' COLUMNS (
						product_id INT PATH "$")) AS jt
WHERE t.product_ids IS NOT NULL AND t.product_ids <> '');


-- comprovo les dades de la taula
SELECT count(*) FROM transactions_products;
SELECT count(DISTINCT product_id)
FROM transactions_products;


-- faig la query sobre la nova taula per respondre a la pregunta
SELECT p.id, p.product_name, count(*) AS num_ventas
FROM transactions_products tp
JOIN products p
ON tp.product_id = p.id
GROUP BY p.id
ORDER BY num_ventas DESC;






