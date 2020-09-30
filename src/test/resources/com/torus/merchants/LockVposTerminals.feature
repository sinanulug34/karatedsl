@MerchantTerminalService @Torus

Feature: Lock vpos terminals

    Background:
        * def PreAuth = read('classpath:common/CC5RequestBody.xml')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)

    @SuccessLockedVposTerminals
    Scenario: The process has been finished successfully.

        * def result = call read('CreateMerchantVposTerminal.feature@CreateMerchantVpos')
        * def merchantId = result.createVposTerminalToMerchant.merchantId

        Given url MerchantServiceURL
        When request ''
        And path 'merchants/' + merchantId + '/lock-merchant-terminals'
        And method post
        Then status 200

        And match each response[*].status == 'BATCH_IN_PROGRESS'
        And match each response[*].vposTerminalBatchLock == 'TRUE'

    Scenario: If the merchant vpos terminals locked,transaction must not be successful

        * def result = call read('CreateMerchantVposTerminal.feature@CreateMerchantVpos')
        * def merchantId = result.createVposTerminalToMerchant.merchantId


        Given url MerchantServiceURL
        When request ''
        And path 'merchants/' + merchantId + '/lock-merchant-terminals'
        And method post
        Then status 200

        And match each response[*].status == 'BATCH_IN_PROGRESS'
        And match each response[*].vposTerminalBatchLock == 'TRUE'


        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4242424242424242'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //Response == 'DECLINED'

