// https://github.com/Zeronetsec/Fyu

module utils.birthday;

import std.stdio;
import std.datetime;
import std.format;
import utils.color;

void birthday() {
    auto now = Clock.currTime;
    string currentDate = format(
        "%02d-%02d", cast(int)now.month, now.day,
    );

    string bdate = "06-26";
    if (currentDate == bdate) {
        writef(
            "%s› %sHappy birthday for %sfyu %s🎉\n",
            R, N, GG, N
        );
        writeln();
    }
}

// Copyright (c) 2026 Zeronetsec