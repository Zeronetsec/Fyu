// https://github.com/Zeronetsec/Fyu

module module_.version_;

import std.stdio;
import console.command_interface;
import utils.color;

class Version : Command {
    void execute(string[] args) {
        enum string name = "Fyu";
        enum string ver = "v0.1";
        enum string creator = "Zeronetsec";
        enum string homepage = "https://github.com/Zeronetsec/Fyu";

        writef(
            "%sName: %s%s%s\n",
            N, GG, name, N,
        );

        writef(
            "%sVersion: %s%s%s\n",
            N, GG, ver, N,
        );

        writef(
            "%sCreator: %s%s%s\n",
            N, GG, creator, N,
        );

        writef(
            "%sHomepage: %s%s%s\n",
            N, GG, homepage, N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec