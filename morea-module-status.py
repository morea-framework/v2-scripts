#!/usr/bin/python
from time import sleep

import curses
import curses.panel
import glob
import os
import subprocess
import re

# Helper function to print markers
def marker(value):
  if (value == 0):
    return "-"
  else:
    return "X"

# Helper function to convert a boolean string to a boolean
def s2bool(string):
  return string in ("True","true")

# Helper function to get a property in a morea file
# Returns a string (e.g., "1", "true")
#
def get_property(filepath,name):

  value = None
  for l in open(filepath,'r'): 
    m = re.match(" *"+name+" *: *(?P<value>.*)",l)
    if (m == None):
      continue
    if (value != None):
      print "File '"+filepath+"' contains two lines for property "+name+". Go fix it!"
      exit(1)
    value = m.groups()[0]

  return value


# Helper function to set a property in a morea file
#
def set_property(filepath, name, string_value):

  tmp_filepath = "./tmp_sed_file.txt"
  output = open(tmp_filepath,'w')

  for l in open(filepath,'r'):
    m = re.match(" *"+name+" *: *(?P<value>.*)",l)
    if (m == None):
      output.write(l)
    else:
      output.write(name+": "+string_value+"\n")
  output.close()

  os.rename(tmp_filepath,filepath)

  return


# Helper function to find all md files with specified types
# Returns [] if no file found
#
def find_md_files(directory, type_list):
  module_file_path = None
  files = []
  # List all .md files
  md_file_list = glob.glob(directory+"/*.md")
  for f in md_file_list:  
    value = get_property(f,"morea_type")
    if (value in type_list):
        files.append(f)
  return files


# Helper function to find all information for a module file
def find_module_info(file_path):
      sort_order = int(get_property(file_path,"morea_sort_order"))
      published = s2bool(get_property(file_path, "published"))
      comingsoon = s2bool(get_property(file_path, "morea_coming_soon"))
      highlight = s2bool(get_property(file_path, "morea_highlight"))
      return [sort_order, published, comingsoon, highlight]

# Helper function to find all content for a module
def find_module_contents(directory):
  md_files = find_md_files(directory, ["outcome","reading","experience","assessment"])
  list_of_contents = []
  for f in md_files:
    content = [get_property(f,"title"),get_property(f,"morea_type")]
    list_of_contents.append(content)
  return list_of_contents

# Helprt function that pops up a module content panel
def module_content_popup(contents):
  contents
  tmpwin = curses.newwin(len(contents)+4,70, 6,4)
  tmpwin.erase()
  tmpwin.box()
  tmppanel = curses.panel.new_panel(tmpwin)
  curses.curs_set(False)
  
  tmpwin.addstr(1, 1,  sorted_modules[cur_y - min_y]+"'s content:")
  tmpwin.addstr(1, 56,  "Enter: close",curses.A_REVERSE)
  
  x = 2
  y = 3
  for content in contents:
    tmpwin.addstr(y, x,  content[1])
    tmpwin.addstr(y, x+15,  content[0])
    y += 1
  
  curses.panel.update_panels(); 
  stdscr.refresh()
  while (stdscr.getch() != ord('\n')):
    pass 
  tmppanel.hide()
  curses.curs_set(True)
  return


  

#########################################################################################
#########################################################################################

# Check that the root directory is there
root = "./master/src/morea"
if (not os.path.isdir(root)):
  print "Can't find master/src/morea in the working directory... aborting"
  exit(1)

# Get all module information and put it in a dictionary of 
# dictionaries {module file, sortorder, published, comingsoon} tuples
module_info = {}   
module_contents = {}   
for path, subdirs, files in os.walk(root):
  for module in subdirs:
    if path == root:

      module_files = find_md_files(root+"/"+module,["module"])
      if (len(module_files) == 0):
        continue
      elif (len(module_files) > 1):
        print "Module "+module+" contains more than on .md file with morea type 'module'!  aborting...."
        exit(1)
 
      [sort_order, published, comingsoon, highlight] = find_module_info(module_files[0])

      # add directory entry (which is itself a directory)
      module_info[module] = {'file':module_files[0], 'sort_order':sort_order, 'published':published, 'comingsoon':comingsoon, 'highlight':highlight}

      module_contents[module] = find_module_contents(root+"/"+module)

if (len(module_info) == 0):
  print "No module found... aborting"
  exit(1)


# Build an array of the sorted module names
sorted_modules = [a for (a,b) in sorted(module_info.items(), key=lambda x: x[1]['sort_order'])]

# Compute the maximum name length for displaying purposes
max_name_length = reduce(lambda a,b: a if (a > b) else b, map(len,sorted_modules))

#exit(1)

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
stdscr.addstr(1, 0, "Space: toggle   Enter: info   q: save and quit     x: quit", curses.A_REVERSE)
stdscr.addstr(3, published_column-4,  "PUBLISHED")
stdscr.addstr(3, comingsoon_column-4, "COMINGSOON")
stdscr.addstr(3, highlight_column-4,  "HIGHLIGHT")
stdscr.refresh()

# Define cursor bounds
min_y = 4
max_y = min_y + len(sorted_modules)-1

# Print modules
y = min_y
for module in sorted_modules:
  stdscr.addstr(y, 0, module)
  stdscr.addstr(y, published_column,  marker(module_info[module]['published']))
  stdscr.addstr(y, comingsoon_column, marker(module_info[module]['comingsoon']))
  stdscr.addstr(y, highlight_column,  marker(module_info[module]['highlight']))
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
  elif (c == curses.KEY_LEFT) or (c == ord('h')):
    cur_x = sorted(columns.keys())[max(0, sorted(columns.keys()).index(cur_x)-1)]
  elif (c == curses.KEY_RIGHT) or (c == ord('l')):
    cur_x = sorted(columns.keys())[min(len(columns)-1, sorted(columns.keys()).index(cur_x)+1)]

  # Go to module panel
  elif (c == ord('\n')):
    module_content_popup(module_contents[sorted_modules[cur_y - min_y]])

  # Toggle
  elif c == ord(' '):
    column_type = columns[cur_x]
    module_info[sorted_modules[cur_y - min_y]][column_type] = 1 - module_info[sorted_modules[cur_y - min_y]][column_type]
    stdscr.addstr(cur_y, cur_x, marker(module_info[sorted_modules[cur_y - min_y]][column_type]))

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
  for module in sorted_modules:
    set_property(module_info[module]['file'], "published",         str(module_info[module]['published'] == 1).lower())
    set_property(module_info[module]['file'], "morea_coming_soon", str(module_info[module]['comingsoon'] == 1).lower())
    set_property(module_info[module]['file'], "morea_highlight",   str(module_info[module]['highlight'] == 1).lower())



