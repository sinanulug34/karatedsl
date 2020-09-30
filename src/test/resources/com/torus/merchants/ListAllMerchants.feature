@MerchantTerminalService @Torus

Feature: Using this service, Merchant informations can be accessed in given display order.

    Scenario: The process has been finished successfully.
        Given url MerchantServiceURL
        And path 'merchants'
        And method get
        Then status 200
