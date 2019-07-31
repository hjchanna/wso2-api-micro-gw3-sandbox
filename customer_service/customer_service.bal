// ---------------------------------------------------------------------------
//  Ballerina customer_service: sample API for a customer metaphor at a online
//  store system. Tested on Ballerina 0.991.0
//  - developer: channa jayamuni <hjchanna@gmail.com>
// ---------------------------------------------------------------------------

import ballerina/http;
import ballerina/log;

@http:ServiceConfig {
    basePath: "/customer"
}
service customer_service on new http:Listener(8080) {

    # ---------------------------------------------------------------------------
    # get all customer data endpint
    # ---------------------------------------------------------------------------
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    resource function getCustomers(http:Caller caller, http:Request request) {
        http:Response response = new;

        //create response
        response.setJsonPayload(untaint CUSTOMER_DATA, contentType = "application/json");
        response.statusCode = 200;

        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error writing the customer response", err = result);
        }
    }

    # ---------------------------------------------------------------------------
    # get customer data for a given customer id
    # ---------------------------------------------------------------------------
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{customerId}"
    }
    resource function getCustomer(http:Caller caller, http:Request request, int customerId) {
        //get customer data from the memory
        json? customer = getCustomerById(customerId);
        http:Response response = new;

        if (customer == null) {
            //customer not found in the memory
            log:printError("Customer not found for id: " + customerId, err = ());

            json payload = {
                message: "Customer not fount for the id: " + customerId
            };
            response.setJsonPayload(untaint payload, contentType = "application/json");
            response.statusCode = 404;
        } else {
            //customer found in memory
            response.setJsonPayload(untaint customer, contentType = "application/json");
            response.statusCode = 200;
        }

        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error writing the customer response for the customer for id: " + customerId, err = result);
        }
    }

    # ---------------------------------------------------------------------------
    # add customer data into the memory
    # ---------------------------------------------------------------------------
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    resource function addCustomer(http:Caller caller, http:Request request) {
        json | error customer = request.getJsonPayload();
        http:Response response = new;

        if (customer is json) {
            int | error customerId = int.convert(customer.id);

            if (customerId is int) {
                json checkCustomer = getCustomerById(customerId);
                if (checkCustomer == null) {
                    //customer is not already in the memory
                    CUSTOMER_DATA[customerId - 1] = customer;

                    json responsePayload = {
                        message: "New customer created for index: " + customerId
                    };
                    response.setJsonPayload(untaint responsePayload, contentType = "application/json");
                    response.statusCode = 200;
                } else {
                    //customer is already in memory
                    json responsePayload = {
                        message: "Customer is already avalable for id: " + customerId
                    };
                    response.setJsonPayload(untaint responsePayload, contentType = "application/json");
                    response.statusCode = 500;
                }
            }
        }

        var result = caller->respond(response);
        if (result is error) {
            log:printError("Error writing response for add new customer", err = result);
        }
    }
}

# ---------------------------------------------------------------------------
# util function: return customer for a given id
# + return - customer data in json format
# ---------------------------------------------------------------------------
function getCustomerById(int customerId) returns (json) {
    foreach json customer in CUSTOMER_DATA {
        (int | error) customerIdRef;
        customerIdRef = int.convert(customer.id);

        if (customerIdRef is int && customerIdRef == customerId) {
            return customer;
        }
    }
}

# ---------------------------------------------------------------------------
# in-memory customer data (demo purpose only)
# ---------------------------------------------------------------------------
json[] CUSTOMER_DATA = [
{ id: 1, name: "Tom Riddle"},
{ id: 2, name: "Stephen Vincent Strange"},
{ id: 3, name: "Bruce Wayne"},
{ id: 4, name: "Albus Dumbledore"},
{ id: 5, name: "Gandalf"}
];
