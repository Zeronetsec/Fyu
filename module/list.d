// https://github.com/Zeronetsec/Fyu

module module_.list;

import std.stdio;
import std.file;
import std.path;
import std.json;
import console.command_interface;
import utils.color;
import utils.getroot : getRoot;

class List : Command {
    void execute(string[] args) {
        string filter = "all";
        if (args.length > 0) {
            if (
                args[0] == "finish" ||
                args[0] == "unfinish"
            ) {
                filter = args[0];
            } else {
                writef(
                    "%s[!] %sInvalid filter: %s%s%s\n",
                    R, N, GG, args[0], N,
                );

                writef(
                    "%s[!] %sTry: %sfyu --help%s\n",
                    R, N, GG, N,
                );
                return;
            }
        }

        list_notes(filter);
    }

    void list_notes(string filter) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        if (!exists(dataDir) || !isDir(dataDir)) {
            writef(
                "%s[!] %sThere are no tasks yet!\n",
                R, N,
            );
            return;
        }

        bool hasFiles = false;
        foreach (DirEntry entry; dirEntries(
            dataDir, "*.json", SpanMode.shallow,
        )) {
            string fileContent = readText(entry.name);
            JSONValue note = parseJSON(fileContent);

            string name = note["name"].str;
            string startDate = note["start_date"].str;
            string finishDate = note["finish_date"].str;

            bool isFinished = (finishDate != "-");
            if (
                filter == "finish" &&
                !isFinished
            ) {
                continue;
            }

            if (
                filter == "unfinish" &&
                isFinished
            ) {
                continue;
            }

            hasFiles = true;
            writef(
                "%s* %s%s%s\n",
                DG, GG, name, N,
            );

            writef(
                "%s└── %sStart: %s%s%s\n",
                DG, N, GG, startDate, N,
            );

            writef(
                "%s└── %sFinish: %s%s%s\n",
                DG, N, GG, finishDate, N,
            );
            writeln();
        }

        if (!hasFiles) {
            if (filter == "finish") {
                writef(
                    "%s[!] %sThere are no finished tasks!\n",
                    R, N,
                );
            } else if (filter == "unfinish") {
                writef(
                    "%s[!] %sThere are no unfinished tasks!\n",
                    R, N,
                );
            } else {
                writef(
                    "%s[!] %sThere are no tasks yet!\n",
                    R, N,
                );
            }
        }
    }
}

// Copyright (c) 2026 Zeronetsec