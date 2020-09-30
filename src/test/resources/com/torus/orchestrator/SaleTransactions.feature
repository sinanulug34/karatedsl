@Torus @orchestrator
Feature: Xml api converter transactions

    Background:
        * def orchestrator = read('classpath:common/OrchestratorStartTransaction.json')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)
        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchant')
        * def merchantId = result.merchantId

    @SuccessOrchestratorAuth    @Smoke
    Scenario: The process has been finished successfully.
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '5454545454545454'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.transactionId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Cvv value must not be mandatory
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '5454545454545454'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And remove orchestrator.cvv
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Expire date must be included month value
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '5454545454545454'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '.25'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '2011'
        Then match $response.errorMessage == 'Invalid expire date'

    Scenario: Expired Date control
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2012'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '2011'
        Then match $response.errorMessage == 'Invalid expire date'

    Scenario: Credit card number must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = ''
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Credit card number must not be string value
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = 'abcde'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1097'
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: Credit card value must max 13 char.
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '424242424242'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1097'
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: If credit card value max 19 chars.
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '42424242424242424242'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1097'
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: If credit card value sent 19 chars (for debit card), transaction must be success.
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242424'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Cvv value must be numeric
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4242424242424242'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = 'abc'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '2515'
        Then match $response.errorMessage == 'Invalid Cvv'

    Scenario: Cvv value must be "000"
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Cvv value must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = ''
        And set orchestrator.merchantId = merchantId
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Cvv value must be "0000"
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '0000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Expire date value format must be MM.YYYY
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Expire date value format must be MM/YYYY
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12/2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorMessage == null

    Scenario: Expire date value format must not be MMYYYY
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '122025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '2011'
        Then match $response.errorMessage == 'Invalid expire date'

    Scenario: Expire date value must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = ''
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario:Expire date must be included year value
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '2011'
        Then match $response.errorMessage == 'Invalid expire date'

    Scenario: Credit card must not be included "-"
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111-1111-1111-1111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1097'
        Then match $response.errorMessage == 'Card Number format is invalid'

    Scenario: Currency value must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = ''
        And method post
        Then status 200
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Currency value must be only numeric
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = 'abc'
        And method post
        Then status 200
        Then match $response.errorCode == '1096'
        Then match $response.errorMessage == 'Currency Code is unsupported'

    Scenario: Currency value must be 3 char
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '99999'
        And method post
        Then status 200
        Then match $response.errorCode == '1096'
        Then match $response.errorMessage == 'Currency Code is unsupported'

    Scenario: Amount value must be only numeric
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = 'abc'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1095'
        Then match $response.errorMessage == 'Amount is not valid'

    Scenario: Order id and transaction id value must not be null
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.transactionId = ''
        And set orchestrator.orderId = ''
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200

    Scenario: Amount value must be string
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = 'abc'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '1095'
        Then match $response.errorMessage == 'Amount is not valid'

    Scenario: Request must be included transaction type
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = ''
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then status 200
        Then match $response.errorCode == '2014'
        Then match $response.errorMessage == 'Invalid transaction type'

    Scenario: Request must be included user name
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.currency = '949'
        And remove orchestrator.userName
        And method post
        Then status 200
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Request must be included password
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And remove orchestrator.password
        And method post
        Then status 200
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario: Request must be included client id
        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.transactionType = 'SALE'
        And set orchestrator.orderId = OrderId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And remove orchestrator.merchantId
        And method post
        Then status 200
        Then match $response.errorCode == '1099'
        Then match $response.errorMessage == 'Mandatory values are empty'

    Scenario:Second credit records that are sent after auth records should be DECLINE by system

        * def result = call read('SaleTransactions.feature@SuccessOrchestratorAuth')
        * def getAuthRequestOrchestratorBody = result.orchestrator
        * def orderId = getAuthRequestOrchestratorBody.orderId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'CREDIT'
        And set orchestrator.orderId = orderId
        And set orchestrator.cardNumber = '4111111111111111'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.errorMessage == 'Order Not Found'

    Scenario:Second void records that are sent after auth records should be DECLINE by system

        * def result = call read('SaleTransactions.feature@SuccessOrchestratorAuth')
        * def getAuthRequestOrchestratorBody = result.orchestrator
        * def orderId = getAuthRequestOrchestratorBody.orderId

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'VOID'
        And remove orchestrator.transactionId
        And set orchestrator.orderId = orderId
        And set orchestrator.merchantId = merchantId
        And set orchestrator.cardNumber = '5454545454545454'
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.errorMessage == 'Order Not Found'

        Given request orchestrator
        When url OrchestratorServiceURL
        And path 'orchestrator/start-transaction'
        And set orchestrator.transactionType = 'VOID'
        And remove orchestrator.transactionId
        And set orchestrator.orderId = orderId
        And set orchestrator.cardNumber = '5454545454545454'
        And set orchestrator.merchantId = merchantId
        And set orchestrator.expiryDate = '12.2025'
        And set orchestrator.cvv = '000'
        And set orchestrator.amount = '10'
        And set orchestrator.currency = '949'
        And method post
        Then match $response.errorCode == '5002'
        Then match $response.errorMessage == 'Order Not Found'
