package base.junitrules;

import javax.sql.DataSource;

import org.junit.rules.ExternalResource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Component;

@Component
public class OraclePlsqlMockerRule extends ExternalResource {

	private static final String ORACLE_EDITION_NAME = "ora$base";
	private static final String MOCK_EDITION_NAME = "Mock_Edition";
	
	private final JdbcTemplate jdbcTemplate;
	private final Environment env;
	
	@Autowired
	public OraclePlsqlMockerRule(DataSource dataSource, Environment env) {
		this.env = env;
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	@Override
	protected void before() throws Throwable {
		// habilita EBR para owner do schema
		executeSqlScript("ALTER USER {currentOwner} ENABLE EDITIONS");
		// cria mock edition a partir da edition padrao
		executeSqlScript("create edition {mockEdition} as child of {oracleEdition}");
		// usa mock edition
		executeSqlScript("alter session set edition = {mockEdition}");
	}
	
	@Override
	protected void after() {
		// volta pra edition padrao
		executeSqlScript("alter session set edition = {oracleEdition}");
		// dropa mock edition
		executeSqlScript("drop edition {mockEdition} CASCADE");
	}
	
	/**
	 * Executa script SQL/PLSQL usando "/" como delimitador. Este script deve
	 * fazer replace dos Objetos Oracle, como Packages, Procedures, Functions,
	 * Views e Types.
	 */
	public void mockPlsql(String scriptInClasspath) {
		ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
		populator.addScript(new ClassPathResource(scriptInClasspath));
		populator.setSeparator("/");
		populator.execute(jdbcTemplate.getDataSource());
	}
	
	private void executeSqlScript(String sql) {
		sql = sql
			.replace("{mockEdition}", MOCK_EDITION_NAME)
			.replace("{oracleEdition}", ORACLE_EDITION_NAME)
			.replace("{currentOwner}", env.getProperty("jdbc.username"));
		
		this.jdbcTemplate.execute(sql);
	}
}
