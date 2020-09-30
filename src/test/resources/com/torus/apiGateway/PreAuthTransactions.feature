@XMLApiService  @Torus @apigateway
Feature: Pre auth transactions

    Background:

        * def PreAuth = read('classpath:common/CC5RequestBody.xml')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)
        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

    @SuccessXmlPreAuth
    Scenario: The process has been finished successfully.

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
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Cvv must not be mandatory field
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4242424242424242'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And remove PreAuth//Cvv2Val
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Credit card field control
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = ''
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode == '99'

    Scenario: Credit card field control -2
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = 'abcde'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Card Number format is invalid'
        Then match //ProcReturnCode == '99'

    Scenario: Credit card field control -3
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4242424242424242424242424242424'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Card Number format is invalid'
        Then match //ProcReturnCode == '99'

    Scenario: Cvv2 value must be numeric
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4242424242424242'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = 'abc'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //ErrMsg == 'Invalid Cvv'

    Scenario: Cvv2 value format is success
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Cvv2 value as null
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Cvv2Val = ''
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Cvv2 value is success -2
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '0000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Expire date value format should be MM.YYYY
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Expire date value format should be MM/YYYY
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12/2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Expire date value format should not be MMYYYY
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '122025'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //ErrMsg == 'Invalid expire date'

    Scenario: Expire date value as null
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = ''
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //ErrMsg == 'Mandatory values are empty'

    Scenario: Send request without month value
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '.25'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Invalid expire date'
        Then match //ProcReturnCode == '99'

    Scenario: Send request without year value
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Invalid expire date'
        Then match //ProcReturnCode == '99'

    Scenario: Send request with invalid card number
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111-1111-1111-1111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Card Number format is invalid'
        Then match //ProcReturnCode == '99'

    Scenario: Currency value as null
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = ''
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode == '99'

    Scenario: Currency value must be only numeric
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = 'abc'
        And method post
        Then status 200
        Then match //ErrMsg == 'Currency Code is unsupported'
        Then match //ProcReturnCode == '99'

    Scenario: Currency value invalid control
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '99999'
        And method post
        Then status 200
        Then match //ErrMsg == 'Currency Code is unsupported'
        Then match //ProcReturnCode == '99'

    Scenario: Total value must be only numeric
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = 'abc'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Amount is not valid'
        Then match //ProcReturnCode == '99'

    Scenario: Total value as null
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = ''
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode == '99'

    Scenario: Order id value as null
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = ''
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

    Scenario: Total value as string
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = 'abc'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ErrMsg == 'Amount is not valid'
        Then match //ProcReturnCode == '99'

    Scenario: Send request without transaction type
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = ''
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = '10'
        And set PreAuth//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'
        Then match //ErrMsg == 'Invalid request format'

    Scenario: Send request without name
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = 'abc'
        And set PreAuth//Currency = '949'
        And remove PreAuth//Name
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode == '99'

    Scenario: Send request without password
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = 'abc'
        And set PreAuth//Currency = '949'
        And remove PreAuth//Password
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode == '99'

    Scenario: Send request without client id
        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Number = '4111111111111111'
        And set PreAuth//Type = 'PreAuth'
        And set PreAuth//OrderId = OrderId
        And set PreAuth//Expires = '12.2025'
        And set PreAuth//Cvv2Val = '000'
        And set PreAuth//Total = 'abc'
        And set PreAuth//Currency = '949'
        And remove PreAuth//ClientId
        And method post
        Then status 200
        Then match //ErrMsg == 'Mandatory values are empty'
        Then match //ProcReturnCode == '99'


    Scenario: Second Post Auth record that is sent after preauth record should be DECLINE by system

        * def result = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def getPreAuthRequestBody = result.PreAuth
        * def orderId = getPreAuthRequestBody.CC5Request.OrderId
        * def clientId = getPreAuthRequestBody.CC5Request.ClientId

        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Type = 'PostAuth'
        And set PreAuth//OrderId = orderId
        And set PreAuth//ClientId = clientId
        And remove PreAuth//Number
        And remove PreAuth//Expires
        And remove PreAuth//Cvv2Val
        And remove PreAuth//Total
        And remove PreAuth//Currency
        And remove PreAuth//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Type = 'PostAuth'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = orderId
        And remove PreAuth//Number
        And remove PreAuth//Expires
        And remove PreAuth//Cvv2Val
        And remove PreAuth//Total
        And remove PreAuth//Currency
        And remove PreAuth//Extra
        And method post
        Then match //ProcReturnCode == '99'
        Then match //ErrMsg == 'Order Not Found'


    Scenario: Second Void record that is sent after preauth record should be DECLINE by system

        * def result = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def getPreAuthRequestBody = result.PreAuth
        * def orderId = getPreAuthRequestBody.CC5Request.OrderId
        * def clientId = getPreAuthRequestBody.CC5Request.ClientId

        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Type = 'Void'
        And set PreAuth//OrderId = orderId
        And set PreAuth//ClientId = clientId
        And remove PreAuth//Number
        And remove PreAuth//Expires
        And remove PreAuth//Cvv2Val
        And remove PreAuth//Total
        And remove PreAuth//Currency
        And remove PreAuth//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Type = 'Void'
        And set PreAuth//ClientId = merchantId
        And set PreAuth//OrderId = orderId
        And remove PreAuth//Number
        And remove PreAuth//Expires
        And remove PreAuth//Cvv2Val
        And remove PreAuth//Total
        And remove PreAuth//Currency
        And remove PreAuth//Extra
        And method post
        Then match //ProcReturnCode == '99'

    Scenario: no refund record that is sent after preauth record should be DECLINE by system

        * def result = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def getPreAuthRequestBody = result.PreAuth
        * def orderId = getPreAuthRequestBody.CC5Request.OrderId
        * def clientId = getPreAuthRequestBody.CC5Request.ClientId


        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Type = 'Credit'
        And set PreAuth//ClientId = clientId
        And set PreAuth//OrderId = orderId
        And remove PreAuth//Number
        And remove PreAuth//Expires
        And remove PreAuth//Cvv2Val
        And remove PreAuth//Total
        And remove PreAuth//Currency
        And remove PreAuth//Extra
        And method post
        Then status 200
        Then match //ProcReturnCode == '99'

    Scenario:Second refund records that are sent after post auth records should be DECLINE by system

        * def result = call read('PostAuthTransactions.feature@SuccessXmlPostAuth')
        * def getPostAuthRequestBody = result.xmlApiConverter
        * def orderId = getPostAuthRequestBody.CC5Request.OrderId
        * def clientId = getPostAuthRequestBody.CC5Request.ClientId


        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Type = 'Credit'
        And set PreAuth//ClientId = clientId
        And set PreAuth//OrderId = orderId
        And remove PreAuth//Number
        And remove PreAuth//Expires
        And remove PreAuth//Cvv2Val
        And remove PreAuth//Total
        And remove PreAuth//Currency
        And remove PreAuth//Extra
        And method post
        Then match //ProcReturnCode == '00'
        Then match //Response == 'APPROVED'

        Given request PreAuth
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set PreAuth//Type = 'Credit'
        And set PreAuth//OrderId = orderId
        And set PreAuth//ClientId = merchantId
        And remove PreAuth//Number
        And remove PreAuth//Expires
        And remove PreAuth//Cvv2Val
        And remove PreAuth//Total
        And remove PreAuth//Currency
        And remove PreAuth//Extra
        And method post
        Then match //ProcReturnCode == '99'
