

import sys
import getopt
from datetime import datetime
from os import walk, close, remove
from os.path import join
from shutil import move
from tempfile import mkstemp


class MoreaClass:
    """Represents a Morea class. Has some helpful methods to manipulate the markdown files."""

    def __init__(self, moreaDirectory):
        """Constructor"""
        self.directory = moreaDirectory


    def getFirstClassDate(self):
        """Searches the Morea markdown files to determine the first day of instruction."""
        startDate = None
        for dirpath, dirnames, filenames in walk(self.directory):
            for name in filenames:
                if name.endswith('.md'):
                    start = self.__getStartDate(join(dirpath, name))
                    if startDate == None and start != None:
                        startDate = start
                    elif start != None and start < startDate:
                        startDate = start
        return startDate

    def updateDates(self, delta):
        """Updates all the morea_start_date and morea_end_date lines by adding the delta time to them. delta should be a timedelta."""
        for dirPath, dirNames, fileNames in walk(self.directory):
            for name in fileNames:
                if name.endswith('.md'):
                    self.__processFile(join(dirPath, name), delta)

    def __getStartDate(self, file_path):
        """Returns the morea_start_date from the given Morea markdown file."""
        with open(file_path) as morea_file:
            for line in morea_file:
                if line.startswith('morea_start_date'):
                    return self.__getDate(line)
        return None

    def __getDate(self, line):
        """Returns the date from the morea_start_date or morea_end_date line."""
        index = line.find('"') + 1
        end = len(line) - 2
        datestr = line[index:end]
        try:
            d = datetime.strptime(datestr, '%Y-%m-%d')
        except ValueError:
            d = datetime.strptime(datestr, '%Y-%m-%dT%H:%M:%S')
        return d

    def __processFile(self, filePath, delta):
        """Processes the given Morea markdown file, updating the morea_start_date and morea_end_date values."""
        # Create the temp file
        fh, abs_path = mkstemp()
        with open(abs_path,'w') as new_file:
            with open(filePath) as old_file:
                for line in old_file:
                    if line.startswith('morea_start_date') or line.startswith('morea_end_date'):
                        try:
                            new_file.write(self.__processDateLine(line, delta))
                        except ValueError:
                            print filePath, 'has an error '
                            new_file.write(line)
                    else:
                        new_file.write(line)
        close(fh)
        #Remove original file
        remove(filePath)
        #Move new file
        move(abs_path, filePath)

    def __processDateLine(self, line, delta):
        """Parses the morea_start_date or morea_end_date line to create a datetime then updates the time by delta.
        Returns the updated line."""
        index = line.find('"') + 1
        d = self.__getDate(line)
        newDate = d + delta
        return '{0}{1}"\n'.format(line[:index],newDate.strftime('%Y-%m-%dT%H:%M:%S'))


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        opts, args = getopt.getopt(argv[1:], "h", ["help"])
        if len(args) != 1 :
            print >>sys.stderr, "Usage: python MoreaClass <morea directory>"
            return 2
        morea = MoreaClass(args[0])
        print >>sys.stdout, morea.getFirstClassDate()

    except getopt.error, msg:
        print >>sys.stderr, msg
        print >>sys.stderr, "for help use --help"
        return 2

if __name__ == "__main__":
    sys.exit(main())
