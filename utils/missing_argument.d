// https://github.com/Zeronetsec/Fyu

module utils.missing_argument;

import std.stdio;
import utils.color;

void missingArgument() {
    writef(
        "%s[!] %sMissing argument!\n",
        color_R, color_N,
    );

    writef(
        "%s[!] %sTry: %sfyu --help%s\n",
        color_R, color_N, color_GG, color_N,
    );
}

// Copyright (c) 2026 Zeronetsec