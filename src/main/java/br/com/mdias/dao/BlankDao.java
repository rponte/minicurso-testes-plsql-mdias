package br.com.mdias.dao;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;


@Repository
public class BlankDao {

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public BlankDao(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public boolean primeiraConsultaBlanc(String firstParameter, String secondParameter) {
		int count = jdbcTemplate
				.queryForObject(
						"select 1 as total from DUAL",
						new Object[]{
							firstParameter,
							secondParameter
						},
						Integer.class);
		return count > 0;
	}
}
