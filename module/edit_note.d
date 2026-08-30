// https://github.com/Zeronetsec/Fyu

module module_.edit_note;

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

class EditNote : Command {
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
                color_R, color_N,
            );
            return;
        }

        edit_note(taskName, noteNum);
    }

    void edit_note(string name, int noteNum) {
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
                color_R, color_N, color_GG, name, color_N,
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
                "%s[!] %sNo notes to edit in task: %s%s%s\n",
                color_R, color_N, color_GG, name, color_N,
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
                color_R, color_N,
            );

            writef(
                "%s[*] %sAvailable note count for %s%s%s: %s1 %s- %s%d%s\n",
                color_B, color_N, color_GG, name, color_N,
                color_GG, color_DG, color_GG, notesArray.length, color_N,
            );
            return;
        }

        int arrayIndex = noteNum - 1;
        writef(
            "%sCurrent note %s[%s%d%s]%s: %s%s%s\n",
            color_N, color_DG, color_B, noteNum, color_DG, color_N,
            color_GG, notesArray[arrayIndex], color_N,
        );

        write("New note: ");
        string input = readln().chomp().strip();
        if (input.length == 0) {
            writef(
                "%s[!] %sInput cannot be empty!\n",
                color_R, color_N,
            );

            writef(
                "%s[!] %sEdit cancelled!\n",
                color_R, color_N,
            );
            return;
        }

        notesArray[arrayIndex] = input;
        note["notes"] = notesArray.join("\n");
        std.file.write(
            filePath, note.toPrettyString(),
        );

        writef(
            "%s[+] %sNote %s%d %supdated in: %s%s%s\n",
            color_GG, color_N, color_GG, noteNum, color_N,
            color_GG, name, color_N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec