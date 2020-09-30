@CommunicatorService  @Torus
Feature: Non secure Refund transactions

    Background:

        * def CommunicatorRequestBody = read('classpath:common/CommunicatorStart.json')
        * def readJavaClass = Java.type('Utility')
        * def OrderNumber = readJavaClass.getRandomNumber(10)

    Scenario: Success Refund Transactions

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startPaymentChannelProcess'
        And set CommunicatorRequestBody.orderId = OrderNumber
        And set CommunicatorRequestBody.acquirerId = 9
        And set CommunicatorRequestBody.acquirerTerminalId = '00123'
        And set CommunicatorRequestBody.acquirerMerchantId = '00123'
        And set CommunicatorRequestBody.transactionType = 'RFND'
        And set CommunicatorRequestBody.transactionId = OrderNumber
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '00'
        And match $response.errorCode == null
        And match $response.acquirerResponseDetail == null

    Scenario: Success Credit Transactions

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startPaymentChannelProcess'
        And set CommunicatorRequestBody.orderId = OrderNumber
        And set CommunicatorRequestBody.acquirerId = 9
        And set CommunicatorRequestBody.acquirerTerminalId = '00123'
        And set CommunicatorRequestBody.acquirerMerchantId = '00123'
        And set CommunicatorRequestBody.transactionType = 'CRED'
        And set CommunicatorRequestBody.transactionId = OrderNumber
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '00'
        And match $response.errorCode == null
        And match $response.acquirerResponseDetail == null

    Scenario: Fail Credit Transactions

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startPaymentChannelProcess'
        And set CommunicatorRequestBody.orderId = OrderNumber
        And set CommunicatorRequestBody.acquirerTerminalId = '99123'
        And set CommunicatorRequestBody.acquirerMerchantId = '99123'
        And set CommunicatorRequestBody.transactionType = 'CRED'
        And set CommunicatorRequestBody.transactionId = OrderNumber
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '99'
        And match $response.acquirerResponseDetail == null

    Scenario: Fail Refund Transactions

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startPaymentChannelProcess'
        And set CommunicatorRequestBody.orderId = OrderNumber
        And set CommunicatorRequestBody.acquirerTerminalId = '99123'
        And set CommunicatorRequestBody.acquirerMerchantId = '99123'
        And set CommunicatorRequestBody.transactionType = 'RFND'
        And set CommunicatorRequestBody.transactionId = OrderNumber
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '99'
        And match $response.acquirerResponseDetail == null
