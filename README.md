# Data Models and Databases Projects

## NoSQL - Neo4j Graph Database

The objective is to model and construct a graph-based database for data for a peer-to-peer online money transfering application, where users can send money to each other.

### Modeling

Labels: `User`\
Relationship Types: `SEND_MONEY`

Samples: `(u:User {userid: "CUST_10000"})` , `(a:User)-[p:SEND_MONEY {tx_id: "", amount: _, currency: "", initiated_at: ""}]->(b:User)`