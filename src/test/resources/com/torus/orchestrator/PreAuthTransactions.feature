@Torus @orchestrator
Feature: Pre auth transactions

    Background:

        * def orchestrator = read('classpath:common/OrchestratorStartTransaction.json')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)
        * def TransactionId = readJavaClass.getRandomNumber(10)
        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId


    @SuccessOrchestratorPreAuth
    Scenario: The process has been finished successfully.

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.transactionId = TransactionId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == null

    Scenario: Cvv value must not be null mandatory

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And remove orchestrator.cvv
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == null

    Scenario: Credit card number format must not be included "/"
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242-4242-4242-4242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: CVV value must not be string
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = 'abc'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Invalid Cvv'

    Scenario: Cvv value should be "000"
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == null

    Scenario: Cvv value must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = ''
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == null

    Scenario: Cvv value should be "0000"
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '00'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.errorMessage == 'Invalid Cvv'

    Scenario: Credit card number must not be null

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = ''
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Credit card number as string value control
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = 'abcde'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: Credit card number count should be max 19 char
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '42424242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: Credit card number count should be min 12 char
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '42424242424'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: Expire date value format must be MM.YYYY
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == null

    Scenario: Expire date value format must be MM/YYYY
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12/2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == null

    Scenario: Expire date value format must not be MMYYYY
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '122025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Invalid expire date'

    Scenario: Expire date value must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = ''
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Month value must be in expire date
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '2011'
        Then match $response.errorMessage == 'Invalid expire date'

    Scenario: Year value must be in expiredate
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '2011'
        Then match $response.errorMessage == 'Invalid expire date'

    Scenario: Currency value must be only numeric value
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = 'abc'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '1096'
        Then match $response.errorMessage == 'Currency Code is unsupported'

    Scenario: Currency value must be  3 char
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '99999'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '1096'
        Then match $response.errorMessage == 'Currency Code is unsupported'

    Scenario: Amount value must be only numeric
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = 'abc'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '1095'
        Then match $response.errorMessage == 'Amount is not valid'

    Scenario: Amount value must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = ''
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Request must be included transaction type
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And remove orchestrator.transactionType
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '2014'
        Then match $response.errorMessage == 'Invalid transaction type'

    Scenario: Request must be included merchant name
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And remove orchestrator.userName
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Request must be included password
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And remove orchestrator.password
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Request must be included merchant id
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'PRE_AUTH'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And remove orchestrator.merchantId
        And method post
        Then status 200
        Then match $response.orderId == OrderId
        Then match $response.errorMessage == 'Mandatory values are empty'
