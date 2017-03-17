package br.com.mdias.config;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
@ComponentScan(basePackages="br.com.mdias")
public class AppConfig {

	/**
	 * Cria instância do Transaction Manager. Ele é responsável por gerenciar as
	 * transações de forma declarativa via anotação @Transactional
	 * http://blog.triadworks.com.br/controle-transacional-declarativo-com-spring-aop-ou-transactional
	 */
	@Bean
	public PlatformTransactionManager transactionManager(DataSource dataSource) {
		PlatformTransactionManager txManager = new DataSourceTransactionManager(dataSource);
		return txManager;
	}
	
}
