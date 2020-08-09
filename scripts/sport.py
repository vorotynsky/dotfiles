#!/bin/python3

# The script shows a message box with an offer to a random exercise.

# List of exercises has to be in ~/.config/exercises (EXERCISES_FILE)
# and contains data in the format: `count name`
# 10 squats
# 10 push ups
# Each action is written to a ~/.activity (HISTFILE)


import os
import sys
import random
from PyQt5.QtWidgets import QApplication, QWidget, QMessageBox
from datetime import datetime

EXERCISES_FILE=os.path.expanduser("~/.config/exercises")
HISTFILE=os.path.expanduser("~/.activity")

exercises = dict({})

if (not os.path.isfile(EXERCISES_FILE)):
    print ("Exercises file not found at {}".format(EXERCISES_FILE), file=sys.stderr)
    print ("Exercises file created, fill this file, please.")
    with open(EXERCISES_FILE, "w") as file:
       print("---delete this line---", file=file)
       print("count exercise name, example:", file=file)
       print("5 squats", file=file)
    sys.exit("fill exercises list.")

with open(EXERCISES_FILE, "r") as file:
    for ex in file:
        splited = ex.split(' ')
        name = " ".join(splited[1:])[0:-1]
        exercises[name] = int(splited[0])

exlist = list(exercises.items())

app = QApplication([])
widget = QWidget()

(exercise, count) = (None, 0)
reroll = True
while reroll == True:
    (exercise, count) = random.choice(exlist)
    
    done = QMessageBox.question(widget, "Exercises", "Did u do {} {}".format(count, exercise), QMessageBox.Yes | QMessageBox.No)
    if done != QMessageBox.Yes:
        reroll = QMessageBox.question(widget, "Reroll", "Change exercise", QMessageBox.Yes | QMessageBox.No) == QMessageBox.Yes
        if reroll != True:
            QMessageBox.question(widget, "Oh.. buddy", "I'm disappointed in you", QMessageBox.Close)
            count = 0
    else:
        reroll = False

with open(HISTFILE, "a") as file:
    print(datetime.now(), count, exercise, sep=',', end='\n', file=file)
