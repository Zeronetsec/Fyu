// https://github.com/Zeronetsec/Fyu

module module_.export_;

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

class Export : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }
        string zipName = args[0].strip();

        if (!zipName.endsWith(".zip")) {
            writef(
                "%s[!] %sInvalid file extension!\n",
                R, N,
            );

            writef(
                "%s[!] %sOnly: %s.zip%s\n",
                R, N, GG, N,
            );
            return;
        }
        export_to_zip(zipName);
    }

    void export_to_zip(string zipName) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        if (!exists(dataDir) || !isDir(dataDir)) {
            writef(
                "%s[!] %sSource directory: %s%s %sdoes not exist!\n",
                R, N, GG, dataDir, N,
            );
            return;
        }

        auto zip = new ZipArchive();
        bool hasFiles = false;

        foreach (DirEntry entry; dirEntries(
            dataDir, SpanMode.shallow,
        )) {
            if (entry.isFile) {
                hasFiles = true;
                auto fileData = std.file.read(entry.name);
                auto am = new ArchiveMember();

                am.name = baseName(entry.name);
                am.expandedData(cast(ubyte[]) fileData);
                am.compressionMethod = CompressionMethod.deflate;

                zip.addMember(am);
            }
        }

        if (!hasFiles) {
            writef(
                "%s[!] %sNo data found in %s%s %sto export!\n",
                R, N, GG, dataDir, N,
            );
            return;
        }

        void[] compressedData = zip.build();
        std.file.write(zipName, cast(ubyte[]) compressedData);
        writef(
            "%s[+] %sSuccessfully exported all task: %s%s%s\n",
            GG, N, GG, zipName, N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec