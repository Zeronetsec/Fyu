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
                YY, N, GG, name, N,
            );
        } else {
            writef(
                "%s[!] %sTask: %s%s %snot found!\n",
                R, N, GG, name, N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec