// cleanup
MATCH (n) DETACH DELETE n
DROP CONSTRAINT uq_userid
DROP CONSTRAINT uq_tx_id


// users

LOAD CSV WITH HEADERS
FROM "https://drive.usercontent.google.com/u/0/uc?id=1_OoZNy7iCcxS0gsvvbCVRvS29GU_frLt&export=download" AS row
CREATE (u:User)
SET u.userid = row.customer_id

CREATE CONSTRAINT uq_userid FOR (u:User) REQUIRE (u.userid) IS UNIQUE


// P2P transactions

LOAD CSV WITH HEADERS
FROM "https://drive.usercontent.google.com/u/0/uc?id=1_1s6wnyYVVN2W2-fVGYiOMtOJKADn5Gx&export=download" AS row
MATCH (a:User), (b:User)
WHERE a.userid = row.customer_id AND b.userid = row.target_customer_id
CREATE (a)-[p:SEND_MONEY]->(b)
SET p.tx_id = row.transaction_id,
    p.amount = row.amount,
    p.currency = row.currency,
    p.initiated_at = datetime(replace(row.timestamp, ' ', 'T'))

CREATE CONSTRAINT uq_tx_id FOR ()-[p:SEND_MONEY]-() REQUIRE (p.tx_id) IS UNIQUE
