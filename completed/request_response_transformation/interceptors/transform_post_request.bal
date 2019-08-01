import ballerina/log;
import ballerina/http;

//customer API client
http:Client httpClient = new("http://localhost:8080");

public function transformPostRequest (http:Caller outboundEp, http:Request req) {
    //get all customers to calculate next customer id
    var response = httpClient->get("/customer");
    var id = -1;

    if (response is http:Response) {
        json | error customers = response.getJsonPayload();

        if (customers is json) {
            //calculate next customer id
            id = customers.length() + 1;
        }
    }
    log:printInfo("Generated a new id for the customer :" + id);

    //set the calculated customer id to the request payload
    var requestPayload = req.getJsonPayload();
    if (requestPayload is json) {
        requestPayload.id = id;

        req.setJsonPayload(untaint requestPayload, contentType = "application/json");
    }
}
