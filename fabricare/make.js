// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022-2023 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

// ---

messageAction("make");

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("temp");

if (!Shell.fileExists("temp/extract.done.flag")) {

	for (var file of fileList) {
		var path = "output";
		if (file.indexOf("perl") >= 0) {
			continue;
		};
		if (file.indexOf("httpd") >= 0) {
			continue;
		};
		if (file.indexOf("llvm") >= 0) {
			continue;
		};
		if (file.indexOf(Platform.name + ".7z") >= 0) {
			path = "output/bin";
		};
		Shell.mkdirRecursivelyIfNotExists(path);
		exitIf(Shell.system("7z x -aoa -o" + path + "/ vendor/" + file));
	};
	Shell.filePutContents("temp/extract.done.flag", "done");
};

Shell.copyFile("source/xyo-sdk.license.txt", "output/license.txt");
Shell.copyFile("source/xyo.ico", "output/xyo.ico");
