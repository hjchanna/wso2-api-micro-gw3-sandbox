import ballerina/http;

public function transformMessageResponse (http:Caller inboundEp, http:Response res) {
    //get and check the response code from the backend
    int statusCode = res.statusCode;
    if (404 == statusCode || 500 == statusCode) {
        //create a new json response payload to return to the client
        json responsePayload = {

        };

        json | error backendPayload = res.getJsonPayload();

        //transform the payload into the required format
        if (backendPayload is json) {
            responsePayload.fault = {};
            responsePayload.fault.code = 900000;
            responsePayload.fault.message = backendPayload.message;
            responsePayload.fault.description = "An error returned from the customer backend";

            //set the response payload
            res.setJsonPayload(untaint responsePayload, contentType = "application/json");
        }
    }
}
