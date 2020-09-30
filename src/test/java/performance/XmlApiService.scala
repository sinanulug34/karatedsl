package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef.{Simulation, _}

class XmlApiService extends Simulation{

    before{
        println("XmlApiService simulation is started!")
    }
    val xmlApiServiceAuth = scenario("SaleTransaction").exec(karateFeature("com/torus/apiGateway/SaleTransactions.feature@SuccessXmlAuth"))
    val xmlApiServicePreAuth = scenario("PreAuthTransaction").exec(karateFeature("com/torus/apiGateway/PreAuthTransactions.feature@SuccessXmlPreAuth"))
    val xmlApiServicePostAuth = scenario("PostAuthTransaction").exec(karateFeature("com/torus/apiGateway/PostAuthTransactions.feature@SuccessXmlPostAuth"))
    val xmlApiServiceRefund = scenario("RefundTransaction").exec(karateFeature("com/torus/apiGateway/RefundTransactions.feature@SuccessRefundTransaction"))
    val xmlApiServiceVoid = scenario("VoidTransaction").exec(karateFeature("com/torus/apiGateway/VoidTransactions.feature@SuccessVoidTransaction"))

    val xmlApiServiceProtocols = karateProtocol(
        "/fim/api" -> Nil
    )

    setUp(
        xmlApiServiceAuth.inject(constantUsersPerSec(2) during (5)) // 4),

    )
    after{
        println("XmlApiService simulation is finished!")
    }
}
