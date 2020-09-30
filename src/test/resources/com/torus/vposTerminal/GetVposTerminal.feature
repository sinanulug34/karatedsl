@MerchantTerminalService @Torus

Feature: Gets the details of a single instance of a Terminal.

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')

    Scenario: The process has been finished successfully.

        * def result = call read('CreateVpos.feature@CreateVposTerminal')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def vposTerminalId = new java.math.BigDecimal(serviceId)

        Given url MerchantServiceURL
        And path 'vpos-terminals/' + vposTerminalId
        And method get
        Then status 200
        And match each response[*].id == vposTerminalId

    Scenario: Returns Terminal not found if the given id does not exist.

        Given url MerchantServiceURL
        And path 'vpos-terminals/-1'
        And method get
        Then status 404
        And match $response.code == '4001'
        And match $response.description == 'VPOS_TERMINAL_NOT_FOUND'

    Scenario: Returns Bad Request if the given id is string

        Given url MerchantServiceURL
        And path 'vpos-terminals/abc'
        And method get
        Then status 500
