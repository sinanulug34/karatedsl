import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.Row;
import com.datastax.driver.core.Session;

import java.util.ArrayList;
import java.util.List;

public class CassandraConnection {

  public static Session getSession() {
    String serverIP = "devops4.tr.asseco-see.local";
    String keyspace = "torus";
    CassandraConnection cassandraConnection;
    Cluster cluster = Cluster.builder()
        .addContactPoint(serverIP)
        .withCredentials("cassandra", "cassandra")
        .withPort(9042)
        .build();
    Session session = cluster.connect(keyspace);
    return session;
  }

  public static List<String> queryParam(String query) {
    String cqlStatement = query;
    Session cassandraSession = getSession();
    List<String> abc = new ArrayList<>();
    for (Row row : cassandraSession.execute(cqlStatement)) {
      abc.add(row.toString());
    }
    return abc;
  }

}


