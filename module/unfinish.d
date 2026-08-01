// https://github.com/Zeronetsec/Fyu

module module_.unfinish;

import std.stdio;
import std.file;
import std.path;
import std.json;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Unfinish : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }
        unfinish_note(args[0]);
    }

    void unfinish_note(string name) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        string filePattern = name ~ "*.json";
        string filePath;
        bool fileFound = false;

        if (exists(dataDir) && isDir(dataDir)) {
            foreach (DirEntry entry; dirEntries(
                dataDir, filePattern, SpanMode.shallow,
            )) {
                filePath = entry.name;
                fileFound = true;
                break;
            }
        }

        if (!fileFound || !exists(filePath)) {
            writef(
                "%s[!] %sTask: %s%s %snot found!\n",
                R, N, GG, name, N,
            );
            return;
        }

        string fileContent = readText(filePath);
        JSONValue note = parseJSON(fileContent);

        note["finish_date"] = "-";
        std.file.write(
            filePath, note.toPrettyString(),
        );

        writef(
            "%s[-] %sTask: %s%s %ssuccessfully reset to unfinished.\n",
            YY, N, GG, name, N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec