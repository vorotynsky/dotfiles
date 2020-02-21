#!/usr/bin/python3

import datetime as dt

now = dt.datetime.now()
exam = dt.datetime(2020, 5, 25)

delta = exam - now

print("{} days ({} w) before exams".format(delta.days, delta.days // 7))

