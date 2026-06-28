// https://github.com/Zeronetsec/Fyu

module module_.create;

import std.stdio;
import std.file;
import std.path;
import std.json;
import std.datetime;
import std.string : strip;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class Create : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }

        string name = args[0].strip();
        string startDate = "";

        if (args.length >= 2) {
            startDate = args[1].strip();
        }
        create_note(name, startDate);
    }

    void create_note(string name, string startDate) {
        if (startDate.length == 0) {
            auto currentTime = Clock.currTime();
            startDate = currentTime.toISOExtString()[0..10];
        }

        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        if (!exists(dataDir)) {
            mkdirRecurse(dataDir);
        }

        string fileName = name ~ "_" ~ startDate ~ ".json";
        string path = buildPath(dataDir, fileName);

        if (exists(path)) {
            writef(
                "%s[!] %sTask: %s%s %sis already exist!\n",
                R, N, GG, name, N,
            );
            return;
        }

        JSONValue note;
        note["name"] = name;
        note["start_date"] = startDate;
        note["finish_date"] = "-";

        std.file.write(path, note.toPrettyString());
        writef(
            "%s[+] %sTask: %s%s %screated successfully\n",
            GG, N, GG, name, N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec