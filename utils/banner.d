// https://github.com/Zeronetsec/Fyu

module utils.banner;

import std.stdio;
import utils.color;

private enum string bannerText = import("data/ascii.txt");
void banner() {
    writef(
        "%s%s%s\n",
        color_B, bannerText, color_N,
    );
}

// Copyright (c) 2026 Zeronetsec