import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class DbUtils {

  private static final Logger logger = LoggerFactory.getLogger(DbUtils.class);

  private final JdbcTemplate jdbc;
  InputStream inputStream;

  public DbUtils() throws IOException {

    Properties prop = new Properties();
    String propFileName = "database.properties";

    inputStream = getClass().getClassLoader().getResourceAsStream(propFileName);

    if (inputStream != null) {
      prop.load(inputStream);
    } else {
      throw new FileNotFoundException("property file '" + propFileName + "' not found in the classpath");
    }
    String username = prop.getProperty("username");
    String password = prop.getProperty("password");
    String url = prop.getProperty("url");
    String driverClassName = prop.getProperty("driverClassName");

    DriverManagerDataSource dataSource = new DriverManagerDataSource();
    dataSource.setUrl(url);
    dataSource.setUsername(username);
    dataSource.setPassword(password);
    dataSource.setDriverClassName(driverClassName);

    this.jdbc = new JdbcTemplate(dataSource);
    logger.info("init jdbc template: {}", url);
  }

  public Object readValue(String query) {
    return this.jdbc.queryForObject(query, Object.class);
  }

  public Map<String, Object> readRow(String query) {
    return this.jdbc.queryForMap(query);
  }

  public List<Map<String, Object>> readRows(String query) {
    return this.jdbc.queryForList(query);
  }
}
