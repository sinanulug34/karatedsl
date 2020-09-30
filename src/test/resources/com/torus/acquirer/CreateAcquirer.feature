@AcquirerService @Torus

Feature: Create a new instance of a Acquirer

    Background:

        * def createAcquirer = read('classpath:common/CreateAcquirersRequestBody.json')
        * def readJavaClass = Java.type('Utility')


    @AcquirerCreate
    Scenario: The process has been finished successfully.

        * def getCreateAcquirersRequest = readJavaClass.generateCreateAcquirers()

        Given request getCreateAcquirersRequest
        When url AcquirerServiceURL
        And path 'acquirers'
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: acquirerId param must be mandatory field.

        * remove createAcquirer.acquirerId

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'acquirerId must not be null'

    Scenario: acquirerId param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.acquirerId = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: name param must be mandatory field.

        * remove createAcquirer.name

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'name must not be null'

    Scenario: name param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(256)
        * set createAcquirer.name = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'name size must be between 0 and 255'

    Scenario: description param must be optional field.

        * remove createAcquirer.description

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: description param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(256)
        * set createAcquirer.description = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'description size must be between 0 and 255'

    Scenario: communicatorName param must be optional field.

        * remove createAcquirer.communicatorName

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: communicatorName param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createAcquirer.communicatorName = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'communicatorName size must be between 0 and 64'

    Scenario: driverName param must be optional field.

        * remove createAcquirer.driverName

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: driverName param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createAcquirer.driverName = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'driverName size must be between 0 and 64'

    Scenario: controllerName param must be optional field.

        * remove createAcquirer.controllerName

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: controllerName param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createAcquirer.controllerName = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'controllerName size must be between 0 and 64'

    Scenario: prefName param must be optional field.

        * remove createAcquirer.prefName

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: prefName param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createAcquirer.prefName = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'prefName size must be between 0 and 64'

    Scenario: passwordExpiryDuration param must be mandatory field.

        * remove createAcquirer.passwordExpiryDuration

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'passwordExpiryDuration must not be null'

    Scenario: passwordExpiryDuration param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.passwordExpiryDuration = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: passwordExpiryDuration param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.passwordExpiryDuration = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: minimumPasswordLength param must be mandatory field.

        * remove createAcquirer.minimumPasswordLength

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'minimumPasswordLength must not be null'

    Scenario: minimumPasswordLength param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.minimumPasswordLength = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: minimumPasswordLength param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.minimumPasswordLength = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: passwordHistorySize param must be mandatory field.

        * remove createAcquirer.passwordHistorySize

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'passwordHistorySize must not be null'

    Scenario: passwordHistorySize param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.passwordHistorySize = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: passwordHistorySize param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.passwordHistorySize = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: maximumInvalidLogin param must be mandatory field.

        * remove createAcquirer.maximumInvalidLogin

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'maximumInvalidLogin must not be null'

    Scenario: maximumInvalidLogin param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.maximumInvalidLogin = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: maximumInvalidLogin param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.maximumInvalidLogin = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: dimUidFormatRegex param must be mandatory field.

        * remove createAcquirer.dimUidFormatRegex

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'dimUidFormatRegex must not be null'

    Scenario: dimUidFormatRegex param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(256)
        * set createAcquirer.dimUidFormatRegex = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'dimUidFormatRegex size must be between 0 and 255'

    Scenario: reportInterval param must be mandatory field.

        * remove createAcquirer.reportInterval

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'reportInterval must not be null'

    Scenario: reportInterval param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.reportInterval = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: reportInterval param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.reportInterval = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: autoSettlementPriorityDays param must be mandatory field.

        * remove createAcquirer.autoSettlementPriorityDays

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'autoSettlementPriorityDays must not be null'

    Scenario: autoSettlementPriorityDays param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.autoSettlementPriorityDays = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: autoSettlementPriorityDays param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.autoSettlementPriorityDays = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: recurringTransactionMaximumRetryCount param must be mandatory field.

        * remove createAcquirer.recurringTransactionMaximumRetryCount

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'recurringTransactionMaximumRetryCount must not be null'

    Scenario: recurringTransactionMaximumRetryCount param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.recurringTransactionMaximumRetryCount = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: recurringTransactionMaximumRetryCount param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.recurringTransactionMaximumRetryCount = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: recurringTransactionRetryInterval param must be mandatory field.

        * remove createAcquirer.recurringTransactionRetryInterval

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'recurringTransactionRetryInterval must not be null'

    Scenario: recurringTransactionRetryInterval param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.recurringTransactionRetryInterval = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: recurringTransactionRetryInterval param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.recurringTransactionRetryInterval = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: authorizationType param must be mandatory field.

        * remove createAcquirer.authorizationType

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'authorizationType must not be null'

    Scenario: authorizationType param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createAcquirer.authorizationType = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'authorizationType size must be between 0 and 64'

    Scenario: transferPanFormatRegex param must be optional field.

        * remove createAcquirer.transferPanFormatRegex

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: transferPanFormatRegex param must be Alphanumeric max 128 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(129)
        * set createAcquirer.transferPanFormatRegex = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'transferPanFormatRegex size must be between 0 and 128'

    Scenario: acquirerSecureKey param must be optional field.

        * remove createAcquirer.acquirerSecureKey

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: acquirerSecureKey param must be Alphanumeric max 1024 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(1025)
        * set createAcquirer.acquirerSecureKey = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'acquirerSecureKey size must be between 0 and 1024'

    Scenario: otpHandlerName param must be optional field.

        * remove createAcquirer.otpHandlerName

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: otpHandlerName param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(257)
        * set createAcquirer.otpHandlerName = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'otpHandlerName size must be between 0 and 255'

    Scenario: lockDurationInMilliseconds param must be mandatory field.

        * remove createAcquirer.lockDurationInMilliseconds

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'lockDurationInMilliseconds must not be null'

    Scenario: lockDurationInMilliseconds param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.lockDurationInMilliseconds = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: lockDurationInMilliseconds param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.lockDurationInMilliseconds = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: countryCode param must be optional field.

        * remove createAcquirer.countryCode

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: countryCode param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.countryCode = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: orderIdFormatRegex param must be optional field.

        * remove createAcquirer.orderIdFormatRegex

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: orderIdFormatRegex param must be Alphanumeric max 20 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(21)
        * set createAcquirer.orderIdFormatRegex = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'orderIdFormatRegex size must be between 0 and 20'

    Scenario: defaultVposBatchCapacity param must be optional field.

        * remove createAcquirer.defaultVposBatchCapacity

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 201

    Scenario: defaultVposBatchCapacity param must be Numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(64)
        * set createAcquirer.defaultVposBatchCapacity = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: defaultVposBatchCapacity param must be Numeric max 22 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(23)
        * set createAcquirer.defaultVposBatchCapacity = getNumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400

    Scenario: abuIca param must be mandatory field.

        * remove createAcquirer.abuIca

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'abuIca must not be null'

    Scenario: abuIca param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(256)
        * set createAcquirer.abuIca = getAlphanumericCharacter

        Given request createAcquirer
        When url AcquirerServiceURL
        And path 'acquirers'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'abuIca size must be between 0 and 255'
