CREATE INDEX IF NOT EXISTS purchase_id ON purchase USING HASH(id);

CREATE INDEX IF NOT EXISTS purchase_status ON purchase USING HASH(state);

CREATE INDEX IF NOT EXISTS purchase_createdat ON purchase USING BTREE(createdat);

CREATE INDEX IF NOT EXISTS offer_name on offer USING HASH(name);

CREATE INDEX IF NOT EXISTS sto_name ON sto USING HASH(name);

CREATE INDEX IF NOT EXISTS detail_name ON detail USING HASH(name);

CREATE INDEX IF NOT EXISTS tool_name ON tool USING HASH(name);

CREATE INDEX IF NOT EXISTS client_id ON client USING HASH(id);

CREATE INDEX IF NOT EXISTS car_id ON car USING HASH(id);