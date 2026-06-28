// https://github.com/Zeronetsec/Fyu

import std.array : join;
import std.range : drop;
import console.fyu_console : fyuConsole;

int main(string[] args) {
    string input = args.drop(1).join(" ");
    fyuConsole(input);
    return 0;
}

// Copyright (c) 2026 Zeronetsec