// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

// ---

messageAction("make");

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("temp");

if (!Shell.fileExists("temp/extract.done.flag")) {

	for (var file of fileList) {
		var path = "output";
		if (file.indexOf("perl")>=0) {
			continue;
		};
		if (file.indexOf("httpd")>=0) {
			continue;
		};
		if (file.indexOf("llvm")>=0) {
			continue;
		};
		if (file.indexOf(Platform.name+".7z")>=0) {
			path = "output/bin";
		};
		Shell.mkdirRecursivelyIfNotExists(path);
		exitIf(Shell.system("7z x -aoa -o" + path + "/ vendor/" + file));
	};
	Shell.filePutContents("temp/extract.done.flag", "done");
};

if (!Shell.fileExists("temp/installer.done.flag")) {

	Shell.copyFile("source/xyo-sdk.license.txt", "output/license.txt");
	Shell.copyFile("source/xyo.ico", "output/xyo.ico");

	Shell.removeDirRecursively("release");
	Shell.mkdirRecursivelyIfNotExists("release");

	Shell.setenv("PRODUCT_NAME", "installer-xyo-sdk");
	Shell.setenv("PRODUCT_VERSION", Project.version);
	Shell.setenv("PRODUCT_BASE", "xyo-sdk");
	Shell.setenv("PRODUCT_PLATFORM", Platform.name);

	exitIf(Shell.system("makensis.exe /NOCD \"source\\xyo-sdk-installer.nsi\""));
	exitIf(Shell.system("grigore-stefan.sign \"XYO SDK\" \"release\\" + projectSuper + "-" + Project.version + "-installer.exe\""));

	Shell.filePutContents("temp/installer.done.flag", "done");
};

