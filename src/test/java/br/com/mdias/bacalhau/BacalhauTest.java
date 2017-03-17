package br.com.mdias.bacalhau;

import java.util.Date;

import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.UncategorizedSQLException;

import base.SpringIntegrationTestCase;
import br.com.mdias.model.BlankObjectExample;
import br.com.mdias.service.BacalhauService;
import br.com.triadworks.dbunit.dataset.ClassPathDataSetSource;

public class BacalhauTest extends SpringIntegrationTestCase {
	
	@Rule
	public ExpectedException thrown = ExpectedException.none();
	@Autowired
	private BacalhauService service;

	@Test
	public void buscaDadosRetornandoOracleType() {
		// 1. monta cenario
		this.cleanAndInsert(dataSet("dataset-blank-example.xml"));
		// 2. executa ação
		BlankObjectExample exampleObject = service.buscarCarga("Carga1");
		// 3. resultado esperado
		Assert.assertEquals("id", "1", exampleObject.getId());
		Assert.assertEquals("nome", "Carga1", exampleObject.getNome());
		Assert.assertEquals("status", "OK", exampleObject.getStatus());
	}

	@Test
	public void inserindoOracleType() {
		// 1. monta cenario
		this.cleanAndInsert(dataSet("dataset-blank-example.xml"));
		BlankObjectExample objectExample = newObjectExample();

		// 2. executa ação
		service.gravaCarga(objectExample);

		// 3. resultado esperado
		BlankObjectExample obj = service.buscarCarga(objectExample.getNome());
		Assert.assertEquals("id", "2", obj.getId());
		Assert.assertEquals("nome", "Carga-1", obj.getNome());
		Assert.assertEquals("status", "OK", obj.getStatus());
	}
		
	@Test
	public void naoGravaObjectExamplePorqueIdEstaDuplicado() {
		// 1. Monta cenario
		this.cleanAndInsert(dataSet("dataset-blank-example.xml"));
		BlankObjectExample objectExample = newObjectExampleComIdRepetido();

		thrown.expect(UncategorizedSQLException.class);
		thrown.expectMessage("ORA-20101: Erro ao inserir novo envio.");

		// 2. Executa ação
		service.gravaCarga(objectExample);
	}
	
	/**
	 * Criação do objeto oracle type.
	 * 
	 * @return BlancObjectExample
	 */
	private BlankObjectExample newObjectExample() {
		BlankObjectExample objectExample = new BlankObjectExample();
		objectExample.setId("2");
		objectExample.setNome("Carga-1");
		objectExample.setCriadoEm(today());
		objectExample.setStatus("OK");
		return objectExample;
	}
	
	/**
	 * Criação de outro objeto oracle type com um id ja existente na base de
	 * dados para ser lançada a exceção da procedure PL/SQL
	 * 
	 * @return BlancObjectExample
	 */
	private BlankObjectExample newObjectExampleComIdRepetido() {
		BlankObjectExample objectExample = new BlankObjectExample();
		objectExample.setId("1");
		objectExample.setNome("Carga-1");
		objectExample.setCriadoEm(today());
		objectExample.setStatus("OK");
		return objectExample;
	}
	
	/**
	 * Limpa as tabelas.
	 */
	public void deleteAll(String dataset){
		this.dbunitManager.deleteAll(new ClassPathDataSetSource(dataset));
	}
	
	/**
	 * Endereço do caminho dos cenários de testes
	 * 
	 * @param xml
	 * @return String - caminho do cenario
	 */
	private String dataSet(String xml) {
		return "datasets/bacalhau/blank/" + xml;
	}
	
	private Date today() {
		return new Date();
	}
}
