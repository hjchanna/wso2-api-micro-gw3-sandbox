import ballerina/io;
import ballerina/http;

http:Client httpClient = new("http://localhost:8080");

public function transformPostRequest (http:Caller outboundEp, http:Request req) {
    var response = httpClient->get("/customer");
    var id = -1;

    if (response is http:Response) {
        json | error customers = response.getJsonPayload();

        if (customers is json) {
            id = customers.length() + 1;
        }
    }
    io:println("Generated a new id for the customer :" + id);

    var requestPayload = req.getJsonPayload();
    if (requestPayload is json) {
        requestPayload.id = id;

        req.setJsonPayload(untaint requestPayload, contentType = "application/json");
    }
}
