// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

messageAction("installer");

Shell.mkdirRecursivelyIfNotExists("release");

Shell.setenv("PRODUCT_NAME", "installer-xyo-sdk");
Shell.setenv("PRODUCT_VERSION", Project.version);
Shell.setenv("PRODUCT_BASE", "xyo-sdk");
Shell.setenv("PRODUCT_PLATFORM", Platform.name);

exitIf(Shell.system("makensis.exe /NOCD \"source\\xyo-sdk-installer.nsi\""));
exitIf(Shell.system("grigore-stefan.sign \"XYO SDK\" \"release\\" + projectSuper + "-" + Project.version + "-installer.exe\""));
