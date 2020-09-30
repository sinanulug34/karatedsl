@SettlementService  @Torus
Feature: Using this service,total-batchess can be listed

    Scenario: The process has been finished successfully.
        Given url SettlementServiceURL
        And path 'settlement/total-batches'
        And method get
        Then status 200

