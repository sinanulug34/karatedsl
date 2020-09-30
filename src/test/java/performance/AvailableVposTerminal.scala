package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef.{Simulation, _}

class AvailableVposTerminal extends Simulation{

    before{
        println("Available Vpos Terminal Simulation Started!")
    }
    val vposTerminal = scenario("Vpos").exec(karateFeature("com/torus/merchants/AvailableVpos.feature@PerformanceVposTerminal"))


    setUp(
        vposTerminal.inject(atOnceUsers(3))
    )
    after{
        println("Available Vpos Terminal Simulation Finished!")
    }
}
