--Ñîçäàòü çàêàç
CREATE OR REPLACE FUNCTION create_purchase(clientid INTEGER, carid INTEGER, workerid INTEGER)
    RETURNS INTEGER AS
$$
DECLARE
    purchase_id INTEGER;
BEGIN
    WITH purchase_id as (
        INSERT INTO Purchase(clientid, carid, workerid, state, createdat)
            values(clientid, carid, workerid, 'Íîâûé çàêàç', current_date)
            RETURNING id
    )
    SELECT * INTO purchase_id FROM purchase_id;
    RETURN purchase_id;

END;
$$ LANGUAGE plpgsql;

--Ñòàâèò ñòàòóñ çàêàçà âûïîëíåí è äàòó çàêðûòèÿ
CREATE OR REPLACE FUNCTION update_purchase_status_to_done(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'Âûïîëíåí'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

--Ñòàâèò ñòàòóñ çàêàçà íà îæèäàíèå
CREATE OR REPLACE FUNCTION update_purchase_status_to_waiting(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'Îæèäàåò âûïîëíåíèÿ'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

--Ñòàâèò ñòàòóñ çàêàçà â ïðîöåññå
CREATE OR REPLACE FUNCTION update_purchase_status_to_in_process(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'Â ïðîöåññå'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;


--Âîçâðàùàåò èìåþùèåñÿ èíñòðóìåíòû
CREATE OR REPLACE FUNCTION get_available_tools()
    RETURNS TABLE (
                      tool_id    INTEGER,
                      tool_name  VARCHAR(255)
                  ) AS
$$
BEGIN
    RETURN QUERY
        SELECT id, name
        FROM Tool
        WHERE stock > 0;
END;
$$ LANGUAGE plpgsql;

--Âîçâðàùàåò èíñòðóìåíòû, êîòîðûå çàêîí÷èëèñü (/ñëîìàëèñü)
CREATE OR REPLACE FUNCTION get_zero_tools()
    RETURNS TABLE (
                      tool_id    INTEGER,
                      tool_name  VARCHAR(255)
                  ) AS
$$
BEGIN
    RETURN QUERY
        SELECT id, name
        FROM Tool
        WHERE stock = 0;
END;
$$ LANGUAGE plpgsql;

--Ïîïîëíèòü èíñòðóìåíò
CREATE OR REPLACE FUNCTION fill_tool_count(tool_id INTEGER, number INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE tool
    SET stock = stock + number
    WHERE id = tool_id;
END;
$$ LANGUAGE plpgsql;

--Ïîïîëíèòü èíñòðóìåíò ïî íàçâàíèþ
CREATE OR REPLACE FUNCTION fill_tool_count_by_name(tool_name varchar(255), number INTEGER)
    RETURNS VOID AS
$$
DECLARE
    tool_id INTEGER;
BEGIN
    SELECT tool.id
    INTO tool_id
    FROM tool
    WHERE tool.name = tool_name;

    UPDATE tool
    SET stock = stock + number
    WHERE id = tool_id;
END;
$$ LANGUAGE plpgsql;

--Ïðîâåðèòü, åñòü ëè ó íàñ íóæíîå êîëè÷åñòâî äåëàëåé
CREATE OR REPLACE FUNCTION is_stock_of_detail_greater(detail_id INTEGER, number INTEGER)
    RETURNS BOOLEAN AS
$$
DECLARE
    result BOOLEAN;
BEGIN
    SELECT
        INTO result
        CASE WHEN
                 EXISTS(
                     SELECT * FROM Detail
                     WHERE detail.id = detail_id
                       AND detail.stock >= number
                 ) THEN true
             ELSE false
            END;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--Ïðîâåðèòü, åñòü ëè ó íàñ íóæíîå êîëè÷åñòâî äåëàëåé
CREATE OR REPLACE FUNCTION is_stock_of_detail_greater_by_name(detail_name varchar(255), number INTEGER)
    RETURNS BOOLEAN AS
$$
DECLARE
    result BOOLEAN;
BEGIN
    SELECT
    INTO result
        CASE WHEN
            EXISTS(
                SELECT * FROM Detail
                WHERE detail.name = detail_name
                AND detail.stock >= number
            ) THEN true
        ELSE false
        END;
    RETURN result;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE procedure fill_detail_count(detail_id bigint, number INTEGER)
as $$
BEGIN
    UPDATE Detail
    SET storagestock = storagestock + number,
        stock        = stock - number
    WHERE id = detail_id;
END;
$$ LANGUAGE plpgsql;


--Ïîïîëíèòü äåòàëè ïî íàçâàíèþ
CREATE OR REPLACE FUNCTION fill_detail_count_by_name(detail_name varchar(255), number INTEGER)
    RETURNS VOID AS
$$
DECLARE
    detail_id INTEGER;
BEGIN
    SELECT detail.id
    INTO detail_id
    FROM detail
    WHERE detail.name = detail_name;

    UPDATE Detail
    SET storagestock = storagestock + number
    WHERE id = detail_id;
END;
$$ LANGUAGE plpgsql;
