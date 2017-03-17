package br.com.mdias.util;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Date;

public class ConverterUtils {
	
	public static Timestamp toSqlTimestamp(Date date) {
		if (date == null)
			return null;
		
		return new Timestamp(date.getTime());
	}
	
	public static java.sql.Date toSqlDate(Date date) {
		if (date == null)
			return null;
		
		return new java.sql.Date(date.getTime());
	}
	
	public static Date toDate(Object value) {
		
		if (value == null)
			return null;
		
		if (value instanceof Date)
			return (Date) value;
		
		throw new IllegalStateException("Valor não é do tipo java.util.Date: " + value.getClass());
	}
	
	public static boolean toBoolean(Object value, String trueExpression) {
		if (value == null)
			return false;
		
		return value.toString().equalsIgnoreCase(trueExpression);
	}
	
	public static Integer toInt(Object value) {
		BigDecimal bigvalue = toBigDecimal(value);
		return (null==bigvalue)?null:bigvalue.intValue();
	}

	public static BigDecimal toBigDecimal(Object value) {
		if (value == null)
			return null;
		
		if (value instanceof BigDecimal)
			return (BigDecimal) value;
		
		throw new IllegalStateException("Valor não é do tipo java.math.BigDecimal: " + value.getClass()); 
	}
	
}
