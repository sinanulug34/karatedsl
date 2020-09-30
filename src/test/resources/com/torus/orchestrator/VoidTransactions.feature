@XMLApiService  @Torus @orchestrator
Feature: Void Authorization Transaction

    Background:

        * def orchestrator = read('classpath:common/OrchestratorStartTransaction.json')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)
        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

    @SuccessOrchestratorVoid
    Scenario: The process has been finished successfully.

        * def result = call read('SaleTransactions.feature@SuccessOrchestratorAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def transactionId = result.transactionId
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'VOID'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = orderId
        And set orchestrator.transactionId = transactionId
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.amount
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == null


    Scenario: No Void can be made for more than the Auth amount.

        * def result = call read('SaleTransactions.feature@SuccessOrchestratorAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId
        * def Total = getPreAuthOrcestratorRequestBody.amount

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'VOID'
        And set orchestrator.orderId = orderId
        And set orchestrator.amount = Total+1
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == 'Transaction Not Found'

    Scenario: The merchant do not submit same OrderId for void transaction

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'VOID'
        And set orchestrator.orderId = OrderId
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And set orchestrator.merchantId = merchantId
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And remove orchestrator.amount
        And method post
        Then status 200
        Then match $response.errorMessage == 'Order Not Found'

    Scenario: It can be void to an order number that does not exist.

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'VOID'
        And set orchestrator.orderId = OrderId
        And remove orchestrator.cardNumber
        And set orchestrator.merchantId = merchantId
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And remove orchestrator.amount
        And remove orchestrator.cvv
        And method post
        Then status 200
        Then match $response.errorMessage == 'Order Not Found'

    Scenario: PreAuth transaction type can not be Void if it has postAuth

        * def result = call read('PostAuthTransactions.feature@SuccessOrchestratorPOST_AUTH')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId
        * def transactionId = result.transactionId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'VOID'
        And set orchestrator.orderId = orderId
        And set orchestrator.transactionId = transactionId
        And set orchestrator.merchantId = merchantId
        And remove orchestrator.amount
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == null
