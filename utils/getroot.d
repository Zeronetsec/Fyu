// https://github.com/Zeronetsec/Fyu

module utils.getroot;

import std.process : environment;
import std.path : buildPath;

string getRoot() {
    string prefix = environment.get("PREFIX", "/usr");
    return buildPath(prefix, "opt", "fyu");
}

// Copyright (c) 2026 Zeronetsec