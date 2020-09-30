@SettlementService  @Torus
Feature: Using this service,merchant-batchess can be listed
    @Smoke
    Scenario: The process has been finished successfully.
        Given url SettlementServiceURL
        And path 'settlement/merchant-batches'
        And method get
        Then status 200

        And match each response[*].acquirerId == '#number'
        And match each response[*].merchantId == '#string'
        And match each response[*].merchantBatchIndex == '##number'
        And match each response[*].merchantBatchStatus == '##string'
        And match each response[*].openVPosCount == '#number'

