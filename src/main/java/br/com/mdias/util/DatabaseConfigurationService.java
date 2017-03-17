package br.com.mdias.util;

import java.sql.Types;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import base.Debugger;

@Repository
public class DatabaseConfigurationService {

	private DataSource dataSource;
	private boolean alreadyExecuted = false;
	
	@Autowired
	public DatabaseConfigurationService(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	/**
	 * Configura ambiente de testes na sessão 
	 */
	public DatabaseConfigurationService configureSessionTestingEnvironment() {
		
		if (alreadyExecuted) {
			return this;
		}
		alreadyExecuted = true;
		
		this.setDatabaseParameter("JUNIT_TEST", "TESTING");
		return this;
	}
	
	/**
	 * Configura localização (locale) da sessão para pt_BR
	 * https://ferhatsengonul.wordpress.com/2010/07/21/to-show-nls-parameters-for-session-database-instance-together-by-pivot-and-listagg-on-11gr2/
	 * 
	 * SELECT * FROM v$nls_parameters WHERE parameter like 'NLS%';
	 */
	public DatabaseConfigurationService configureSessionLanguageToPtBR() {
		this.setSessionParameter("nls_language", "BRAZILIAN PORTUGUESE");
		this.setSessionParameter("NLS_DATE_FORMAT", "DD/MM/RR"); // formato padrão do oracle
		//this.setSessionParameter("nls_lang", "AMERICAN_AMERICA.WE8ISO8859P1");
		return this;
	}

	/**
	 * Configura algoritimo utilizado nas ordenações 
	 * https://ferhatsengonul.wordpress.com/2010/07/21/to-show-nls-parameters-for-session-database-instance-together-by-pivot-and-listagg-on-11gr2/
	 */
	public DatabaseConfigurationService configureSessionSorting() {
		this.setSessionParameter("nls_comp", "LINGUISTIC");
		this.setSessionParameter("nls_sort", "BINARY");
		return this;
	}

	/**
	 * Configura semantica de tamanho de tipos (1 CHAR = 4 bytes)
	 * http://gerardnico.com/wiki/database/oracle/byte_or_character
	 */
	public DatabaseConfigurationService configureSessionLengthSemantics() {
		this.setSessionParameter("nls_length_semantics", "CHAR");
		return this;
	}
	
	/**
	 * Retorna parametro da sessão do usuário logado
	 */
	public String getSessionParameter(String param) {
		String value = new JdbcTemplate(dataSource)
		   .queryForObject("select userenv('{param}') from dual".replace("{param}", param)
				   	, String.class);
		return value;
	}
	
	/**
	 * Seta parametro na sessão do usuário logado
	 */
	public DatabaseConfigurationService setSessionParameter(String key, String value) {

		String sql = "ALTER SESSION SET {key}='{value}'"
				.replace("{key}", key)
				.replace("{value}", value)
				;

		new JdbcTemplate(dataSource)
			.execute(sql);

		return this;
	}
	
	/**
	 * Seta parametro arbitratio no contexto do banco de dados para aquela sessão 
	 */
	public DatabaseConfigurationService setDatabaseParameter(String moduleName, String actionName) {
		
		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("module_name", moduleName)
				.addValue("action_name", actionName);
		
		new SimpleJdbcCall(dataSource)
			.withoutProcedureColumnMetaDataAccess()
			.withCatalogName("DBMS_APPLICATION_INFO")
			.withProcedureName("SET_MODULE")
			.declareParameters(
				new SqlParameter("module_name", Types.VARCHAR),
				new SqlParameter("action_name", Types.VARCHAR)
			)
			.execute(in);
		
		return this;
	}
	
	/**
	 * Habilita Debug Remoto com SQL Developer sempre que teste for executado em
	 * modo debug no Eclipse
	 */
	public DatabaseConfigurationService configureDebugModeWhenEnabled() {
		Debugger debugMode = new Debugger();
		if (!debugMode.isEnabled()) {
			return this;
		}
		
		/**
		 * Habilita modo debug do PLSQL pra sessão atual
		 */
		new JdbcTemplate(dataSource)
			.execute("ALTER SESSION SET PLSQL_DEBUG=TRUE");
		
		/**
		 * Conecta ao listener de debug do SQL Developer
		 */
		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("host_name", "10.14.66.33") // FIXME: hard-coded by @rponte
				.addValue("port", 4000);
		
		new SimpleJdbcCall(dataSource)
			.withoutProcedureColumnMetaDataAccess()
			.withCatalogName("DBMS_DEBUG_JDWP")
			.withProcedureName("CONNECT_TCP")
			.declareParameters(
				new SqlParameter("host_name", Types.VARCHAR),
				new SqlParameter("port", Types.INTEGER)
			)
			.execute(in);
		
		return this;
	}
}
