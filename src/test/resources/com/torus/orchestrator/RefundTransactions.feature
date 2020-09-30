@Torus @orchestrator
Feature: Refund Transaction

    Background:

        * def orchestrator = read('classpath:common/OrchestratorStartTransaction.json')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    @SuccessOrchestratorRefund
    Scenario: The process has been finished successfully.

        * def result = call read('SaleTransactions.feature@SuccessOrchestratorAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'CREDIT'
        And set orchestrator.orderId = orderId
        And set orchestrator.merchantId = merchantId
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.amount
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: No refund can be made for more than the sale amount.

        * def result = call read('SaleTransactions.feature@SuccessOrchestratorAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def Total = getPreAuthOrcestratorRequestBody.amount
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'CREDIT'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = orderId
        And set orchestrator.amount = Total + 1
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorCode == '5022'
        Then match $response.errorMessage == 'Amount Is More Than Net Amount'

    Scenario: It is not possible to refund a non-order number without card information and amount.

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'CREDIT'
        And set orchestrator.orderId = OrderId
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And remove orchestrator.cardNumber
        And method post
        Then status 200
        Then match $response.errorCode == '1095'
        Then match $response.errorMessage == 'Amount is not valid'

    Scenario: Partial Refund.

        * def result = call read('SaleTransactions.feature@SuccessOrchestratorAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def Total = getPreAuthOrcestratorRequestBody.amount
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'CREDIT'
        And set orchestrator.orderId = orderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = Total/2
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == null

        * call sleep 20

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'CREDIT'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = orderId
        And set orchestrator.amount = Total/2
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == null

