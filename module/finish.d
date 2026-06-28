// https://github.com/Zeronetsec/Fyu

module module_.finish;

import std.stdio;
import std.file;
import std.path;
import std.json;
import std.datetime;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Finish : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }
        finish_note(args[0]);
    }

    void finish_note(string name) {
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

        auto currentTime = Clock.currTime();
        string finishDate = currentTime.toISOExtString()[0..10];

        note["finish_date"] = finishDate;
        std.file.write(filePath, note.toPrettyString());
        writef(
            "%s[+] %sTask: %s%s %sfinished on %s%s%s\n",
            GG, N, GG, name, N, GG, finishDate, N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec