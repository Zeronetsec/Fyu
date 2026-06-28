// https://github.com/Zeronetsec/Fyu

module module_.add_note;

import std.stdio;
import std.file;
import std.path;
import std.json;
import std.string : strip, chomp;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class AddNote : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }
        add_note(args[0]);
    }

    void add_note(string name) {
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

        write("Notes: ");
        string input = readln().chomp().strip();

        if (input.length == 0) {
            writef(
                "%s[!] %sNothing note entered!\n",
                R, N,
            );
            return;
        }

        string existingNotes = "-";
        if ("notes" in note && note["notes"].type == JSONType.string) {
            existingNotes = note["notes"].str.strip();
        }

        if (existingNotes == "-" || existingNotes.length == 0) {
            note["notes"] = input;
        } else {
            note["notes"] = existingNotes ~ "\n" ~ input;
        }

        std.file.write(filePath, note.toPrettyString());
        writef(
            "%s[+] %sNote added to: %s%s%s\n",
            GG, N, GG, name, N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec