// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

messageAction("vendor");

Shell.mkdirRecursivelyIfNotExists("vendor");

var projectSuper = "xyo-sdk";
var projectSource = projectSuper + "-" + Project.version + ".json";

if (!Shell.fileExists("vendor/" + projectSource)) {
	var cmd = "curl --insecure --location https://github.com/g-stefan/" + projectSuper + "/releases/download/v" + Project.version + "/" + projectSource + " --output vendor/" + projectSource;
	Console.writeLn(cmd);
	exitIf(Shell.system(cmd));
	if (!(Shell.getFileSize("vendor/" + projectSource) > 16)) {
		messageError("download source");
		Script.exit(1);
	};
};

var jsonContent = Shell.fileGetContents("vendor/" + projectSource);
if (Script.isNil(jsonContent)) {
	messageError("load source");
	Script.exit(1);
};

var json = JSON.decode(jsonContent);

if (Script.isNil(json)) {
	messageError("decode json");
	Script.exit(1);
};

var fileList = [];

for (var project in json) {
	var release = "";
	for (var releaseInfo of json[project].release) {
		if (releaseInfo.indexOf(Platform.name + "-dev.7z") >= 0) {
			release = releaseInfo;
		};
	};
	if (release.length == 0) {
		for (var releaseInfo of json[project].release) {
			if (releaseInfo.indexOf(Platform.name + ".7z") >= 0) {
				release = releaseInfo;
			};
		};
	};
	if (release.length == 0) {
		messageError("no release for " + project);
		Script.exit(1);
	};
	fileList[fileList.length] = release;
	if (!Shell.fileExists("vendor/" + release)) {
		var cmd = "curl --insecure --location https://github.com/g-stefan/" + project + "/releases/download/v" + json[project].version + "/" + release + " --output vendor/" + release;
		Console.writeLn(cmd);
		exitIf(Shell.system(cmd));
		if (!(Shell.getFileSize("vendor/" + release) > 16)) {
			Shell.remove("vendor/" + release);
			messageError("download release");
			Script.exit(1);
		};
	};
};

