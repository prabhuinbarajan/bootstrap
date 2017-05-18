use qubeship;
try {
    db.endPoint.update(
        {_id: ObjectId("58edb422238503000b74d7a6")},
        {
            $set:{
                "endPoint" : "https://192.168.99.101:8443"
            }
        }
    )
}catch (e) {
 print (e);
}
