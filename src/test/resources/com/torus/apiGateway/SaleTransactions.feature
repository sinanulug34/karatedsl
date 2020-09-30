@XMLApiService  @Torus @apigateway
Feature: Xml api converter transactions

    Background:

        * def xmlApiConverter = read('classpath:common/CC5RequestBody.xml')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)
        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

    @SuccessXmlAuth @Smoke
    Scenario: The process has been finished successfully.

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '5454545454545454'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


    Scenario: Cvv value must not be mandatory

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '5454545454545454'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And remove xmlApiConverter//Cvv2Val
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


    Scenario: Send request with invalid expire date
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '5454545454545454'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '.25'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'
        Then match //ErrMsg == 'Invalid expire date'

    Scenario: Send request with expired date
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4242424242424242'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2012'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'
        Then match //ErrMsg == 'Invalid expire date'

    Scenario: The merchant submit same OrderId for sale transaction

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def orderId = getAuthRequestBody.CC5Request.OrderId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4242424242424242'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'

    Scenario: If credit card value is null,response code should be 99

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = ''
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'
        Then match //ErrMsg == 'Mandatory values are empty'

    Scenario: If credit card value is string,response code should be 99

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = 'abcde'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Card Number format is invalid'
        Then match //ProcReturnCode  == '99'

    Scenario: If credit card value min 13 chars
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '424242424242'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Card Number format is invalid'
        Then match //ProcReturnCode  == '99'

    Scenario: If credit card value max 19 chars
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '42424242424242424242'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Card Number format is invalid'
        Then match //ProcReturnCode  == '99'

    Scenario: If credit card value sent 19 chars (for debit card), transaction must be success.
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4242424242424242424'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


    Scenario: Cvv2 value must be numeric
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4242424242424242'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = 'abc'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'
        Then match //ErrMsg == 'Invalid Cvv'

    Scenario: Cvv2 value is "000"
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'

    Scenario: Cvv2 value is null
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = ''
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'

    Scenario: Cvv2 value is "0000"
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '0000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


    Scenario: Expire date value format should be MM.YYYY
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


    Scenario: Expire date value format should be MM/YYYY
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12/2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


    Scenario: Expire date value format should not be MMYYYY
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '122025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'
        Then match //ErrMsg == 'Invalid expire date'

    Scenario: Expire date value is null
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = ''
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'
        Then match //ErrMsg == 'Mandatory values are empty'

    Scenario: Send request without month value
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '.25'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Invalid expire date'
        Then match //ProcReturnCode  == '99'

    Scenario: Send request without year value
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Invalid expire date'
        Then match //ProcReturnCode  == '99'

    Scenario: Send request with invalid card number
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111-1111-1111-1111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Card Number format is invalid'
        Then match //ProcReturnCode  == '99'

    Scenario: Currency value is null
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = ''
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode  == '99'

    Scenario: Currency value must be only numeric
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = 'abc'
        And method post
        Then status 200
        Then match //ErrMsg == 'Currency Code is unsupported'
        Then match //ProcReturnCode  == '99'

    Scenario: Currency value invalid control
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '99999'
        And method post
        Then status 200
        Then match //ErrMsg == 'Currency Code is unsupported'
        Then match //ProcReturnCode  == '99'

    Scenario: Total value must be only numeric
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = 'abc'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Amount is not valid'
        Then match //ProcReturnCode  == '99'

    Scenario: Total value is null
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = ''
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode  == '99'

    Scenario: Order id value is null
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = ''
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'

    Scenario: Total value as string
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = 'abc'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Amount is not valid'
        Then match //ProcReturnCode  == '99'

    Scenario: Send request without transaction type
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = ''
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '99'
        Then match //ErrMsg == 'Invalid request format'

    Scenario: Send request without name field
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And remove xmlApiConverter//Name
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode  == '99'

    Scenario: Send request without name
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Name = ''
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode  == '99'

    Scenario: Send request without password field
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And remove xmlApiConverter//Password
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode  == '99'

    Scenario: Send request without password
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And remove xmlApiConverter//Password
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode  == '99'

    Scenario: Send request without client id field
        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '4111111111111111'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And remove xmlApiConverter//ClientId
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode  == '99'

    Scenario:Second credit records that are sent after auth records should be DECLINE by system

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def orderId = getAuthRequestBody.CC5Request.OrderId
        * def merchantId = getAuthRequestBody.CC5Request.ClientId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Credit'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then match //ProcReturnCode  == '99'

    Scenario:Second void records that are sent after auth records should be DECLINE by system

        * def result = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def getAuthRequestBody = result.xmlApiConverter
        * def merchantId = getAuthRequestBody.CC5Request.ClientId
        * def orderId = getAuthRequestBody.CC5Request.OrderId

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Void'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'


        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Type = 'Void'
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//OrderId = orderId
        And remove xmlApiConverter//Number
        And remove xmlApiConverter//Expires
        And remove xmlApiConverter//Cvv2Val
        And remove xmlApiConverter//Total
        And remove xmlApiConverter//Currency
        And remove xmlApiConverter//Extra
        And method post
        Then match //ProcReturnCode  == '99'
