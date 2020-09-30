@PaymentQueryService    @Torus
Feature: Using this service, Transaction informations can be updated in given display transaction.

    Background:
        * def UpdateTransactionRequestBody = read('classpath:common/TransactionUpdate.json')
        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')

    Scenario: Update Sale Transaction

        * def result = call read('../paymentProcessing/SaleTransaction.feature@SuccessSale')
        * def orderId = result.SaleTransactionRequestBody.orderId
        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def trxId = executeQuery[0].TRANUID

        Given url PaymentQueryServiceURL
        When request UpdateTransactionRequestBody
        And path 'transactions/' + trxId
        And set UpdateTransactionRequestBody.id = trxId
        And set UpdateTransactionRequestBody.orderId = orderId
        And set UpdateTransactionRequestBody.transactionType = 'PRE'
        And set UpdateTransactionRequestBody.transactionStatus = 'NO'
        Then method put
        Then status 200

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def amount = executeQuery[0].amount
        * def transactionType = executeQuery[0].TRANTYPE
        * def transactionStatus = executeQuery[0].TRANSTATUS

        And match transactionType == 'PRE'
        And match transactionStatus == 'NO'

    Scenario: Update PreAuth Transaction

        * def result = call read('../paymentProcessing/PreAuthTransaction.feature@SuccessPreAuth')
        * def orderId = result.PreAuthTransactionRequestBody.orderId
        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def trxId = executeQuery[0].TRANUID

        Given url PaymentQueryServiceURL
        When request UpdateTransactionRequestBody
        And path 'transactions/' + trxId
        And set UpdateTransactionRequestBody.id = trxId
        And set UpdateTransactionRequestBody.orderId = orderId
        And set UpdateTransactionRequestBody.transactionType = 'SALE'
        And set UpdateTransactionRequestBody.transactionStatus = 'NO'
        Then method put
        Then status 200

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def amount = executeQuery[0].amount
        * def transactionType = executeQuery[0].TRANTYPE
        * def transactionStatus = executeQuery[0].TRANSTATUS

        And match transactionType == 'SALE'
        And match transactionStatus == 'NO'

    Scenario:Invalid transaction number Update validation

        Given url PaymentQueryServiceURL
        When request UpdateTransactionRequestBody
        And path 'transactions/11'
        And method put
        Then status 404
        And match $response.description == 'TRANSACTION_NOT_FOUND'
