--Ставит статус заказа выполнен и дату закрытия
CREATE OR REPLACE FUNCTION update_purchase_status_to_done(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'Выполнен',
        closedAt = current_date
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

--Ставит статус заказа на ожидание
CREATE OR REPLACE FUNCTION update_purchase_status_to_waiting(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'Ожидает выполнения'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

--Ставит статус заказа в процессе
CREATE OR REPLACE FUNCTION update_purchase_status_to_in_process(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = 'В процессе'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;



--Можно сделать функции на выделение определенного числа инструментов и деталей на заказ