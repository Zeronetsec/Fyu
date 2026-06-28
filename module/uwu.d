// https://github.com/Zeronetsec/Fyu

module module_.uwu;

import std.stdio;
import std.datetime;
import core.thread;
import console.command_interface;

class Uwu : Command {
    void execute(string[] args) {
        nyanners(5.seconds);
    }

    void nyanners(Duration duration) {
        string[] faces = [
            "(｡◕‿◕｡)",
            "(≧◡≦)",
            "ʕ•ᴥ•ʔ",
            "(・ω・)",
            "(๑˃ᴗ˂)ﻭ",
            "(ง'̀-'́)ง",
            "(=^･ω･^=)"
        ];

        auto delay = 200.msecs;
        auto endTime = MonoTime.currTime + duration;
        size_t kaomoji = 0;

        writef("\x1b[?25l");
        while (MonoTime.currTime < endTime) {
            writef(
                "\r%s\x1b[K",
                faces[kaomoji % faces.length],
            );

            stdout.flush();
            Thread.sleep(delay);
            kaomoji++;
        }

        write("\x1b[K");
        writefln("\x1b[?25h");
        stdout.flush();
    }
}

// Copyright (c) 2026 Zeronetsec