# Habitica backup

This is intended to be run once a day. It backs up the habitica userdata and creates
a json file with the habits, dailies, and todos trimmed to only show the relevant
info.

This is saved in a json file which you can then examine with jq to get some tasks

For example, the 3 dailies with the lowest value:
`jq '.dailies[0:3]' $(ls -1 2*.json | tail -1)`
