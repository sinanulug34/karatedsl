@CommunicatorService  @Torus
Feature: Non secure PreAuth transactions

    Background:

        * def CommunicatorRequestBody = read('classpath:common/CommunicatorStart.json')
        * def readJavaClass = Java.type('Utility')
        * def OrderNumber = readJavaClass.getRandomNumber(10)

    Scenario: Success PostAuth Transactions

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startPaymentChannelProcess'
        And set CommunicatorRequestBody.orderId = OrderNumber
        And set CommunicatorRequestBody.acquirerTerminalId = '00123'
        And set CommunicatorRequestBody.acquirerMerchantId = '00123'
        And set CommunicatorRequestBody.acquirerId = 9
        And set CommunicatorRequestBody.transactionType = 'POST'
        And set CommunicatorRequestBody.transactionId = OrderNumber
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '00'
        And match $response.errorCode == null
        And match $response.acquirerResponseDetail == null

    Scenario: Fail PostAuth Transactions

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startPaymentChannelProcess'
        And set CommunicatorRequestBody.orderId = OrderNumber
        And set CommunicatorRequestBody.acquirerId = 9
        And set CommunicatorRequestBody.acquirerTerminalId = '99123'
        And set CommunicatorRequestBody.acquirerMerchantId = '99123'
        And set CommunicatorRequestBody.transactionType = 'POST'
        And set CommunicatorRequestBody.transactionId = OrderNumber
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '99'
        And match $response.acquirerResponseDetail == null
