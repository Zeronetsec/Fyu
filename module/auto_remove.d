// https://github.com/Zeronetsec/Fyu

module module_.auto_remove;

import std.stdio;
import std.file;
import std.path;
import std.json;
import console.command_interface;
import utils.color;
import utils.missing_argument : missingArgument;
import utils.getroot : getRoot;

class AutoRemove : Command {
    void execute(string[] args) {
        if (args.length < 1) {
            missingArgument();
            return;
        }

        string statusFilter = args[0];
        string dateFilter = "";

        if (
            statusFilter != "finish" &&
            statusFilter != "unfinish"
        ) {
            writef(
                "%s[!] %sInvalid filter: %s%s%s\n",
                color_R, color_N, color_GG, statusFilter, color_N,
            );

            writef(
                "%s[!] %sTry: %sfyu --help%s\n",
                color_R, color_N, color_GG, color_N,
            );
            return;
        }

        if (args.length > 1) {
            dateFilter = args[1];
        }

        auto_remove_notes(
            statusFilter, dateFilter,
        );
    }

    void auto_remove_notes(
        string statusFilter,
        string dateFilter,
    ) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        if (!exists(dataDir) || !isDir(dataDir)) {
            writef(
                "%s[!] %sThere are no tasks to remove!\n",
                color_R, color_N,
            );
            return;
        }

        int removedCount = 0;
        foreach (DirEntry entry; dirEntries(
            dataDir, "*.json", SpanMode.shallow,
        )) {
            string filePath = entry.name;
            string fileContent = readText(filePath);
            JSONValue note = parseJSON(fileContent);

            string name = note["name"].str;
            string startDate = note["start_date"].str;
            string finishDate = note["finish_date"].str;

            bool isFinished = (finishDate != "-");

            if (
                statusFilter == "finish" &&
                !isFinished
            ) {
                continue;
            }

            if (
                statusFilter == "unfinish" &&
                isFinished
            ) {
                continue;
            }

            if (
                dateFilter != "" &&
                startDate != dateFilter
            ) {
                continue;
            }

            std.file.remove(filePath);
            writef(
                "%s[-] %sTask: %s%s %sremoved successfully.\n",
                color_YY, color_N, color_GG, name, color_N,
            );
            removedCount++;
        }

        if (removedCount == 0) {
            writef(
                "%s[!] %sNo tasks matched the criteria for removal!\n",
                color_R, color_N,
            );
        } else {
            writef(
                "%s[+] %sTotal %s%d %stasks removed.\n",
                color_GG, color_N, color_GG, removedCount, color_N,
            );
        }
    }
}

// Copyright (c) 2026 Zeronetsec