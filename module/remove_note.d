// https://github.com/Zeronetsec/Fyu

module module_.remove_note;

import std.stdio;
import std.file;
import std.path;
import std.json;
import std.string : strip, chomp, split;
import std.array : join;
import std.conv : to, ConvException;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class RemoveNote : Command {
    void execute(string[] args) {
        if (args.length < 2) {
            missingArgument();
            return;
        }

        string taskName = args[0];
        string noteNumStr = args[1];
        int noteNum;

        try {
            noteNum = to!int(noteNumStr);
        } catch (ConvException e) {
            writef(
                "%s[!] %sNote number must be an integer!\n",
                R, N,
            );
            return;
        }
        remove_note(taskName, noteNum);
    }

    void remove_note(string name, int noteNum) {
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

        string existingNotes = "-";
        if (
            "notes" in note &&
            note["notes"].type == JSONType.string
        ) {
            existingNotes = note["notes"].str.strip();
        }

        if (
            existingNotes == "-" ||
            existingNotes.length == 0
        ) {
            writef(
                "%s[!] %sNo notes to remove in task: %s%s%s\n",
                R, N, GG, name, N,
            );
            return;
        }

        string[] notesArray = existingNotes.split("\n");
        if (
            noteNum < 1 ||
            noteNum > notesArray.length
        ) {
            writef(
                "%s[!] %sInvalid note number!\n",
                R, N,
            );

            writef(
                "%s[*] %sAvailable note count for %s%s%s: %s1 %s- %s%d%s\n",
                B, N, GG, name, N,
                GG, DG, GG, notesArray.length, N,
            );
            return;
        }

        int arrayIndex = noteNum - 1;
        writef(
            "%sRemoved note %s[%s%d%s]%s: %s%s%s\n",
            N, DG, B, noteNum, DG, N,
            GG, notesArray[arrayIndex], N,
        );

        notesArray = notesArray[
            0 .. arrayIndex
        ] ~ notesArray[arrayIndex + 1 .. $];

        if (notesArray.length == 0) {
            note["notes"] = "-";
        } else {
            note["notes"] = notesArray.join("\n");
        }

        std.file.write(
            filePath, note.toPrettyString(),
        );

        writef(
            "%s[-] %sNote %s%d %ssuccessfully removed from: %s%s%s\n",
            YY, N, GG, noteNum, N, GG, name, N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec