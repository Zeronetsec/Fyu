// https://github.com/Senzdetta/Fyu

module utils.getroot;

import std.process : environment;
import std.path : buildPath;

string getRoot() {
    string home = environment.get("HOME", ".");
    return buildPath(
        home, ".local", "opt", "fyu",
    );
}

// Copyright (c) 2026 Senzdetta