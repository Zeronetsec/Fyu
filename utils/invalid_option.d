// https://github.com/Zeronetsec/Fyu

module utils.invalid_option;

import std.stdio;
import utils.color;

void invalidOption(string input) {
    writef(
        "%s[!] %sInvalid option: %s%s%s\n",
        R, N, GG, input, N,
    );

    writef(
        "%s[!] %sTry: %sfyu --help%s\n",
        R, N, GG, N,
    );
}

// Copyright (c) 2026 Zeronetsec