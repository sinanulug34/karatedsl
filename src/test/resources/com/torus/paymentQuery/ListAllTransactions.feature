@PaymentQueryService @Torus

Feature: Using this service, Transaction informations can be accessed in given display transaction.
    @Smoke
    Scenario: The process has been finished successfully.
        Given url PaymentQueryServiceURL
        And path 'transactions'
        And method get
        Then status 200

        And match each response[*].id == '#string'
        And match each response[*].orderId == '##string'
        And match each response[*].creditCard.cardNumber == '##string'
        And match each response[*].creditCard.cvv == '##string'
        And match each response[*].creditCard.expiryDate == '##string'
        And match each response[*].creditCard.cardHolder == '##string'
        And match each response[*].creditCard.cardBin == '##string'
        And match each response[*].acquirer.acquirerId == '#number'
        And match each response[*].acquirer.acquirerStan == '##string'
        And match each response[*].acquirer.acquirerRrn == '##string'
        And match each response[*].transactionType == '##string'
        And match each response[*].transactionStatus == '##string'
        And match each response[*].amount == '##number'
        And match each response[*].currency == '##string'
        And match each response[*].authorizationNumber == '##string'
        And match each response[*].bankResponseCode == '##number'
        And match each response[*].bankResponseDetail == '##string'
        And match each response[*].merchantId == '##string'
        And match each response[*].terminalId == '#number'
        And match each response[*].canVoid == '#boolean'
