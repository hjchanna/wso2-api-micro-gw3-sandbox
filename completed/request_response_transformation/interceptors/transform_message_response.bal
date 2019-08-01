import ballerina/io;
import ballerina/http;

public function transformMessageResponse (http:Caller inboundEp, http:Response res) {
    int statusCode = res.statusCode;
    if (404 == statusCode || 500 == statusCode) {
        json responsePayload = {

        };

        json | error backendPayload = res.getJsonPayload();

        if (backendPayload is json) {
            responsePayload.fault = {};
            responsePayload.fault.code = 900000;
            responsePayload.fault.message = backendPayload.message;
            responsePayload.fault.description = "An error returned from the customer backend";

            res.setJsonPayload(untaint responsePayload, contentType = "application/json");
        }
    }
}
