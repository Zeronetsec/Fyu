// https://github.com/Zeronetsec/Fyu

module module_.helper;

import std.stdio;
import std.json;
import std.string : splitLines;
import console.command_interface;
import utils.color;
import utils.banner : banner;
import utils.birthday : birthday;

class Helper : Command {
    private struct Helperp {
        string command;
        string args;
        string description;
    }

    private static immutable string[string] metaFS = () {
        string[string] embedded;
        enum string[] jsonFiles = import("metadata.txt").splitLines();
        static foreach (file; jsonFiles) {
            static if (file.length > 0) {
                embedded[file] = import("metadata/" ~ file);
            }
        }
        return embedded;
    }();

    void execute(string[] args) {
        banner();
        birthday();
        writef(
            "%sUsage: %sfyu %s<option> [<args>]%s\n",
            N, GG, CC, N
        );
        writeln();

        writef(
            "%sAvailable options:\n",
            N,
        );

        foreach (filePath, fileContent; metaFS) {
            try {
                JSONValue json = parseJSON(fileContent);

                Helperp hp;
                hp.command = json["Command"].str;
                hp.args = "Args" in json ? json["Args"].str : "";
                hp.description = json["Description"].str;

                string argsStr = hp.args != "" ? " " ~ hp.args : "";
                writef(
                    "    %s* %s%s%s%s%s\n",
                    DG, GG, hp.command, CC, argsStr, N
                );

                writef(
                    "    %s└── %s%s%s\n",
                    DG, WW, hp.description, N
                );
            }
            catch (JSONException e) {
                writef(
                    "%s[!] %sError parsing %s: %s%s%s\n",
                    R, N, filePath, GG, e.msg, N
                );
            }
        }
    }
}

// Copyright (c) 2026 Zeronetsec