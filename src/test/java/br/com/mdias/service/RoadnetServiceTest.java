package br.com.mdias.service;

import static org.junit.Assert.assertEquals;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import base.SpringIntegrationTestCase;

public class RoadnetServiceTest extends SpringIntegrationTestCase {
	
	@Autowired
	private RoadnetService roadnet;

	@Test
	public void deveSegundaFeiraSerDiaUtil() {
		// cenário
		Date segundaFeira = toDate("2017-05-01");
		String uf = "SP";
		
		// ação
		boolean ehDiaUtil = roadnet.isDiaUtil(segundaFeira, uf);
		
		// validação
		assertEquals(true, ehDiaUtil);
	}
	
	@Test
	public void deveSegundaASextaSerDiaUtil() {
		// cenário
		Date segundaFeira = toDate("2017-05-01");
		Date tercaFeira = toDate("2017-05-02");
		Date quartaFeira = toDate("2017-05-03");
		Date quintaFeira = toDate("2017-05-04");
		Date sextaFeira = toDate("2017-05-05");
		String uf = "SP";
		
		// ação e validação
		assertEquals(true, roadnet.isDiaUtil(segundaFeira, uf));
		assertEquals(true, roadnet.isDiaUtil(tercaFeira, uf));
		assertEquals(true, roadnet.isDiaUtil(quartaFeira, uf));
		assertEquals(true, roadnet.isDiaUtil(quintaFeira, uf));
		assertEquals(true, roadnet.isDiaUtil(sextaFeira, uf));
	}
	
	@Test
	public void naoDeveSabadoSerDiaUtil() {
		// cenário
		Date sabado = toDate("2017-05-06");
		String uf = "SP";
		
		// ação
		boolean ehDiaUtil = roadnet.isDiaUtil(sabado, uf);
		
		// validação
		assertEquals(false, ehDiaUtil);
	}
	
	@Test
	public void naoDeveDomingoSerDiaUtil() {
		// cenário
		Date domingo = toDate("2017-05-07");
		String uf = "SP";
		
		// ação
		boolean ehDiaUtil = roadnet.isDiaUtil(domingo, uf);
		
		// validação
		assertEquals(false, ehDiaUtil);
	}
	
	@Test
	public void deveSerDiaUtilQuandoUfForCeara() {
		
		// cenário
		Date domingo = toDate("2017-05-07");
		String ceara = "CE";

		// ação
		boolean ehDiaUtil = roadnet.isDiaUtil(domingo, ceara);

		// validação
		assertEquals(true, ehDiaUtil);
	}

	private Date toDate(String data) {
		SimpleDateFormat formatador = new SimpleDateFormat("yyyy-MM-dd");
		try {
			return formatador.parse(data);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}

}
