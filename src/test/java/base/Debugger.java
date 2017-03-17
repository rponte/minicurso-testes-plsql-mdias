package base;

import java.lang.management.ManagementFactory;

public class Debugger {

	public boolean isEnabled() {
		boolean isDebug = ManagementFactory.getRuntimeMXBean()
						.getInputArguments()
						.toString().indexOf("jdwp") >= 0;
		return isDebug;
	}
}
