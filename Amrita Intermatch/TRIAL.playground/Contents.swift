import UIKit

let mongoClient = try MongoClient(connectionString: "mongodb://localhost:27017")
let collection1 = mongoClient.db("database1").collection("collection1")
let collection2 = mongoClient.db("database1").collection("collection2")

let query = collection1.whereField("field1").ne(
    collection2.whereField("field2")
)

let results = try collection1.find(query)


