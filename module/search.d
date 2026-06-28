// https://github.com/Zeronetsec/Fyu

module module_.search;

import std.stdio;
import std.file;
import std.path;
import std.json;
import std.string : strip, toLower;
import std.algorithm : canFind;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Search : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }
        search_in_notes(args[0].strip());
    }

    void search_in_notes(string keyword) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        if (!exists(dataDir) || !isDir(dataDir)) {
            writef(
                "%s[!] %sData directory not found!\n",
                R, N,
            );
            return;
        }

        string lowerKeyword = keyword.toLower();
        bool foundAny = false;

        writef(
            "%s[*] %sSearching for notes containing: %s%s%s\n",
            B, N, GG, keyword, N,
        );

        foreach (DirEntry entry; dirEntries(
            dataDir, "*.json", SpanMode.shallow,
        )) {
            string fileContent = readText(entry.name);
            JSONValue note = parseJSON(fileContent);

            if ("notes" in note && note["notes"].type == JSONType.string) {
                string notesContent = note["notes"].str;
                if (notesContent.toLower().canFind(lowerKeyword)) {
                    foundAny = true;
                    string taskName = note["name"].str;
                    string startDate = note["start_date"].str;

                    writef(
                        "%sTask: %s%s %s(%s%s%s)%s\n",
                        N, GG, taskName, DG, CC, startDate, DG, N,
                    );

                    writef(
                        "%s└── %sNotes: %s%s%s\n",
                        DG, N, WW, notesContent, N,
                    );
                    writeln();
                }
            }
        }

        if (!foundAny) {
            writef(
                "%s[!] %sNo notes found matching: %s%s%s\n",
                R, N, GG, keyword, N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec