use qubeship;
print ( "use qubeship; ");
print ("try { ");
print ("db.endPoint.remove( { \"_id\": ObjectId(\"58e3fad42a0603000b3e58a8\") } ); ");
print ("db.endPoint.remove( { \"_id\" : ObjectId(\"58edb422238503000b74d7a6\") } );  ");
print ("}catch (e) { ");
print (" print (e); "); 
print("}");
print ( "db.endPoint.insertMany(" );
db.endPoint.find({"orgId":"150e18f6-0165-34ad-ad30-8577b03eadb4", $or: [ { "_id": ObjectId("58e3fad42a0603000b3e58a8") }, { "_id": ObjectId("58edb422238503000b74d7a6") } ]}).toArray()
print ( ");" );
use toolchain;
print ( "use toolchain; ");
print ("try { ");
print ("db.Toolchain.deleteOne( { \"_id\" : ObjectId(\"58e56a68acac5a0020e2b930\") } ); ");
print ("db.Toolchain.deleteOne( { \"_id\" : ObjectId(\"58e3fad09a148400216611cc\") } ); ");
print ("db.Toolchain.deleteOne( { \"_id\" : ObjectId(\"58e573feacac5a001de2b932\") } ); ");
print ("db.Toolchain.deleteOne( { \"_id\" : ObjectId(\"5909a34697b368001ead237a\") } ); ");

print ("}catch (e) { ");
print (" print (e); "); 
print("}");
print ( "db.Toolchain.insertMany(" );
db.Toolchain.find(
    {"orgId":"150e18f6-0165-34ad-ad30-8577b03eadb4", $or: [
        { "_id": ObjectId("58e56a68acac5a0020e2b930") },
        { "_id": ObjectId("58e3fad09a148400216611cc") },
        { "_id": ObjectId("58e573feacac5a001de2b932") } ,
        { "_id": ObjectId("5909a34697b368001ead237a") }

       ]
    }).toArray()
print ( ");" );


use opinions;
print ( "use opinions; ");
print ("try { ");
print ("db.Opinion.deleteOne( { \"_id\" : ObjectId(\"58e5596a13d0cc000e88a95d\") } );");
print ("}catch (e) { ");
print (" print (e); "); 
print("}");
print ( "db.Opinion.insertMany(" );
db.Opinion.find({"orgId":"150e18f6-0165-34ad-ad30-8577b03eadb4", $or: [ { "_id": ObjectId("58e5596a13d0cc000e88a95d") } ]}).toArray()
print ( ");" );