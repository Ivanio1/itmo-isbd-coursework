-- взять / вернуть инструмент
CREATE OR REPLACE FUNCTION update_tool_stock_on_purchase_update()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.state = 'В процессе' AND OLD.state != 'В процессе' THEN
        UPDATE Tool
        SET stock = stock - 1
        FROM Offer
        WHERE Offer.id IN (SELECT offer_id FROM offer_purchase WHERE purchase_id = NEW.id)
          AND Tool.id IN (SELECT tool_id FROM offer_tool WHERE offer_id = Offer.id);

    ELSE
        IF NEW.state = 'Выполнен' AND OLD.state != 'Выполнен' THEN
            UPDATE Tool
            SET stock = stock + 1
            FROM Offer
            WHERE Offer.id IN (SELECT offer_id FROM offer_purchase WHERE purchase_id = NEW.id)
              AND Tool.id IN (SELECT tool_id FROM offer_tool WHERE offer_id = Offer.id);
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_tool_stock_on_purchase_update_trigger
    AFTER UPDATE ON Purchase
    FOR EACH ROW
EXECUTE FUNCTION update_tool_stock_on_purchase_update();


-- взять детали
CREATE OR REPLACE FUNCTION update_detail_stock_on_purchase_update()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.state = 'В процессе' AND OLD.state != 'В процессе' THEN
        UPDATE Detail
        SET storagestock = storagestock - 1
        FROM Offer
        WHERE Offer.id IN (SELECT offer_id FROM offer_purchase WHERE purchase_id = NEW.id)
          AND Detail.id IN (SELECT detail_id FROM offer_detail WHERE offer_id = Offer.id);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_detail_stock_on_purchase_update_trigger
    AFTER UPDATE ON Purchase
    FOR EACH ROW
EXECUTE FUNCTION update_detail_stock_on_purchase_update();


-- проставить дату закрытия заказа
CREATE OR REPLACE FUNCTION update_purchase_closed_at()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.state = 'Выполнен' AND OLD.state != 'Выполнен' THEN
        NEW.closedat = CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_purchase_closed_at_trigger
    BEFORE UPDATE ON Purchase
    FOR EACH ROW
EXECUTE FUNCTION update_purchase_closed_at();


-- проверить уникальность почты клиента
CREATE OR REPLACE FUNCTION check_unique_email()
    RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Users WHERE email = NEW.email AND id != NEW.id) > 0 THEN
        RAISE EXCEPTION 'Клиент с такой электронной почтой уже существует';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_unique_email_trigger
    BEFORE INSERT ON Users
    FOR EACH ROW
EXECUTE FUNCTION check_unique_email();
