@PaymentQueryService    @Torus
Feature: Using this service, Transaction informations can be accessed in given display transaction.

    Scenario: Get a Transaction

        * def result = call read('../paymentProcessing/SaleTransaction.feature@SuccessSale')
        * def orderId = result.SaleTransactionRequestBody.orderId
        * def amount = result.SaleTransactionRequestBody.amount
        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def trxId = executeQuery[0].TRANUID

        Given url PaymentQueryServiceURL
        When path 'transactions/' + trxId
        Then method get
        Then status 200
        And match $response.id == trxId
        And match $response.orderId == orderId
        And match $response.amount == amount

    Scenario: Get a Transaction With Not Exist TRANUID

        Given url PaymentQueryServiceURL
        When path 'transactions/abc'
        Then method get
        Then status 404
        And match $response.description == 'TRANSACTION_NOT_FOUND'


