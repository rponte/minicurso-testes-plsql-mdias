package base.junitrules;

import org.junit.rules.TestWatcher;
import org.junit.runner.Description;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShowPrintStackTraceRule extends TestWatcher {
	
	private static final Logger logger = LoggerFactory.getLogger("jUnit");

	@Override
	protected void failed(Throwable e, Description description) {
		String msg = "jUnit Test '{className}.{methodName}()' failed when calling '{stmt}' with this stacktrace:"
				.replace("{stmt}", description.getDisplayName())
				.replace("{className}", description.getTestClass().getSimpleName())
				.replace("{methodName}", description.getMethodName());
		
		logger.error(msg);
		e.printStackTrace();
	}
	
}
