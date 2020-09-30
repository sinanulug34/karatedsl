@AcquirerService @Torus

Feature: Gets the details of a single instance of a Acquirer.

    @Smoke
    Scenario: The process has been finished successfully.

        * def result = call read('CreateAcquirer.feature@AcquirerCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def acquirerId = new java.math.BigDecimal(serviceId)
        * def getAcquirerRequestBody = JSON.parse(result.getCreateAcquirersRequest)
        * def name = getAcquirerRequestBody.name
        * def acquirerIdd = getAcquirerRequestBody.acquirerId
        * def description = getAcquirerRequestBody.description
        * def communicatorName = getAcquirerRequestBody.communicatorName
        * def driverName = getAcquirerRequestBody.driverName
        * def controllerName = getAcquirerRequestBody.controllerName
        * def prefName = getAcquirerRequestBody.prefName
        * def dimUidFormatRegex = getAcquirerRequestBody.dimUidFormatRegex
        * def authorizationType = getAcquirerRequestBody.authorizationType
        * def acquirerSecureKey = getAcquirerRequestBody.acquirerSecureKey
        * def otpHandlerName = getAcquirerRequestBody.otpHandlerName

        Given url AcquirerServiceURL
        And path 'acquirers/' + acquirerId
        And method get
        Then status 200
        And match  response.id == acquirerId
        And match  response.acquirerId == acquirerIdd
        And match  response.description == description
        And match  response.communicatorName == communicatorName
        And match  response.driverName == driverName
        And match  response.controllerName == controllerName
        And match  response.prefName == prefName
        And match  response.dimUidFormatRegex == dimUidFormatRegex
        And match  response.authorizationType == authorizationType
        And match  response.acquirerSecureKey == acquirerSecureKey
        And match  response.otpHandlerName == otpHandlerName

    Scenario: Returns Acquirer not found if the given id does not exist.

        Given url AcquirerServiceURL
        And path 'acquirers/-1'
        And method get
        Then status 404
        And match $response.code == '3001'
        And match $response.description == 'ACQUIRER_NOT_FOUND'

    Scenario: Returns Bad Request if the given id is string

        Given url AcquirerServiceURL
        And path 'acquirers/abc'
        And method get
        Then status 500
