exports = async function(payload, response) {
    const {database, coll_to_update} = payload.query;
    const coll = context.services.get("mongodb-atlas").db(database).collection(coll_to_update);

    // Payload body is a JSON string, convert into a JavaScript Object
    const data = JSON.parse(payload.body.text());
    
    // No drop collection method available so delete all
    await coll.deleteMany({}).then(result => {
        console.log(`${new Date().getTime()}: Deleted ${result.deletedCount} item(s).`);
    }).catch(error => {
        // Catch any error with execution and return a 500
        console.error(`${new Date().getTime()}: Failed to insert documents: ${error}`);
        response.setStatusCode(500);
        response.setBody(JSON.stringify({
            timestamp: (new Date()).getTime(),
            errorMessage: error
        }));
        return;
    });
    
    // Perform operations as a bulk
    const bulkOp = coll.initializeUnorderedBulkOp();
    data.forEach(document => {
        bulkOp.insert(document);
    });
    response.addHeader(
        "Content-Type",
        "application/json"
    );

    bulkOp.execute().then(() => coll.count()).then((numDocs) => {
        console.log(`${new Date().getTime()}: Successfully inserted ${numDocs} items!`);
        // All operations completed successfully
        response.setStatusCode(200);
        response.setBody(JSON.stringify({
            timestamp: (new Date()).getTime()
        }));
        return;
    }).catch(error => {
        // Catch any error with execution and return a 500
        console.error(`${new Date().getTime()}: Failed to insert documents: ${error}`);
        response.setStatusCode(500);
        response.setBody(JSON.stringify({
            timestamp: (new Date()).getTime(),
            errorMessage: error
        }));
        return;
    });
};