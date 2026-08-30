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
            color_N, color_GG, name, color_N,
        );

        writef(
            "%sVersion: %s%s%s\n",
            color_N, color_GG, ver, color_N,
        );

        writef(
            "%sCreator: %s%s%s\n",
            color_N, color_GG, creator, color_N,
        );

        writef(
            "%sHomepage: %s%s%s\n",
            color_N, color_GG, homepage, color_N,
        );
    }
}

// Copyright (c) 2026 Zeronetsec