// https://github.com/Zeronetsec/Fyu

module module_.info;

import std.stdio;
import std.file;
import std.path;
import std.json;
import console.command_interface;
import utils.color;
import utils.getroot : getRoot;

class Info : Command {
    void execute(string[] args) {
        string filter = "all";
        if (args.length > 0) {
            if (
                args[0] == "finish" ||
                args[0] == "unfinish"
            ) {
                filter = args[0];
            } else {
                writef(
                    "%s[!] %sInvalid filter: %s%s%s\n",
                    color_R, color_N, color_GG, args[0], color_N,
                );

                writef(
                    "%s[!] %sTry: %sfyu --help%s\n",
                    color_R, color_N, color_GG, color_N,
                );
                return;
            }
        }

        show_info(filter);
    }

    void show_info(string filter) {
        string dataDir = buildPath(
            getRoot(), "data", "user_data",
        );

        if (!exists(dataDir) || !isDir(dataDir)) {
            writef(
                "%s[!] %sThere are no tasks found!\n",
                color_R, color_N,
            );
            return;
        }

        int totalTasks = 0;
        int finishedTasks = 0;
        int unfinishedTasks = 0;

        struct TaskSummary {
            string name;
            string startDate;
            string finishDate;
        }

        TaskSummary[] tasks;

        foreach (DirEntry entry; dirEntries(
            dataDir, "*.json", SpanMode.shallow,
        )) {
            string fileContent = readText(entry.name);
            JSONValue note = parseJSON(fileContent);

            string name = note["name"].str;
            string startDate = note["start_date"].str;
            string finishDate = note["finish_date"].str;

            bool isFinished = (finishDate != "-");

            totalTasks++;
            if (isFinished) {
                finishedTasks++;
            } else {
                unfinishedTasks++;
            }

            tasks ~= TaskSummary(
                name, startDate, finishDate,
            );
        }

        if (totalTasks == 0) {
            writef(
                "%s[!] %sThere are no tasks found!\n",
                color_R, color_N,
            );
            return;
        }

        if (filter == "all") {
            double percentage = (
                cast(double) finishedTasks / totalTasks
            ) * 100.0;

            writef(
                "%s[*] %sTotal Tasks: %s%d%s\n",
                color_B, color_N, color_GG, totalTasks, color_N,
            );

            writef(
                "%s[*] %sFinished Tasks: %s%d%s\n",
                color_B, color_N, color_GG, finishedTasks, color_N,
            );

            writef(
                "%s[*] %sUnfinished Tasks: %s%d%s\n",
                color_B, color_N, color_GG, unfinishedTasks, color_N,
            );

            writef(
                "%s[*] %sCompletion Rate: %s%.1f%%%s\n",
                color_B, color_N, color_GG, percentage, color_N,
            );

        } else if (filter == "finish") {
            double percentage = (
                cast(double) finishedTasks / totalTasks
            ) * 100.0;
            writef(
                "%s[*] %sFinished Tasks: %s%d %s/ %s%d %s(%s%.1f%%%s)%s\n",
                color_B, color_N, color_GG, finishedTasks, color_DG,
                color_GG, totalTasks, color_DG, color_CC, percentage, color_DG,
                color_N,
            );

            writef(
                "%sCompleted Task List:\n",
                color_N,
            );

            bool found = false;
            foreach (t; tasks) {
                if (t.finishDate != "-") {
                    found = true;
                    writef(
                        "%s* %s%s %s(%sStart: %s%s %s| %sFinish: %s%s%s)%s\n",
                        color_DG, color_GG, t.name, color_DG,
                        color_WW, color_GG, t.startDate, color_DG,
                        color_WW, color_GG, t.finishDate, color_DG,
                        color_N,
                    );
                }
            }
            if (!found) {
                writef(
                    "%s[!] %sNo finished tasks available.\n",
                    color_R, color_N,
                );
            }

        } else if (filter == "unfinish") {
            double percentage = (
                cast(double) unfinishedTasks / totalTasks
            ) * 100.0;
            writef(
                "%s[*] %sUnfinished Tasks: %s%d %s/ %s%d %s(%s%.1f%%%s)%s\n",
                color_B, color_N, color_GG, unfinishedTasks, color_DG,
                color_GG, totalTasks, color_DG, color_CC, percentage, color_DG,
                color_N,
            );

            writef(
                "%sPending Task List:\n",
                color_N,
            );

            bool found = false;
            foreach (t; tasks) {
                if (t.finishDate == "-") {
                    found = true;
                    writef(
                        "%s* %s%s %s(%sStart: %s%s%s)%s\n",
                        color_DG, color_GG, t.name, color_DG,
                        color_WW, color_GG, t.startDate, color_DG,
                        color_N,
                    );
                }
            }
            if (!found) {
                writef(
                    "%s[!] %sNo unfinished tasks available!\n",
                    color_R, color_N,
                );
            }
        }
    }
}

// Copyright (c) 2026 Zeronetsec