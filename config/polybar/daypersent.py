#!/usr/bin/python

from datetime import datetime, time

utcnow = datetime.now()
midnight = datetime.combine(utcnow.date(), time(0))
delta = utcnow - midnight

print ("{:2.02%}".format(delta.seconds / (24 * 60 * 60)))
