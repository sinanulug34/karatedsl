@MerchantTerminalService @Torus
Feature: Gets the details of a single instance of a Terminal.

    @ReleaseVposTerminal
    Scenario: The process has been finished successfully.

        * def releaseVposTerminal = call read('AvailableTerminalsWithVposTerminalId.feature@AvailableTerminalsWithVpos')
        * def vposTerminalId = releaseVposTerminal.vposTerminalId

        Given url MerchantServiceURL
        When request ''
        And path 'vpos-terminals/'+ vposTerminalId + '/release'
        And method put
        Then status 200

    Scenario: Already vpos released terminal id

        * def releaseVposTerminal = call read('AvailableTerminalsWithVposTerminalId.feature@AvailableTerminalsWithVpos')
        * def vposTerminalId = releaseVposTerminal.vposTerminalId

        Given url MerchantServiceURL
        When request ''
        And path 'vpos-terminals/'+ vposTerminalId + '/release'
        And method put
        Then status 200
        Given url MerchantServiceURL
        When request ''
        And path 'vpos-terminals/'+ vposTerminalId + '/release'
        And method put
        Then status 404
        And match $response.description == 'VPOS_TERMINAL_NOT_FOUND'
