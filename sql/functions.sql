--������ ������ ������ �������� � ���� ��������
CREATE OR REPLACE FUNCTION update_purchase_status_to_done(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = '��������',
        closedAt = current_date
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

--������ ������ ������ �� ��������
CREATE OR REPLACE FUNCTION update_purchase_status_to_waiting(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = '������� ����������'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;

--������ ������ ������ � ��������
CREATE OR REPLACE FUNCTION update_purchase_status_to_in_process(purchase_id INTEGER)
    RETURNS VOID AS
$$
BEGIN
    UPDATE Purchase
    SET state    = '� ��������'
    WHERE id = purchase_id;
END;
$$ LANGUAGE plpgsql;



--����� ������� ������� �� ��������� ������������� ����� ������������ � ������� �� �����