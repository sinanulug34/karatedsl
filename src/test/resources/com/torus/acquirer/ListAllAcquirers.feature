@AcquirerService @Torus

Feature:  Using this service, Acquirers informations can be accessed in given display order.

    @Smoke
    Scenario: The process has been finished successfully.

        Given url AcquirerServiceURL
        And path 'acquirers'
        And method get
        Then status 200

        And match each response[*].acquirerId == '#number'
        And match each response[*].name == '#string'
        And match each response[*].description == '##string'
        And match each response[*].communicatorName == '##string'
        And match each response[*].driverName == '##string'
        And match each response[*].controllerName == '##string'
        And match each response[*].prefName == '##string'
        And match each response[*].passwordExpiryDuration == '##number'
        And match each response[*].minimumPasswordLength == '##number'
        And match each response[*].passwordHistorySize == '##number'
        And match each response[*].maximumInvalidLogin == '##number'
        And match each response[*].dimUidFormatRegex == '##string'
        And match each response[*].reportInterval == '#number'
        And match each response[*].autoSettlementPriorityDays == '#number'
        And match each response[*].recurringTransactionMaximumRetryCount == '#number'
        And match each response[*].recurringTransactionRetryInterval == '#number'
        And match each response[*].authorizationType == '#string'
        And match each response[*].transferPanFormatRegex == '##string'
        And match each response[*].acquirerSecureKey == '##string'
        And match each response[*].otpHandlerName == '##string'
        And match each response[*].lockDurationInMilliseconds == '#number'
        And match each response[*].countryCode == '##number'
        And match each response[*].orderIdFormatRegex == '##string'
        And match each response[*].defaultVposBatchCapacity == '##number'
        And match each response[*].abuIca == '##string'
