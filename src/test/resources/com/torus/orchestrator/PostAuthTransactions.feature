@Torus @orchestrator
Feature: Post Authorization Transaction

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

    @SuccessOrchestratorPOST_AUTH
    Scenario: The process has been finished successfully.

        * def result = call read('PreAuthTransactions.feature@SuccessOrchestratorPreAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'POST_AUTH'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = orderId
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.amount
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == null


    Scenario: POST_AUTH can only be done for a related PreAuth.

        * def result = call read('PreAuthTransactions.feature@SuccessOrchestratorPreAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'POST_AUTH'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And remove orchestrator.cardNumber
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.amount
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == 'Order Not Found'


    Scenario: Partial POST_AUTH.
        * def result = call read('PreAuthTransactions.feature@SuccessOrchestratorPreAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def amount = getPreAuthOrcestratorRequestBody.amount
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'POST_AUTH'
        And set orchestrator.orderId = orderId
        And set orchestrator.amount = amount/2
        And remove orchestrator.cardNumber
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And remove orchestrator.expiryDate
        And method post
        Then status 200
        Then match $response.errorMessage == null

        * call sleep 20

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'POST_AUTH'
        And set orchestrator.orderId = orderId
        And set orchestrator.amount = amount/2
        And remove orchestrator.number
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And remove orchestrator.expiryDate
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: No postAuth can be made for more than the preAuth amount.

        * def result = call read('PreAuthTransactions.feature@SuccessOrchestratorPreAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId
        * def amount = getPreAuthOrcestratorRequestBody.amount

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'

        And set orchestrator.transactionType = 'POST_AUTH'
        And set orchestrator.orderId = orderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = amount + 1
        And remove orchestrator.cardNumber
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And remove orchestrator.expiryDate
        And method post
        Then status 200
        Then match $response.errorMessage == 'Invalid Amount'

    Scenario: No PostAuth can be made without the preAuth without orderid and transactionid

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'POST_AUTH'
        And set orchestrator.amount = 10
        And set orchestrator.transactionId = ''
        And set orchestrator.orderId = ''
        And remove orchestrator.cardNumber
        And remove orchestrator.cvv
        And remove orchestrator.currency
        And remove orchestrator.expiryDate
        And method post
        Then status 200
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: If card information is sent in POST_AUTH transaction and it doesnt same as card information of PreAuth transaction. POST_AUTH must not be succesfull.

        * def result = call read('PreAuthTransactions.feature@SuccessOrchestratorPreAuth')
        * def getPreAuthOrcestratorRequestBody = result.orchestrator
        * def orderId = getPreAuthOrcestratorRequestBody.orderId
        * def cardNumber = getPreAuthOrcestratorRequestBody.cardNumber
        * def merchantId = getPreAuthOrcestratorRequestBody.merchantId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'POST_AUTH'
        And set orchestrator.orderId = orderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cardNumber = '4111111111111111'
        And remove orchestrator.expiryDate
        And remove orchestrator.cvv
        And remove orchestrator.amount
        And remove orchestrator.currency
        And method post
        Then status 200
        Then match $response.errorMessage == null
