#!/usr/bin/env python3
# =============================================================
#
#   █████████   █████████
#  ███░░░░░███ ███░░░░░███  Suchith Sridhar
# ░███    ░░░ ░███    ░░░
# ░░█████████ ░░█████████   https://suchicodes.com
#  ░░░░░░░░███ ░░░░░░░░███  https://github.com/suchithsridhar
#  ███    ░███ ███    ░███
# ░░█████████ ░░█████████
#  ░░░░░░░░░   ░░░░░░░░░
#
# =============================================================
# A script to generate tick tick tasks.
# I use this to generate tasks for my assignments.
# =============================================================

import pyperclip


# Note, ensure you are under right tag
# tag cannot be added automatically
time = input("time(ex: 5pm): ")
priority = input("priority(ex: high): ")
start = int(input("start int(ex: 1): "))
type = input("type (ex: Lab): ")
couse = input("course (ex: cs22): ")
dates = input("dates comma separated (ex: Feb 3rd,feb 25th):").split(",")
string = "{} {} {} {} {} !{}"

for index, item in enumerate(dates):
    print_string = string.format(
        type,
        start + index,
        couse,
        time,
        item,
        priority
    )
    print(print_string)
    pyperclip.copy(print_string)
    input("Next?")
