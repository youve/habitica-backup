#!/usr/bin/jq -f

def todos:
    [.tasks.todos |
    # Most recent at the top
    reverse |
    # Hide completed tasks
    map(select(.completed == false))[] |
    {
        "text",
        "notes",
        "checklist" : (
            [
                .checklist |
                if any
                # if there's a checklist then select the non-completed ones
                then
                    map(select(.completed == false))[] |
                    .text
                else
                # otherwise this field should be empty.
                # Without this part, it would filter out tasks without checklists
                    empty
                end
            ]
        ),
        "value"
    }];

def dailies:
    [.tasks.dailys |
    # select the ones that are due today and not yet complete
    map(select(.isDue == true and .completed == false)) |
    unique |
    # the ones i've been struggling to do should come first
    sort_by(.value)[] |
    {
        "text",
        "notes",
        "checklist" : (
            [
                .checklist |
                # select the non-completed items from the checklist, or empty if 
                # there is no checklist - this allows tasks without checklists to be
                # selected as well.
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
    # the ones i don't do much should come first
    sort_by(.value) |
    map(select(.up == true or .down == true))[] |
    {
        "text",
        "notes",
        "value"
    }];

# create a json file based on the output, which can then be queried like .dailies[0] or whatever.
{
    "todos" : (todos),
    "dailies" : (dailies),
    "habits" : (habits)
}

