@XMLApiService  @Torus @apigateway
Feature: Post Authorization Transaction

    Background:

        * def xmlApiConverter = read('classpath:common/CC5RequestBody.xml')
        * def xmlApiConverterECOM = read('classpath:common/EcomRequestBody.xml')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """
    @SuccessXmlPostAuth
    Scenario: The process has been finished successfully.

        * def result = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def getPreAuthRequestBody = result.PreAuth
        * def orderId = getPreAuthRequestBody.CC5Request.OrderId
        * def merchantId = getPreAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'PostAuth'
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//ClientId = merchantId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'

    Scenario: PostAuth can only be done for a related PreAuth.

        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'PostAuth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //ErrMsg == 'Order Not Found'

    Scenario: Partial PostAuth.

        * def result = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def getPreAuthRequestBody = result.PreAuth
        * def orderId = getPreAuthRequestBody.CC5Request.OrderId
        * def Total = getPreAuthRequestBody.CC5Request.Total
        * def merchantId = getPreAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'PostAuth'
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Total = Total/2
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

        * call sleep 20

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'PostAuth'
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//Total = Total/2
        And set xmlApiConverter//ClientId = merchantId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: No postAuth can be made for more than the preAuth amount.

        * def result = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def getPreAuthRequestBody = result.PreAuth
        * def orderId = getPreAuthRequestBody.CC5Request.OrderId
        * def Total = getPreAuthRequestBody.CC5Request.Total
        * def merchantId = getPreAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'

        And set xmlApiConverter//Type = 'PostAuth'
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//Total = Total + 1
        And set xmlApiConverter//ClientId = merchantId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //Response == 'DECLINED'

    Scenario: If card information is sent in PostAuth transaction and it doesnt same as card information of PreAuth transaction. PostAuth must not be succesfull.

        * def result = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def getPreAuthRequestBody = result.PreAuth
        * def orderId = getPreAuthRequestBody.CC5Request.OrderId
        * def cardNumber = getPreAuthRequestBody.CC5Request.Number
        * def merchantId = getPreAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'PostAuth'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//Number = '4111111111111111'
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

