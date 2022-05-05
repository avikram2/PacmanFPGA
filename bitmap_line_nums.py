#!/usr/bin/python

total = 0
with open('bitmap.txt', 'r') as orig:
    lines = orig.readlines()

with open('bitmap.txt', 'w') as orig:
    for line in lines:
        print(str(total) + " : " + line, file = orig)
        total = total + 1

   