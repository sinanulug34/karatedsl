@SettlementService @Torus
Feature: Using this service,merchant-batchess can be listed

    Scenario: The process has been finished successfully.
        Given url SettlementServiceURL
        And path 'merchant-batches'
        And method get
        Then status 200

        And match each response[*].id == '#number'
        And match each response[*].acquirerId == '##number'
        And match each response[*].merchantId == '##number'
        And match each response[*].merchantBatchIndex == '##number'
        And match each response[*].status == '##string'
        And match each response[*].openTerminalCount == '##number'
        And match each response[*].terminalBatch == '##number'
        And match each response[*].terminalBatch.errorDetail == '##number'
        And match each response[*].terminalBatch.terminalBatchIndex == '##number'
        And match each response[*].terminalBatch.terminalId == '##number'
        And match each response[*].terminalBatch.merchantBatchIndex == '##number'
        And match each response[*].terminalBatch.errorDetail == '##number'



