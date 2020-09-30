@MerchantTerminalService @Torus
Feature:  Using this service, Vpos Terminals informations can be accessed in given display order.

    @ListAllVposTerminal
    Scenario: The process has been finished successfully.

        Given url MerchantServiceURL
        And path 'vpos-terminals'
        And method get
        Then status 200

        And match each response[*].acquirerVposTerminalId == '##string'
        And match each response[*].acquirerMerchantId == '##string'
        And match each response[*].vposTerminalBatchId == '##number'
        And match each response[*].stan == '##number'
        And match each response[*].status == '##string'
        And match each response[*].activeTransactionCount == '#number'
        And match each response[*].batchCapacity == '##number'



