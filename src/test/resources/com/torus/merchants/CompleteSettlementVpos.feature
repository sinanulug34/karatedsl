@MerchantTerminalService @Torus

Feature: Complete vpos terminals

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    @CompleteVposTerminals  @Smoke
    Scenario: The process has been finished successfully.

        * def result = call read('LockVposTerminals.feature@SuccessLockedVposTerminals')
        * def vposId = result.response[0].id

        Given url MerchantServiceURL
        When request ''
        And path 'vpos-terminals/' + vposId + '/complete-settlement'
        And method post
        Then status 200

        * def query = "SELECT * FROM VPOS_TERMINALS WHERE VPOSUID ='" + vposId +"'"
        * def executeQuery = db.readRows(query)
        * def vposBatchLocked = executeQuery[0].VPOSBATCHLOCK
        * def status = executeQuery[0].STATUS

        And match vposBatchLocked == 'FALSE'
        And match status == 'AVAILABLE'
