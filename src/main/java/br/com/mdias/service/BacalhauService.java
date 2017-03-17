package br.com.mdias.service;

import java.sql.Types;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import br.com.mdias.model.BlankObjectExample;
import br.com.mdias.model.mappers.BlankObjectMapper;

@Service
public class BacalhauService {

	private static final String PACKAGE_NAME = "TEST_BACALHAU";
	
	private static final String ORACLE_TYPE_CLIENTE = "BLANCK_TYPE_RT";
	
	private DataSource dataSource;

	@Autowired
	public BacalhauService(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	
	/**
	 * @param cdRemessa
	 * @return
	 */
	public BlankObjectExample buscarCarga(String cdRemessa) {

		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("P_VCDROMANEIO_I", cdRemessa);

		BlankObjectExample remessa = new SimpleJdbcCall(dataSource)
			.withoutProcedureColumnMetaDataAccess()
			.withCatalogName(PACKAGE_NAME)
			.withFunctionName("retorna_type_exemplo")
			.withReturnValue()
			.declareParameters(
				new SqlOutParameter("RETURN", Types.STRUCT, "BLANCK_TYPE_RT", new BlankObjectMapper()),
				new SqlParameter("P_VCDROMANEIO_I", Types.VARCHAR)
			)
		.executeFunction(BlankObjectExample.class, in);
		
		return remessa;
	}
	
	
   /**
	* @param blancObjectExample
	*/
	public void gravaCarga(BlankObjectExample blancObjectExample) {
		
		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("P_TYPE_EXAMPLE", new BlankObjectMapper(blancObjectExample))
				;
		
		new SimpleJdbcCall(dataSource)
			.withoutProcedureColumnMetaDataAccess()
			.withCatalogName(PACKAGE_NAME)
			.withProcedureName("INSERE_TYPE_EXAMPLE")
			.declareParameters(
				new SqlParameter("P_TYPE_EXAMPLE", Types.STRUCT, ORACLE_TYPE_CLIENTE)
			)
		.execute(in);
	}

}
