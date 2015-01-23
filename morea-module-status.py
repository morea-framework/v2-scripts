#!/usr/bin/python
import curses
import os
import subprocess

# Helper function
def marker(value):
  if (value == 0):
    return "-"
  else:
    return "X"

# Determine the OS type
system_type = subprocess.check_output("uname").rstrip()

# Check that the root directory is there
root = "./master/src/morea"
if (not os.path.isdir(root)):
  print "Can't find master/src/morea in the working directory... aborting"
  exit(1)

# Get all module information and put it in a dictionary of 
# dictionaries {module file, sortorder, published, comingsoon} tuples
module_data = {}   
for path, subdirs, files in os.walk(root):
  for module in subdirs:
    if path == root:

      module_file = subprocess.check_output("find "+root+"/"+module+" -name \"*.md\" | xargs  grep -H morea_type | grep \" *morea_type *: *module *\" | sed \"s/.*\///\" | sed \"s/:.*//\"", shell=True).rstrip()
      if (module_file == ""):
        continue

      module_sort_order = int(subprocess.check_output("cat "+root+"/"+module+"/"+module_file+" | grep \" *morea_sort_order *:\" | head -1 |  sed \"s/.*://\"", shell=True))

      published = 1 - int(subprocess.check_output("cat "+root+"/"+module+"/"+module_file+" | grep \" *published *:\" | grep false | head -1 | wc -l ", shell=True))

      comingsoon = int(subprocess.check_output("cat "+root+"/"+module+"/"+module_file+" | grep \" *morea_coming_soon *:\" | grep true | head -1 |  wc -l ", shell=True))

      highlight = int(subprocess.check_output("cat "+root+"/"+module+"/"+module_file+" | grep \" *morea_highlight *:\" | grep true | head -1 |  wc -l ", shell=True))

      module_data[module] = {'file':module_file, 'sort_order':module_sort_order, 'published':published, 'comingsoon':comingsoon, 'highlight':highlight}

# Build an array of the sorted module names
sorted_modules = [a for (a,b) in sorted(module_data.items(), key=lambda x: x[1]['sort_order'])]

# Compute the maximum name length for displaying purposes
max_name_length = reduce(lambda a,b: a if (a > b) else b, map(len,sorted_modules))

## CURSES STUFF ###

# initialize the screen
stdscr = curses.initscr()
curses.noecho()
curses.cbreak()
stdscr.keypad(1)
height = 5+len(sorted_modules); width = 50
win = curses.newwin(height, width)

# Define column coordinates (hardocded values to look ok)
published_column  = max_name_length + 8
comingsoon_column = max_name_length + 19
highlight_column  = max_name_length + 31

# dictionary of the column coordinates / meanings
columns = {published_column:"published", comingsoon_column:"comingsoon", highlight_column:"highlight"}

# Print fixed strings
stdscr.addstr(0, 0, "MOREA Module publishing interface",curses.A_REVERSE)
stdscr.addstr(1, 0, "Space: toggle     q: save and quit     x: quit", curses.A_REVERSE)
stdscr.addstr(3, published_column-4, "PUBLISHED")
stdscr.addstr(3, comingsoon_column-4, "COMINGSOON")
stdscr.addstr(3, highlight_column-4, "HIGHLIGHT")
stdscr.refresh()

# Define cursor bounds
min_y = 4
max_y = min_y + len(sorted_modules)-1

# Print modules
y = min_y
for module in sorted_modules:
  stdscr.addstr(y, 0, module)
  stdscr.addstr(y, published_column,  marker(module_data[module]['published']))
  stdscr.addstr(y, comingsoon_column, marker(module_data[module]['comingsoon']))
  stdscr.addstr(y, highlight_column,  marker(module_data[module]['highlight']))
  y += 1

# Define the initial position of the cursor
cur_x = published_column
cur_y = 4

# Handle key presses
while 1:
  stdscr.move(cur_y,cur_x)
  c = stdscr.getch()

  # Cursor move
  if (c == curses.KEY_DOWN) or (c == ord('j')):
    cur_y = min(cur_y+1,max_y)
  elif (c == curses.KEY_UP) or (c == ord('k')):
    cur_y = max(cur_y-1,min_y)
  if (c == curses.KEY_LEFT) or (c == ord('h')):
    cur_x = sorted(columns.keys())[max(0, sorted(columns.keys()).index(cur_x)-1)]
  if (c == curses.KEY_RIGHT) or (c == ord('l')):
    cur_x = sorted(columns.keys())[min(len(columns)-1, sorted(columns.keys()).index(cur_x)+1)]

  # Toggle
  if c == ord(' '):
    column_type = columns[cur_x]
    module_data[sorted_modules[cur_y - min_y]][column_type] = 1 - module_data[sorted_modules[cur_y - min_y]][column_type]
    stdscr.addstr(cur_y, cur_x,marker(module_data[sorted_modules[cur_y - min_y]][column_type]))

  # Quit
  elif c == ord('x'):
    save = False
    break

  # Save and quit
  elif c == ord('q'):
    save = True
    curses.flash()
    break 

# reset terminal properties
curses.nocbreak(); stdscr.keypad(0); curses.echo()
curses.endwin()

if (save):
  # Implement changes (brute-force write of all relevant booleans in */*.md module files)
  if (system_type == "Linux"):
	sed_flag = "-i"
  else:
	sed_flag = "-i \"\""

  for module in sorted_modules:
    if (module_data[module]['published'] == 1):
      subprocess.check_output("sed "+sed_flag+" \"s/ *published *: *false/published: true/\" "+root+"/"+module+"/"+module_data[module]['file'], shell=True);
    else:
      subprocess.check_output("sed "+sed_flag+" \"s/ *published *: *true/published: false/\" "+root+"/"+module+"/"+module_data[module]['file'], shell=True);
  
    if (module_data[module]['comingsoon'] == 1):
      subprocess.check_output("sed "+sed_flag+" \"s/ *morea_coming_soon *: *false/morea_coming_soon: true/\" "+root+"/"+module+"/"+module_data[module]['file'], shell=True);
    else:
      subprocess.check_output("sed "+sed_flag+" \"s/ *morea_coming_soon *: *true/morea_coming_soon: false/\" "+root+"/"+module+"/"+module_data[module]['file'], shell=True);

    if (module_data[module]['highlight'] == 1):
      subprocess.check_output("sed "+sed_flag+" \"s/ *morea_highlight *: *false/morea_highlight: true/\" "+root+"/"+module+"/"+module_data[module]['file'], shell=True);
    else:
      subprocess.check_output("sed "+sed_flag+" \"s/ *morea_highlight *: *true/morea_highlight: false/\" "+root+"/"+module+"/"+module_data[module]['file'], shell=True);

