// cleanup
MATCH (n) DETACH DELETE n;
DROP CONSTRAINT uq_userid;
DROP CONSTRAINT uq_tx_id;

// users
LOAD CSV WITH HEADERS
FROM "https://drive.usercontent.google.com/u/0/uc?id=1_OoZNy7iCcxS0gsvvbCVRvS29GU_frLt&export=download" AS row
CREATE (u:User)
SET u.userid = row.customer_id;

// P2P transactions
LOAD CSV WITH HEADERS
FROM "https://drive.usercontent.google.com/u/0/uc?id=1lAwkmALDXDl4dW0nQGBaLw2GLyTCk6sr&export=download" AS row
MATCH (a:User), (b:User)
WHERE a.userid = row.customer_id AND b.userid = row.target_customer_id
CREATE (a)-[r:SEND_MONEY]->(b)
SET r.tx_id = row.transaction_id,
    r.amount = row.amount,
    r.currency = row.currency,
    r.initiated_at = datetime(replace(row.timestamp, ' ', 'T')),
    r.suspicious = toBoolean(row.is_fraud);

// constraints
CREATE CONSTRAINT uq_userid FOR (u:User) REQUIRE (u.userid) IS UNIQUE;
CREATE CONSTRAINT uq_tx_id FOR ()-[p:SEND_MONEY]-() REQUIRE (p.tx_id) IS UNIQUE;
