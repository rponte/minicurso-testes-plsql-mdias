package br.com.mdias.service;

import static org.junit.Assert.assertEquals;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.springframework.beans.factory.annotation.Autowired;

import base.SpringIntegrationTestCase;
import br.com.triadworks.dbunit.dataset.ClassPathDataSetSource;
import br.com.triadworks.dbunit.dataset.DataSetSource;

public class RoadnetServiceTest extends SpringIntegrationTestCase {

	@Rule
	public ExpectedException observadorDeExcecoes = ExpectedException.none();
	
	@Autowired
	private RoadnetService roadnet;
	
	@Test
	public void naoDeveCalcularFreteQuandoNaoEncontrarEstados() {
		// cenário
		String ufOrigem = "CE";
		String ufDestinoQueNaoExiste = "uf-que-nao-existe";

		DataSetSource dataSetSource = new ClassPathDataSetSource("datasets/dataset-fretes-e-valores.xml");
		dbunitManager.cleanAndInsert(dataSetSource);

		observadorDeExcecoes.expect(RuntimeException.class);
		observadorDeExcecoes.expectMessage("ORA-20001: Valor do frete nao encontrado");
		
		// ação
		roadnet.calculaFrete(ufOrigem, ufDestinoQueNaoExiste);
	}
	
	@Test
	public void deveCalcularFrete_entreEstadosDiferentes() {
		// cenário
		String ufOrigem = "CE";
		String ufDestino = "SP";

		DataSetSource dataSetSource = new ClassPathDataSetSource("datasets/dataset-fretes-e-valores.xml");
		dbunitManager.cleanAndInsert(dataSetSource);
		
		// ação
		BigDecimal valor = roadnet.calculaFrete(ufOrigem, ufDestino);
		
		// validação
		BigDecimal valorEsperado = new BigDecimal("30.10");
		assertEquals(valorEsperado, valor);
	}
	
	@Test
	public void deveCalcularFrete_dentroDoMesmoEstado() {
		// cenário
		String ufOrigem = "CE";
		
		DataSetSource dataSetSource = new ClassPathDataSetSource("datasets/dataset-fretes-e-valores.xml");
		dbunitManager.cleanAndInsert(dataSetSource);
				
		// ação
		BigDecimal valor = roadnet.calculaFrete(ufOrigem, ufOrigem);
		
		// validação
		BigDecimal valorEsperado = new BigDecimal("18.18");
		assertEquals(valorEsperado, valor);
	}

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
