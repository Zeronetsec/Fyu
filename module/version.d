// https://github.com/Senzdetta/Fyu

module module_.version_;

import std.stdio;
import console.command_interface;
import utils.color;

class Version : Command {
    void execute(string[] args) {
        enum string name = "Fyu";
        enum string ver = "v0.1.20261103";
        enum string developer = "Senzdetta";
        enum string homepage = "https://github.com/Senzdetta/Fyu";

        writef(
            "%s- %s%s %s-%s\n",
            color_DG, color_GG, name, color_DG, color_N,
        );

        writef(
            "%sVersion: %s%s%s\n",
            color_N, color_GG, ver, color_N,
        );

        writef(
            "%sDeveloper: %s%s%s\n",
            color_N, color_GG, developer, color_N,
        );

        writef(
            "%sHomepage: %s%s%s\n",
            color_N, color_GG, homepage, color_N,
        );
    }
}

// Copyright (c) 2026 Senzdetta