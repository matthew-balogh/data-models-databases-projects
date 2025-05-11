
// Queries

// 1. Number of unique labels
MATCH (n) RETURN DISTINCT labels(n);

// 2. Number of unique relationship types
MATCH ()-[r]-() RETURN DISTINCT type(r);

// 3. Number of `User` nodes
MATCH (u:User) RETURN count(u);

// 4. Number of `SEND_MONEY` relationships
MATCH ()-[r:SEND_MONEY]->() RETURN count(r);
MATCH ()-[r:SEND_MONEY]-() RETURN count(r);

// 5. Number of suspicious transactions and associated users
MATCH (u:User)-[r:SEND_MONEY]->()
WHERE r.suspicious
RETURN  count(r.tx_id) as suspicious_transaction_count,
        count(distinct u.userid) as suspicious_user_count;

// 6. Label suspicious users as `Suspicious` and `TopSuspicious`
MATCH (u:User)-[r:SEND_MONEY]->()
WHERE r.suspicious
WITH u, count(r.tx_id) as suspicious_transaction_count
WHERE suspicious_transaction_count > 30
SET u:Suspicious;

// // fetch
MATCH (su:User:Suspicious) RETURN collect(su.userid);

// // additionally, label the top 3 most suspicious users as `TopSuspicious`
MATCH (u:User:Suspicious)-[r:SEND_MONEY]->()
WHERE r.suspicious
WITH u, count(r.tx_id) as suspicious_transaction_count
ORDER BY suspicious_transaction_count DESC
LIMIT 3
SET u:TopSuspicious;

// // fetch
MATCH (su:User:TopSuspicious) RETURN collect(su.userid);

// 7. Most suspicious user
MATCH (u:User:TopSuspicious)
RETURN u.userid
LIMIT 1;

// 8. Direct connections of the top 1 `Suspicious` user
MATCH (top1Susp:User:TopSuspicious {userid: "CUST_41978"})-[r:SEND_MONEY*1]-(directNeighbors)
RETURN top1Susp, r, directNeighbors;

// 9. Connections of `TopSuspicious` users, considering hops up to 2
MATCH (topSusp:User:TopSuspicious)-[r:SEND_MONEY*1..2]-(neighbors)
RETURN topSusp, r, neighbors;

// 10. Shortest path between the top 1 `Suspicious` and the other `Suspicious` users
MATCH p=shortestPath(
  (top1Susp:User:TopSuspicious {userid: "CUST_41978"})-[*]-(susp:User:Suspicious)
)
WHERE top1Susp <> susp
RETURN p;
