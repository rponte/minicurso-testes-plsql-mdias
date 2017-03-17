package base;

import java.util.Locale;

import org.junit.Before;
import org.junit.Rule;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Commit;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import base.junitrules.ShowPrintStackTraceRule;
import br.com.mdias.config.AppConfig;
import br.com.mdias.util.DatabaseConfigurationService;
import br.com.triadworks.dbunit.DbUnitManager;
import br.com.triadworks.dbunit.dataset.ClassPathDataSetSource;

@RunWith(SpringJUnit4ClassRunner.class)
@ActiveProfiles("test")
@ContextConfiguration(classes={AppConfig.class, TestAppConfig.class})
@Transactional
@Commit
public abstract class SpringIntegrationTestCase {
	
	private static final Locale pt_BR = new Locale("pt", "BR");

	@Rule
	public ShowPrintStackTraceRule stackTraceRule = new ShowPrintStackTraceRule();

	@Autowired
	protected DbUnitManager dbunitManager;
	
	@Autowired
	private DatabaseConfigurationService database;
	
	@Before
	public void setUp() {
		Locale.setDefault(pt_BR);
		database.configureSessionTestingEnvironment()
				.configureSessionSorting()
				.configureSessionLanguageToPtBR()
				.configureSessionLengthSemantics()
				.configureDebugModeWhenEnabled()
				;
		this.deleteAll("datasets/all-tables.xml");
	}
	
	/**
	 * Limpa as tabelas e insere os registros respectivamente. Deletes ocorrem
	 * de baixo para cima, enquanto os inserts de cima para baixo.
	 */
	public void cleanAndInsert(String dataset) {
		this.dbunitManager
			.cleanAndInsert(new ClassPathDataSetSource(dataset));
	}
	
	/**
	 * Limpa as tabelas.
	 */
	public void deleteAll(String dataset) {
		this.dbunitManager
			.deleteAll(new ClassPathDataSetSource(dataset));
	}
}
