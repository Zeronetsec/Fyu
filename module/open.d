// https://github.com/Zeronetsec/Fyu

module module_.open;

import std.stdio;
import std.file;
import std.path;
import std.json;
import std.string : strip, splitLines;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Open : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }
        open_note(args[0]);
    }

    void open_note(string name) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        string filePattern = name ~ "*.json";
        string filePath;
        bool fileFound = false;

        if (exists(dataDir) && isDir(dataDir)) {
            foreach (DirEntry entry; dirEntries(
                dataDir,
                filePattern,
                SpanMode.shallow,
            )) {
                filePath = entry.name;
                fileFound = true;
                break;
            }
        }

        if (fileFound && exists(filePath)) {
            string fileContent = readText(filePath);
            JSONValue note = parseJSON(fileContent);

            string taskName = note["name"].str;
            string startDate = note["start_date"].str;
            string finishDate = note["finish_date"].str;

            string notesContent = "-";
            if (
                "notes" in note &&
                note["notes"].type == JSONType.string
            ) {
                notesContent = note["notes"].str.strip();
            }

            writef(
                "%s%s%s\n",
                color_GG, taskName, color_N,
            );

            writef(
                "%sStart: %s%s%s\n",
                color_N, color_GG, startDate, color_N,
            );

            writef(
                "%sFinish: %s%s%s\n",
                color_N, color_GG, finishDate, color_N,
            );

            if (
                notesContent == "-" ||
                notesContent.length == 0
            ) {
                writef(
                    "%sNotes: %s-%s\n",
                    color_N, color_GG, color_N,
                );
            } else {
                writef(
                    "%sNotes:\n",
                    color_N,
                );

                foreach (
                    line; notesContent.splitLines()) {
                    writef(
                        "%s- %s%s%s\n",
                        color_DG, color_WW, line, color_N,
                    );
                }
            }
        } else {
            writef(
                "%s[!] %sTask: %s%s %snot found!\n",
                color_R, color_N, color_GG, name, color_N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec