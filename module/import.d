// https://github.com/Zeronetsec/Fyu

module module_.import_;

import std.stdio;
import std.file;
import std.path;
import std.zip;
import std.algorithm : endsWith;
import std.string : strip;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Import : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }

        string zipPath = args[0].strip();
        if (!zipPath.endsWith(".zip")) {
            writef(
                "%s[!] %sInvalid file extension!\n",
                color_R, color_N,
            );

            writef(
                "%s[!] %sOnly: %s.zip%s\n",
                color_R, color_N, color_GG, color_N,
            );
            return;
        }

        if (!exists(zipPath) || !isFile(zipPath)) {
            writef(
                "%s[!] %sBackup file: %s%s %snot found!\n",
                color_R, color_N, color_GG, zipPath, color_N,
            );
            return;
        }

        import_from_zip(zipPath);
    }

    void import_from_zip(string zipPath) {
        string destDir = buildPath(
            getRoot(), "data", "user_data",
        );

        if (!exists(destDir)) {
            mkdirRecurse(destDir);
        }

        auto zipData = std.file.read(zipPath);
        auto zip = new ZipArchive(zipData);
        size_t importedCount = 0;

        foreach (
            string name,
            ArchiveMember am; zip.directory) {
            if (name.endsWith(".json")) {
                zip.expand(am);
                string destFilePath = buildPath(
                    destDir, baseName(name),
                );

                std.file.write(
                    destFilePath, am.expandedData,
                );
                importedCount++;
            }
        }

        if (importedCount == 0) {
            writef(
                "%s[!] %sNo valid .json tasks found inside the zip file!\n",
                color_R, color_N,
            );
        } else {
            writef(
                "%s[+] %sSuccessfully imported: %s%d %stasks %s-> %s%s/%s\n",
                color_GG, color_N, color_GG, importedCount, color_N, color_DG,
                color_GG, destDir, color_N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec