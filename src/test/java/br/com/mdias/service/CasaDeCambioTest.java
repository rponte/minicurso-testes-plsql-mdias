package br.com.mdias.service;

import static org.junit.Assert.*;

import org.junit.Test;

public class CasaDeCambioTest {

	@Test
	public void deveConverterValorEmRealParaBitcoin() {
		// cenário
		double valorEmReal = 1;
		
		// ação
		CasaDeCambio cambio = new CasaDeCambio();
		double valorEmBitcoin = cambio.converteRealParaBitcoin(valorEmReal);
		
		// validação
		assertEquals(9200, valorEmBitcoin, 0.001);
	}

}
