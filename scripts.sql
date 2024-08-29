-- 1) Horatius   | Amaya     |                392409

SELECT 
    c.first_name, 
    c.last_name, 
    SUM(p.item_quantity * i.price) AS total_purchase_amount
FROM 
    client c
JOIN 
    purchase p ON c.id = p.client_id
JOIN 
    item i ON p.item_id = i.id
GROUP BY 
    c.id
ORDER BY 
    COUNT(p.id) DESC
LIMIT 1;


-- 2)
-- Клиенты
SELECT * FROM client;

-- Товары
SELECT * FROM item;

-- Покупки
SELECT * FROM purchase;


-- 3)  Fish - Base, Bouillion |             45

SELECT 
    i.name, 
    SUM(p.item_quantity) AS total_quantity
FROM 
    item i
JOIN 
    purchase p ON i.id = p.item_id
GROUP BY 
    i.id
ORDER BY 
    total_quantity DESC
LIMIT 1;


-- 4)  id |             name              | quantity 
----+-------------------------------+----------
--  18 | Soup - Campbells Asian Noodle |       10
--  38 | Neckerchief Blck              |       10
--  36 | Bar Special K                 |        9
-- (3 rows)

CREATE OR REPLACE FUNCTION get_top_products(start_date DATE, end_date DATE)
RETURNS TABLE (
    id INT,
    name VARCHAR,
    quantity BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        i.id, 
        i.name, 
        SUM(p.item_quantity) AS quantity
    FROM 
        item i
    JOIN 
        purchase p ON i.id = p.item_id
    WHERE 
        p.date_purchase BETWEEN start_date AND end_date
    GROUP BY 
        i.id, i.name
    ORDER BY 
        quantity DESC
    LIMIT 3;
END;
$$ LANGUAGE plpgsql;

-- Вызов функции 
SELECT * FROM get_top_products('2021-12-01', '2022-01-01');


-- 5) 
-- Количество закупок по полу
SELECT 
    c.gender, 
    COUNT(p.id) AS total_purchases
FROM 
    client c
JOIN 
    purchase p ON c.id = p.client_id
GROUP BY 
    c.gender;

-- Сумма потраченных денег по полу
SELECT 
    c.gender, 
    SUM(p.item_quantity * i.price) AS total_spent
FROM 
    client c
JOIN 
    purchase p ON c.id = p.client_id
JOIN 
    item i ON p.item_id = i.id
GROUP BY 
    c.gender;


-- 6) 
SELECT 
    COUNT(p.id) AS total_items_sold, 
    SUM(p.item_quantity * i.price) AS total_amount_spent
FROM 
    client c
JOIN 
    purchase p ON c.id = p.client_id
JOIN 
    item i ON p.item_id = i.id
WHERE 
    c.email LIKE '%.ru';


