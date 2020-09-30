@SettlementService  @Torus
Feature: Using this service,terminal-batchess can be listed

    Scenario: The process has been finished successfully.
        Given url SettlementServiceURL
        And path 'settlement/terminal-batches'
        And method get
        Then status 200


