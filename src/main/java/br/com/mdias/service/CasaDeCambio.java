package br.com.mdias.service;

public class CasaDeCambio {

	public double converteRealParaBitcoin(double valorEmReal) {
		
		return valorEmReal / 9200;
	}
	
	public double converteRealParaDolar(double valorEmReal) {
		
		return valorEmReal / 3.55;
	}
	
}
