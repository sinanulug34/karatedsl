@AcquirerService @Torus

Feature:  Using this service, Updates an existing Acquirer..

    Background:

        * def readJavaClass = Java.type('Utility')
        * def generateNewRequestBody = readJavaClass.generateCreateAcquirers()

    Scenario: The process has been finished successfully.

        * def result = call read('CreateAcquirer.feature@AcquirerCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def acquirerId = new java.math.BigDecimal(serviceId)

        Given url AcquirerServiceURL
        When request generateNewRequestBody
        And path 'acquirers/' + acquirerId
        And header Content-Type = 'application/json'
        And method put
        Then status 200

    Scenario: Returns Acquirer not found if the given id does not exist.

        Given url AcquirerServiceURL
        When request generateNewRequestBody
        And header Content-Type = 'application/json'
        And path 'acquirers/-1'
        And method put
        Then status 404
        And match $response.code == '3001'
        And match $response.description == 'ACQUIRER_NOT_FOUND'

    Scenario: Returns Bad Request if the given id is string

        Given url AcquirerServiceURL
        When request generateNewRequestBody
        And header Content-Type = 'application/json'
        And path 'acquirers/abc'
        And method get
        Then status 500
