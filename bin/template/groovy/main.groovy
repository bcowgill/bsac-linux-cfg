#!/usr/bin/env groovy
class Example {
	static void main(String[] args) {
		def rootFiles = new File("").listRoots();
		rootFiles.each {
			file -> println file.absolutePath
		}
	}
}
