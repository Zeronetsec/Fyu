// https://github.com/Zeronetsec/Fyu

module utils.invalid_option;

import std.stdio;
import utils.color;

void invalidOption(string input) {
    writef(
        "%s[!] %sInvalid option: %s%s%s\n",
        color_R, color_N, color_GG, input, color_N,
    );

    writef(
        "%s[!] %sTry: %sfyu --help%s\n",
        color_R, color_N, color_GG, color_N,
    );
}

// Copyright (c) 2026 Zeronetsec