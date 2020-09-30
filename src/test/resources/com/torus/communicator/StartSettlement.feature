@CommunicatorService  @Torus
Feature: Start Settlement transaction to Communicator service

    Background:

        * def CommunicatorRequestBody = read('classpath:common/CommunicatorStartSettlementRequestBody.json')
        * def readJavaClass = Java.type('Utility')
        * def OrderNumber = readJavaClass.getRandomNumber(10)
    @Smoke
    Scenario: Success settlement

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startSettlementProcess'
        And set CommunicatorRequestBody[0].transactionId = OrderNumber
        And set CommunicatorRequestBody[0].acquirerTerminalId = '00123'
        And set CommunicatorRequestBody[0].acquirerMerchantId = '00123'
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '00'
        And match $response.errorCode == null

    Scenario: Fail settlement

        Given url CommunicatorServiceURL
        When request  CommunicatorRequestBody
        And path 'communicator-service/startSettlementProcess'
        And set CommunicatorRequestBody[0].transactionId = OrderNumber
        And set CommunicatorRequestBody[0].acquirerTerminalId = ''
        And set CommunicatorRequestBody[0].acquirerMerchantId = ''
        And method post
        Then status 200
        And match $response.transactionId == OrderNumber
        And match $response.acquirerResponseCode == '99'
        And match $response.errorCode == 'ISO8583-99'
