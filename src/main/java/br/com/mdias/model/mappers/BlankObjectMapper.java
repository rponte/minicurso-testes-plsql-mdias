package br.com.mdias.model.mappers;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Struct;
import java.sql.Timestamp;

import org.springframework.jdbc.core.SqlReturnType;
import org.springframework.jdbc.core.support.AbstractSqlTypeValue;

import br.com.mdias.model.BlankObjectExample;
import br.com.mdias.util.DataReader;

/**
	CREATE TYPE BlanckObjectMapper AS OBJECT (
	  id          VARCHAR2(60),
	  nome        VARCHAR2(255),
	  criado_em   TIMESTAMP,
	  status      NUMBER(1)
	);
 */
public class BlankObjectMapper extends AbstractSqlTypeValue implements SqlReturnType {

	private BlankObjectExample blanckObject;
	
	public BlankObjectMapper() {}
	
	public BlankObjectMapper(BlankObjectExample remessa) {
		this.blanckObject = remessa;
	}

	/**
	 * IN parameters
	 */
	@Override
	protected Object createTypeValue(Connection con, int sqlType, String typeName) throws SQLException {
        Struct struct = con.createStruct(typeName, new Object[] {
        	this.blanckObject.getId(),
        	this.blanckObject.getNome(),
        	new Timestamp(this.blanckObject.getCriadoEm().getTime()),
        	this.blanckObject.getStatus()
        });
        return struct;
	}

	/**
	 * OUT parameters and RETURN value
	 */
	@Override
	public Object getTypeValue(CallableStatement cs, int paramIndex, int sqlType, String typeName) throws SQLException {
		
		Object[] data = ((Struct) cs.getObject(1)).getAttributes();
		DataReader dataReader = new DataReader(data);
		
		BlankObjectExample remessa = new BlankObjectExample();
		remessa.setId(dataReader.asString());
		remessa.setNome(dataReader.asString());
		remessa.setCriadoEm(dataReader.asDate());
		remessa.setStatus(dataReader.asString());
		
		return remessa;
	}

}
