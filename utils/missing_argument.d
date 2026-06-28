// https://github.com/Zeronetsec/Fyu

module utils.missing_argument;

import std.stdio;
import utils.color;

void missingArgument() {
    writef(
        "%s[!] %sMissing argument!\n",
        R, N,
    );

    writef(
        "%s[!] %sTry: %sfyu --help%s\n",
        R, N, GG, N,
    );
}

// Copyright (c) 2026 Zeronetsec