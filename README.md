# wso2-api-micro-gw3-sandbox

This sandbox project contains the required dependencies and code snippets for each scenario to demonstrate WSO2 API MicroGateway 3.x features. You may start to work on the “sandbox” directory and the final version of each scenario is in the “complete” directory.

### 1. Customer Service (Ballerina)
The sandbox project also contains the ballerina implementation of a customer API service for a online store metaphor and the customer API endpoints will be as follows.

|Method |API Context|Description|
|---|---|---|
|GET|/customer|Get all customer data|
|GET|/customer/{customer-id}|Get customer data for a given customer id|
|POST|/customer|Add new customer|

Locate into the `customer_service` directory of the sandbox project and execute the ballerina file `customer_service.bal` to start the customer service.

`ballerina run customer_service.bal`

Once the customer service is started in the port 8080 and you may test the customer API by curl command or you may use your favorite API testing tool ie: Postman.

#### 1.1. Get all customer data
`curl http://localhost:8080/customer`

#### 1.2.Get customer data by customer id
`curl http://localhost:8080/customer/1`

#### 1.3.Add a new customer
`curl -X POST http://localhost:8080/customer -d '{"id": "6", "name": "Harry James Potter"}'`

### 2. API MicroGateway use-cases
#### 2.1. Config based basic authentication
The completed source of the use-case will be available at `completed/basic_auth_sample` directory.

#### 2.2. Request/Response validation
The completed source of the use-case will be available at `completed/request_response_validation` directory.
