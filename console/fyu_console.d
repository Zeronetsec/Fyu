// https://github.com/Zeronetsec/Fyu

module console.fyu_console;

import std.stdio;
import std.string : split;
import core.stdc.stdlib : exit;
import utils.missing_argument : missingArgument;
import utils.invalid_option : invalidOption;
import console.command_interface;
import console.pubmod;

void fyuConsole(string input) {
    string[] args = input.split(" ");
    if (args.length == 0 || args[0] == "") {
        missingArgument();
        exit(1);
    }

    string trigger = args[0];
    string[] remainingArgs = args[1 .. $];

    Command[string] commandMap;
    commandMap["--version"] = new Version();
    commandMap["--help"] = new Helper();
    commandMap["--uwu"] = new Uwu();
    commandMap["--add-note"] = new AddNote();
    commandMap["--create"] = new Create();
    commandMap["--remove"] = new Remove();
    commandMap["--finish"] = new Finish();
    commandMap["--list"] = new List();
    commandMap["--open"] = new Open();
    commandMap["--rename"] = new Rename();
    commandMap["--export"] = new Export();
    commandMap["--import"] = new Import();
    commandMap["--search"] = new Search();

    if (auto cmd = trigger in commandMap) {
        (*cmd).execute(remainingArgs);
    } else {
        invalidOption(trigger);
        exit(1);
    }
}

// Copyright (c) 2026 Zeronetsec