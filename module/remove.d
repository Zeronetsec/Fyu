// https://github.com/Zeronetsec/Fyu

module module_.remove;

import std.stdio;
import std.file;
import std.path;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Remove : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }
        remove_note(args[0]);
    }

    void remove_note(string name) {
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

        if (fileFound && exists(filePath)) {
            remove(filePath);
            writef(
                "%s[-] %sTask: %s%s %sremoved successfully\n",
                color_YY, color_N, color_GG, name, color_N,
            );
        } else {
            writef(
                "%s[!] %sTask: %s%s %snot found!\n",
                color_R, color_N, color_GG, name, color_N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec