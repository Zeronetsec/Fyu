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
        list_notes();
    }

    void list_notes() {
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
            hasFiles = true;

            string fileContent = readText(entry.name);
            JSONValue note = parseJSON(fileContent);

            string name = note["name"].str;
            string startDate = note["start_date"].str;
            string finishDate = note["finish_date"].str;

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
            writef(
                "%s[!] %sThere are no tasks yet!\n",
                R, N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec