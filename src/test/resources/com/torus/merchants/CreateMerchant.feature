@MerchantTerminalService @Torus
Feature: Create a new instance of a Merchant

    Background:

        * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')
        * def readJavaClass = Java.type('Utility')

        Given request createMerchant
        When url MerchantServiceURL
        And path 'merchants'

    @MerchantCreate @Smoke
    Scenario: The process has been finished successfully.

       # * def getCreateMerchantRequest = readJavaClass.generateCreateMerchantRequestBody()

        Given request createMerchant
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: acquirerId param must be mandatory field.

        * remove createMerchant.acquirerId

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'acquirerId must not be null'

    Scenario: storeId param must be mandatory field.

        * remove createMerchant.storeId

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'storeId must not be null'

    Scenario: storeId param must be Alphanumeric max 12 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(13)
        * set createMerchant.storeId = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'storeId size must be between 0 and 12'

    Scenario: name param must be mandatory field.

        * remove createMerchant.name

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'name must not be null'

    Scenario: name param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(256)
        * set createMerchant.name = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'name size must be between 0 and 255'

    Scenario: webAddress param must be optional field.

        * remove createMerchant.webAddress

        And method post
        Then status 201

    Scenario: webAddress param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(256)
        * set createMerchant.webAddress = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'webAddress size must be between 0 and 255'

    Scenario: businessStartDate param must be mandatory field.

        * remove createMerchant.businessStartDate

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'businessStartDate must not be null'


    Scenario: merchantGroupId param must be mandatory field.

        * remove createMerchant.merchantGroupId

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'merchantGroupId must not be null'

    Scenario: merchantType param must be mandatory field.

        * remove createMerchant.merchantType

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'merchantType must not be null'

    Scenario: merchantType param can be VENDOR

        * set createMerchant.merchantType = 'VENDOR'

        And method post
        Then status 201

    Scenario: merchantType param can be PAYMENT_FACILITATOR

        * set createMerchant.merchantType = 'PAYMENT_FACILITATOR'

        And method post
        Then status 201

    Scenario: merchantType param can be STANDARD

        * set createMerchant.merchantType = 'STANDARD'

        And method post
        Then status 201

    Scenario: merchantType param cannot take any value other than VENDOR, PAYMENT_FACILITATOR and STANDARD.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(10)
        * set createMerchant.merchantType = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'

    Scenario: Merchant category code param must be mandatory field.

        * remove createMerchant.merchantCategoryCode

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'merchantCategoryCode must not be null'

    Scenario: Merchant category code param must be Numeric max 4 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(6)
        * set createMerchant.merchantCategoryCode = getNumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'must be less than or equal to 9999'

    Scenario:  hostId param must be optional field.

        * remove createMerchant.hostId

        And method post
        Then status 201

    Scenario:  paymentIntegrationType param must be optional field.

        * remove createMerchant.paymentIntegrationType

        And method post
        Then status 201

    Scenario: paymentIntegrationType param can be THREED_HOSTING

        * set createMerchant.paymentIntegrationType = 'THREED_HOSTING'

        And method post
        Then status 201

    Scenario: paymentIntegrationType param can be THREED_PAY_HOSTING

        * set createMerchant.paymentIntegrationType = 'THREED_PAY_HOSTING'

        And method post
        Then status 201

    Scenario: paymentIntegrationType param can be THREED

        * set createMerchant.paymentIntegrationType = 'THREED'

        And method post
        Then status 201

    Scenario: paymentIntegrationType param can be THREED_PAY

        * set createMerchant.paymentIntegrationType = 'THREED_PAY'

        And method post
        Then status 201

    Scenario: paymentIntegrationType param cannot take any value other than THREED_HOSTING, THREED_PAY_HOSTING, THREED and THREED_PAY.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(10)
        * set createMerchant.paymentIntegrationType = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'

    Scenario: posEntryMode param must be mandatory field.

        * remove createMerchant.posEntryMode

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'posEntryMode must not be null'

    Scenario: posEntryMode param can be ECOMMERCE

        * set createMerchant.posEntryMode = 'ECOMMERCE'

        And method post
        Then status 201

    Scenario: posEntryMode param cannot take any value other than MAIL_ORDER and ECOMMERCE.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(10)
        * set createMerchant.posEntryMode = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'

    Scenario:  ipAddress param must be optional field.

        * remove createMerchant.ipAddress

        And method post
        Then status 201

    Scenario:  ipAddress param must be AlphaNumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.ipAddress = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'ipAddress size must be between 0 and 64'

    Scenario: specialLabelId param must be optional field.

        * remove createMerchant.specialLabelId

        And method post
        Then status 201

    Scenario: specialLabelId param must be numeric.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(5)
        * set createMerchant.specialLabelId = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'

    Scenario: refundMaxDayCount param must be optional field.

        * remove createMerchant.refundMaxDayCount

        And method post
        Then status 201

    Scenario: refundMaxDayCount param must not be AlphaNumeric.

        * def getAlphaNumericCharacter = readJavaClass.getAlphaNumericString(12)
        * set createMerchant.refundMaxDayCount = getAlphaNumericCharacter

        And method post
        Then status 400

    Scenario: preAuthMaxDayCount param must be optional field.

        * remove createMerchant.preAuthMaxDayCount

        And method post
        Then status 201

    Scenario: preAuthMaxDayCount param must be Numeric max 4 characters.

        * def getNumericCharacter = readJavaClass.generateNumeric(6)
        * set createMerchant.preAuthMaxDayCount = getNumericCharacter

        And method post
        Then status 500

    Scenario: preAuthMaxDayCount param must not be AlphaNumeric.

        * def getAlphaNumericCharacter = readJavaClass.getAlphaNumericString(12)
        * set createMerchant.preAuthMaxDayCount = getAlphaNumericCharacter

        And method post
        Then status 400

    Scenario: criteriaFirst param must be optional field.

        * remove createMerchant.criteriaFirst

        And method post
        Then status 201

    Scenario: criteriaFirst param must be Alphanumeric max 16 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(17)
        * set createMerchant.criteriaFirst = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'criteriaFirst size must be between 0 and 16'

    Scenario: criteriaSecond param must be optional field.

        * remove createMerchant.criteriaSecond

        And method post
        Then status 201

    Scenario: criteriaSecond param must be Alphanumeric max 16 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(17)
        * set createMerchant.criteriaSecond = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'criteriaSecond size must be between 0 and 16'

    Scenario: taxNumber param must be optional field.

        * remove createMerchant.taxNumber

        And method post
        Then status 201

    Scenario: taxNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.taxNumber = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'taxNumber size must be between 0 and 64'

    Scenario: reportTimeLimit param must be mandatory field.

        * remove createMerchant.reportTimeLimit

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'reportTimeLimit must not be null'

    Scenario: reportTimeLimit param must be Alphanumeric max 16 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(17)
        * set createMerchant.reportTimeLimit = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'reportTimeLimit size must be between 0 and 16'

    Scenario: extraInfo param must be optional field.

        * remove createMerchant.extraInfo

        And method post
        Then status 201

    Scenario: extraInfo param must be Alphanumeric max 255 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(256)
        * set createMerchant.extraInfo = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'extraInfo size must be between 0 and 255'

    Scenario: address params must be mandatory field.

        * remove createMerchant.address

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address must not be null'

    Scenario: postalAddressFirst param must be optional field.

        * remove createMerchant.address.postalAddressFirst

        And method post
        Then status 201

    Scenario: postalAddressFirst param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.postalAddressFirst = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.postalAddressFirst size must be between 0 and 64'

    Scenario: postalAddressSecond param must be optional field.

        * remove createMerchant.address.postalAddressSecond

        And method post
        Then status 201

    Scenario: postalAddressSecond param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.postalAddressSecond = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.postalAddressSecond size must be between 0 and 64'

    Scenario: postalAddressThird param must be optional field.

        * remove createMerchant.address.postalAddressThird

        And method post
        Then status 201

    Scenario: postalAddressThird param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.postalAddressThird = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.postalAddressThird size must be between 0 and 64'

    Scenario: city param must be optional field.

        * remove createMerchant.address.city

        And method post
        Then status 201

    Scenario: city param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.city = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.city size must be between 0 and 64'

    Scenario: postalCode param must be optional field.

        * remove createMerchant.address.postalCode

        And method post
        Then status 201

    Scenario: postalCode param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.postalCode = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.postalCode size must be between 0 and 64'

    Scenario: state param must be optional field.

        * remove createMerchant.address.state

        And method post
        Then status 201

    Scenario: state param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.state = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.state size must be between 0 and 64'

    Scenario: country param must be mandatory field.

        * remove createMerchant.address.country

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.country must not be null'

    Scenario: country param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.country = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.country size must be between 0 and 64'

    Scenario: phoneNumber param must be optional field.

        * remove createMerchant.address.phoneNumber

        And method post
        Then status 201

    Scenario: phoneNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.phoneNumber = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.phoneNumber size must be between 0 and 64'

    Scenario: fax param must be optional field.

        * remove createMerchant.address.fax

        And method post
        Then status 201

    Scenario: fax param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.address.fax = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'address.fax size must be between 0 and 64'

    Scenario: cardBrands params must be optional field.

        * remove createMerchant.cardBrands

        And method post
        Then status 201

    Scenario: subMerchant params must be optional field.

        * remove createMerchant.subMerchant

        And method post
        Then status 201

    Scenario: If the subMerchant checkBox is selected, terminalNumber parameter is the mandatory field.

        * remove createMerchant.subMerchant.vposTerminalId

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'subMerchant.vposTerminalId must not be null'

    Scenario: terminalNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.subMerchant.vposTerminalId = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'subMerchant.vposTerminalId size must be between 0 and 64'

    Scenario: If the subMerchant checkBox is selected, subMerchantNumber parameter is the mandatory field.

        * remove createMerchant.subMerchant.subMerchantNumber

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'subMerchant.subMerchantNumber must not be null'

    Scenario: subMerchantNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.subMerchant.subMerchantNumber = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'subMerchant.subMerchantNumber size must be between 0 and 64'

    Scenario: paymentFacilitator params must be optional field.

        * remove createMerchant.paymentFacilitator

        And method post
        Then status 201

    Scenario: If the paymentFacilitator checkBox is selected, facilitatorNumber parameter is the mandatory field.

        * remove createMerchant.paymentFacilitator.facilitatorNumber

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'paymentFacilitator.facilitatorNumber must not be null'

    Scenario: facilitatorNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.paymentFacilitator.facilitatorNumber = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'paymentFacilitator.facilitatorNumber size must be between 0 and 64'

    Scenario: If the paymentFacilitator checkBox is selected, saleOrganizationNumber parameter is the mandatory field.

        * remove createMerchant.paymentFacilitator.saleOrganizationNumber

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'paymentFacilitator.saleOrganizationNumber must not be null'

    Scenario: saleOrganizationNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.paymentFacilitator.saleOrganizationNumber = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'paymentFacilitator.saleOrganizationNumber size must be between 0 and 64'

    Scenario: contact params must be optional field.

        * remove createMerchant.contact

        And method post
        Then status 201

    Scenario: contact.name params must be optional field.

        * remove createMerchant.contact.name

        And method post
        Then status 201

    Scenario: contact.name param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.name = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.name size must be between 0 and 64'

    Scenario: contact.email params must be optional field.

        * remove createMerchant.contact.email

        And method post
        Then status 201

    Scenario: contact.email param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.email = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.email size must be between 0 and 64'

    Scenario: contact.technicalResponsibleFirst params must be optional field.

        * remove createMerchant.technicalResponsibleFirst

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleFirst.nameSurname params must be optional field.

        * remove createMerchant.contact.technicalResponsibleFirst.nameSurname

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleFirst.nameSurname param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleFirst.nameSurname = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleFirst.nameSurname size must be between 0 and 64'

    Scenario: contact.technicalResponsibleFirst.email params must be optional field.

        * remove createMerchant.contact.technicalResponsibleFirst.email

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleFirst.email param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleFirst.email = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleFirst.email size must be between 0 and 64'

    Scenario: contact.technicalResponsibleFirst.merchantName params must be optional field.

        * remove createMerchant.contact.technicalResponsibleFirst.merchantName

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleFirst.merchantName param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleFirst.merchantName = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleFirst.merchantName size must be between 0 and 64'

    Scenario: contact.technicalResponsibleFirst.phoneNumber params must be optional field.

        * remove createMerchant.contact.technicalResponsibleFirst.phoneNumber

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleFirst.phoneNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleFirst.phoneNumber = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleFirst.phoneNumber size must be between 0 and 64'

    Scenario: contact.technicalResponsibleSecond params must be optional field.

        * remove createMerchant.technicalResponsibleSecond

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleSecond.nameSurname params must be optional field.

        * remove createMerchant.contact.technicalResponsibleSecond.nameSurname

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleSecond.nameSurname param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleSecond.nameSurname = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleSecond.nameSurname size must be between 0 and 64'

    Scenario: contact.technicalResponsibleSecond.email params must be optional field.

        * remove createMerchant.contact.technicalResponsibleSecond.email

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleSecond.email param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleSecond.email = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleSecond.email size must be between 0 and 64'

    Scenario: contact.technicalResponsibleSecond.MerchantName params must be optional field.

        * remove createMerchant.contact.technicalResponsibleSecond.merchantName

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleSecond.merchantName param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleSecond.merchantName = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleSecond.merchantName size must be between 0 and 64'

    Scenario: contact.technicalResponsibleSecond.phoneNumber params must be optional field.

        * remove createMerchant.contact.technicalResponsibleSecond.phoneNumber

        And method post
        Then status 201

    Scenario: contact.technicalResponsibleSecond.phoneNumber param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createMerchant.contact.technicalResponsibleSecond.phoneNumber = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'contact.technicalResponsibleSecond.phoneNumber size must be between 0 and 64'
