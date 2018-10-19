package com.sirolf2009.eclipsetools

import org.eclipse.core.runtime.ILog
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.Status

class Logger {
	
	public static val ILog logger = Platform.getLog(Platform.getBundle("sirolf2009-eclipse-tools"))
	
	def static <T> info(T obj) {
		logger.log(new Status(Status.INFO, "sirolf2009-eclipse-tools", String.valueOf(obj)))
	}
	
}