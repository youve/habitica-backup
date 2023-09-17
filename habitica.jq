#!/usr/bin/jq -f

def todos:
    [.tasks.todos |
    reverse |
    map(select(.completed == false))[] |
    {
        "text",
        "notes",
        "checklist" : (
            [
                .checklist |
                if any
                then
                    map(select(.completed == false))[] |
                    .text
                else
                    empty
                end
            ]
        ),
        "value"
    }];

def dailies:
    [.tasks.dailys |
    map(select(.isDue == true and .completed == false)) |
    unique |
    sort_by(.value)[] |
    {
        "text",
        "notes",
        "checklist" : (
            [
                .checklist |
                if any
                then
                    map(select(.completed == false))[] |
                    .text
                else
                    empty
                end
            ]),
        "value"
    }];

def habits:
    [.tasks.habits |
    sort_by(.value) |
    map(select(.up == true or .down == true))[] |
    {
        "text",
        "notes",
        "value"
    }];

{
    "todos" : (todos),
    "dailies" : (dailies),
    "habits" : (habits)
}

