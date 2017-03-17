package base;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;

import br.com.triadworks.dbunit.DbUnitManager;
import br.com.triadworks.dbunit.vendors.oracle.OracleDbUnitManagerImpl;

@Configuration
@ComponentScan(basePackages="base")
@PropertySource("classpath:jdbc-local.properties")
public class TestAppConfig {
	
	@Autowired
	private Environment env;
	
	@PostConstruct
	public void init() {
		this.validateEnvironment();
	}
	
	/**
	 * Cria instância do DataSource
	 */
	@Bean
	public DataSource dataSource() {
		SingleConnectionDataSource dataSource = new SingleConnectionDataSource();
		dataSource.setUrl(env.getProperty("jdbc.url"));
		dataSource.setUsername(env.getProperty("jdbc.username"));
		dataSource.setPassword(env.getProperty("jdbc.password"));
		dataSource.setSuppressClose(true);
		return dataSource;
	}
	
	/**
	 * Cria instância do DbUnitManager
	 */
	@Bean
	public DbUnitManager dbunitManager(DataSource dataSource) {
		DbUnitManager dbunitManager = new OracleDbUnitManagerImpl(dataSource);
		return dbunitManager;
	}

	/**
	 * Valida configuração do banco para evitar problemas.
	 */
	private void validateEnvironment() {
		String jdbcUrl = env.getProperty("jdbc.url");
		if (!jdbcUrl.equals("jdbc:oracle:thin:@localhost:1521:XE"))
			throw new IllegalStateException("CUIDADO! Os testes devem ser executados somente na sua máquina!");
	}
}
