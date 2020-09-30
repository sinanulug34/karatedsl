@XMLApiService  @Torus @apigateway
Feature: Refund Transaction

    Background:

        * def xmlApiConverter = read('classpath:common/CC5RequestBody.xml')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """
    @SuccessRefundTransaction
    Scenario: The process has been finished successfully.

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def orderId = getAuthRequestBody.CC5Request.OrderId
        * def merchantId = getAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Credit'
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
        Then match //Response == 'APPROVED'



    Scenario: No refund can be made for more than the sale amount.

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def orderId = getAuthRequestBody.CC5Request.OrderId
        * def Total = getAuthRequestBody.CC5Request.Total
        * def merchantId = getAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//Total = Total + 1
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'

    Scenario: It can be refund to an order number that does not match.

        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4242424242424242'
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And remove xmlApiConverter//Cvv2Val
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: if the order number is empty and card information is available, a refund can be made.

        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4242424242424242'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//OrderId = ''
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And remove xmlApiConverter//Cvv2Val
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'


    Scenario: It is not possible to refund a non-order number without card information and amount.

        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = OrderId
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And remove xmlApiConverter//Number
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //Response == 'DECLINED'

    Scenario: Partial Refund.

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def orderId = getAuthRequestBody.CC5Request.OrderId
        * def merchantId = getAuthRequestBody.CC5Request.ClientId
        * def Total = getAuthRequestBody.CC5Request.Total

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
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
        And set xmlApiConverter//Type = 'Credit'
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


