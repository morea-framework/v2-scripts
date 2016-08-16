#!/usr/bin/python

import getopt
import sys
from MoreaClass import MoreaClass
from datetime import datetime, timedelta


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        opts, args = getopt.getopt(argv[1:], "h", ["help"])
        print opts, args
        for o, a in opts:
            if o in ("-h", "--help"):
                print >>sys.stdout, "Usage: python UpdateMoreaDates.py <directory> <num days | new-first-day>"
                print >>sys.stdout, "Or     python UpdateMoreaDates.py <directory> <old-first-day> <new-first-day>"
                return 0

        if len(args) > 3 or len(args) < 2:
            print >>sys.stderr, "Usage: python UpdateMoreaDates.py <directory> <num days>"
            print >>sys.stderr, "Or:    python UpdateMoreaDates.py <directory> <old-first-day> <new-first-day>"
            return 2
        morea = MoreaClass(args[0])
        if len(args) == 2:
            try:
                d = datetime.strptime(args[1], '%Y-%m-%d')
                delta = d - morea.getFirstClassDate()
            except ValueError, err:
                delta = timedelta(days=int(args[1]))
        elif len(args) == 3:
            oldFDoI = datetime.strptime(args[1], '%Y-%m-%d')
            newFDoI = datetime.strptime(args[2], '%Y-%m-%d')
            delta = newFDoI - oldFDoI
        print >>sys.stdout, 'Old start date {0}'.format(morea.getFirstClassDate())
        print >>sys.stdout, "updating dates..."
        morea.updateDates(delta)
        print >>sys.stdout, 'New start date {0}'.format(morea.getFirstClassDate())
        return 0

    except getopt.error, msg:
        print >>sys.stderr, msg
        print >>sys.stderr, "for help use --help"
        return 2

if __name__ == "__main__":
    sys.exit(main())
