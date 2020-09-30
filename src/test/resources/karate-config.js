function fn(){
var env=karate.env;
karate.log('karate.env.system.properties:',env)
if(env==null){
env='test'
}
var config={
MerchantServiceURL:'http://merchant-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
UserServiceURL:'http://user-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',

AcquirerServiceURL:'http://acquirer-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
TerminalServiceURL:'http://devnode2.tr.asseco-see.local:31822/',
OrderServiceURL: 'http://devnode2.tr.asseco-see.local:31974/',
MerchantBatchesServiceURL: 'http://devnode2.tr.asseco-see.local:31463/',
TransactionServiceURL: 'http://devnode2.tr.asseco-see.local:32021/',
XmlApiServiceURL:'http://api-gateway-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
CoordinatorServiceURL: 'http://devnode2.tr.asseco-see.local:32055/',
PaymentQueryServiceURL:'http://payment-query-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
PaymentProcessingServiceURL: 'http://payment-processing-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
CommunicatorServiceURL: 'http://communicator-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
ApiGateWayServiceURL :'http://api-gateway-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
OrchestratorServiceURL : 'http://orchestrator-service-torus-feature.apps.ocpdev.tr.asseco-see.local/',
SettlementServiceURL:'http://settlement-service-torus-feature.apps.ocpdev.tr.asseco-see.local/'
};
//karate.configure('connectTimeout',200000);
//karate.configure('readTimeout',200000);
karate.log('karate.env =',karate.env)
karate.configure('ssl',true);
return config;
}
