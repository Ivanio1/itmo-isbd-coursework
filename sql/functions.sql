CREATE OR REPLACE FUNCTION update_purchase(purchaseId bigint)
    RETURNS VOID AS
$$
BEGIN
    UPDATE purchase 
    SET state = 'Ожидает выполнения',
        createdat        = current_date
    WHERE id = purchaseId;  
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_purchase_status_to_done(purchase_id bigint)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'Выполнен'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_purchase_status_to_waiting(purchase_id bigint)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'Ожидает выполнения'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_purchase_status_to_in_process(purchase_id bigint)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'В процессе'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_available_tools()
    RETURNS TABLE (
                      id    bigint,
                      name  VARCHAR(255),
                      stock INTEGER
                  ) AS
$$
BEGIN
    RETURN QUERY
        SELECT Tool.id, Tool.name, Tool.stock 
        FROM Tool
        WHERE Tool.stock > 0;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_zero_tools()
    RETURNS TABLE (
                      id    bigint,
                      name  VARCHAR(255),
                      stock INTEGER
                  ) AS
$$
BEGIN
    RETURN QUERY
        SELECT Tool.id, Tool.name, Tool.stock 
        FROM Tool
        WHERE Tool.stock = 0;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_tool_count(tool_id bigint, number INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE tool
    SET stock = stock + number
    WHERE id = tool_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_tool_count_by_name(tool_name varchar(255), number INTEGER)
    RETURNS VOID AS
$$
DECLARE
    tool_id bigint;
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


CREATE OR REPLACE FUNCTION is_stock_of_detail_greater(detail_id bigint, number INTEGER)
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


CREATE OR REPLACE function fill_detail_count(detail_id bigint, number INTEGER)
RETURNS VOID as
$$
BEGIN
    UPDATE Detail
    SET storagestock = storagestock + number,
        stock        = stock - number
    WHERE id = detail_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_detail_count_by_name(detail_name varchar(255), number INTEGER)
    RETURNS VOID AS
$$
DECLARE
    detail_id bigint;
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
