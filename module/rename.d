// https://github.com/Zeronetsec/Fyu

module module_.rename;

import std.stdio;
import std.file;
import std.path;
import std.json;
import std.array : split;
import std.string : strip;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Rename : Command {
    void execute(string[] args) {
        if (args.length < 2) {
            missingArgument();
            return;
        }
        rename_note(args[0].strip(), args[1].strip());
    }

    void rename_note(string oldName, string newName) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        string filePattern = oldName ~ "*.json";
        bool fileFound = false;

        if (exists(dataDir) && isDir(dataDir)) {
            foreach (DirEntry entry; dirEntries(
                dataDir, filePattern, SpanMode.shallow,
            )) {
                fileFound = true;

                string filename = stripExtension(baseName(entry.name));
                string[] parts = filename.split("_");
                string date = "";

                if (parts.length >= 2) {
                    date = filename[parts[0].length + 1 .. $];
                }

                string newFileName = newName ~ "_" ~ date ~ ".json";
                string newFilePath = buildPath(dataDir, newFileName);

                string fileContent = readText(entry.name);
                JSONValue data = parseJSON(fileContent);
                data["name"] = newName;
                std.file.write(newFilePath, data.toPrettyString());
                remove(entry.name);

                writef(
                    "%s[+] %sRenamed: %s%s %s-> %s%s%s\n",
                    GG, N, GG, oldName, DG, GG, newName, N,
                );
            }
        }

        if (!fileFound) {
            writef(
                "%s[!] %sTask: %s%s %snot found!\n",
                R, N, GG, oldName, N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec