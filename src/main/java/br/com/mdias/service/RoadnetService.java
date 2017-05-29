package br.com.mdias.service;

import java.math.BigDecimal;
import java.util.Date;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import oracle.jdbc.OracleTypes;

@Service
public class RoadnetService {

	@Autowired
	private DataSource dataSource;
	
	public boolean isDiaUtil(Date data, String uf) {
		
		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("data_base", data)
				.addValue("uf_origem", uf)
				;
		
		String ehDiaUtil = new SimpleJdbcCall(dataSource)
			.withoutProcedureColumnMetaDataAccess()
			.withCatalogName("ROADNET")
			.withFunctionName("is_dia_util")
			.withReturnValue()
			.declareParameters(
				new SqlOutParameter("RETURN", OracleTypes.VARCHAR),
				new SqlParameter("data_base", OracleTypes.DATE),
				new SqlParameter("uf_origem", OracleTypes.VARCHAR)
			)
			.executeFunction(String.class, in);
		
		return "TRUE".equals(ehDiaUtil);
	}

	public BigDecimal calculaFrete(String ufOrigem, String ufDestino) {
		
		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("uf_origem", ufOrigem)
				.addValue("uf_destino", ufDestino)
				;
		
		BigDecimal valor = new SimpleJdbcCall(dataSource)
			.withoutProcedureColumnMetaDataAccess()
			.withCatalogName("ROADNET")
			.withFunctionName("calcula_frete")
			.withReturnValue()
			.declareParameters(
				new SqlOutParameter("RETURN", OracleTypes.NUMBER),
				new SqlParameter("uf_origem", OracleTypes.VARCHAR),
				new SqlParameter("uf_destino", OracleTypes.VARCHAR)
			)
			.executeFunction(BigDecimal.class, in);
		
		return valor.setScale(2);
	}

	public BigDecimal aplicaDescontoEspecial(String uf, BigDecimal valorDoFrete) {
		
		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("p_uf", uf)
				.addValue("p_valor_frete", valorDoFrete)
				;
		
		BigDecimal valor = new SimpleJdbcCall(dataSource)
			.withoutProcedureColumnMetaDataAccess()
			.withCatalogName("ROADNET")
			.withFunctionName("aplica_desconto_especial")
			.withReturnValue()
			.declareParameters(
				new SqlOutParameter("RETURN", OracleTypes.NUMBER),
				new SqlParameter("p_uf", OracleTypes.VARCHAR),
				new SqlParameter("p_valor_frete", OracleTypes.NUMBER)
			)
			.executeFunction(BigDecimal.class, in);
		
		return valor.setScale(2);
	}
	
}
