package performance

import io.gatling.core.Predef.Simulation
import io.gatling.core.Predef._
import com.intuit.karate.gatling.PreDef._

class TorusSimulation extends Simulation{

    before{
        println("Simulation is started!")
    }
    val createAcquirer = scenario("Create Acquirer").exec(karateFeature("com.torus.features/acquirer/CreateAcquirer.feature"))
    val createMerchant = scenario("Create Merchant").exec(karateFeature("com.torus.features/merchants/CreateMerchant.feature"))
    val getMerchant = scenario("Get Merchant").exec(karateFeature("com.torus.features/merchants/GetMerchant.feature"))
    val listAllMerchant = scenario("List All Merchant").exec(karateFeature("com.torus.features/merchants/ListAllMerchants.feature"))
    val updateMerchant = scenario("Update Merchant").exec(karateFeature("com.torus.features/merchants/UpdateMerchant.feature"))
    val order = scenario("List All Orders").exec(karateFeature("com.torus.features/order/ListAllOrders.feature"))
    val settlement = scenario("List All Settlements").exec(karateFeature("com.torus.features/order/ListAllSettlement.feature"))
    val transaction = scenario("Start Transaction").exec(karateFeature("com.torus.features/transaction/SaleTransactions.feature"))

    //Make Http reques
    val acquirerProtocols = karateProtocol(
        "/acquirers" -> Nil,
        "/merchants" -> Nil
    )
    val merchantProtocol = karateProtocol(
        "/merchants" -> Nil
    )
    val orderProtocol = karateProtocol(
        "/orders" -> Nil
    )
    val settlementProtocol = karateProtocol(
        "/merchant-batches" -> Nil
    )
    val transactions = karateProtocol(
        "/api/fim" -> Nil
    )
    setUp(
        createAcquirer.inject(rampUsers(1) during(1)).protocols(acquirerProtocols),
        createMerchant.inject(rampUsers(1) during(1)).protocols(merchantProtocol),
        getMerchant.inject(rampUsers(1) during(1)).protocols(merchantProtocol),
        listAllMerchant.inject(rampUsers(1) during(1)).protocols(merchantProtocol),
        updateMerchant.inject(rampUsers(1) during(1)).protocols(merchantProtocol),
        order.inject(rampUsers(1) during(1)).protocols(orderProtocol),
        settlement.inject(rampUsers(1)during(1)).protocols(settlementProtocol),
        transaction.inject(rampUsers(1)during(1)).protocols(settlementProtocol)
    )
    after{
        println("Simulation is finished!")
    }
}
