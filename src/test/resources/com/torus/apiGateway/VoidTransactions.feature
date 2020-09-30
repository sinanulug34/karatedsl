@XMLApiService  @Torus @apigateway
Feature: Void Authorization Transaction

    Background:

        * def xmlApiConverter = read('classpath:common/CC5RequestBody.xml')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)
        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

    @SuccessVoidTransaction
    Scenario: The process has been finished successfully.

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def orderId = getAuthRequestBody.CC5Request.OrderId
        * def merchantId = getAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Void'
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
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


    Scenario: No Void can be made for more than the Auth amount.

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def orderId = getAuthRequestBody.CC5Request.OrderId
        * def merchantId = getAuthRequestBody.CC5Request.ClientId
        * def Total = getAuthRequestBody.CC5Request.Total

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Void'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//Total = Total+1
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'

    Scenario: It can be void to an order number that does not exist.

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = OrderId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Cvv2Val
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'

    Scenario: PreAuth transaction type can not be Void if it has postAuth

        * def result = call read('PostAuthTransactions.feature@SuccessXmlPostAuth')
        * def getPostAuthRequestBody = result.xmlApiConverter
        * def merchantId = getPostAuthRequestBody.CC5Request.ClientId
        * def orderId = getPostAuthRequestBody.CC5Request.OrderId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Void'
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//ClientId = merchantId
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


