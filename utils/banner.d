// https://github.com/Zeronetsec/Fyu

module utils.banner;

import std.stdio;
import utils.color;

private enum string bannerText = import("data/ascii.txt");
void banner() {
    writef(
        "%s%s%s\n",
        B, bannerText, N,
    );
}

// Copyright (c) 2026 Zeronetsec