DROP TRIGGER IF EXISTS update_tool_stock_on_purchase_update_trigger ON Purchase;
DROP TRIGGER IF EXISTS update_detail_stock_on_purchase_update_trigger ON Purchase;
DROP TRIGGER IF EXISTS update_purchase_closed_at_trigger ON Purchase;
DROP TRIGGER IF EXISTS check_unique_email_trigger ON Client;

DROP FUNCTION IF EXISTS update_tool_stock_on_purchase_update;
DROP FUNCTION IF EXISTS update_detail_stock_on_purchase_update;
DROP FUNCTION IF EXISTS update_purchase_closed_at;
DROP FUNCTION IF EXISTS check_unique_email;