package br.com.mdias.util;

import static br.com.mdias.util.ConverterUtils.toBigDecimal;
import static br.com.mdias.util.ConverterUtils.toBoolean;
import static br.com.mdias.util.ConverterUtils.toDate;
import static br.com.mdias.util.ConverterUtils.toInt;

import java.math.BigDecimal;
import java.util.Date;

public class DataReader {

	private int index;
	private Object[] data;
	
	public DataReader(Object[] data) {
		this.data = data;
	}
	
	public String asString() {
		return (String) next();
	}
	
	public Date asDate() {
		return toDate(next());
	}
	
	public BigDecimal asBigDecimal() {
		return toBigDecimal(next());
	}
	
	public Integer asInt() {
		return toInt(next());
	}
	
	public boolean asBoolean(String trueExpression) {
		return toBoolean(next(), trueExpression);
	}

	private Object next() {
		return this.data[index++];
	}
}
