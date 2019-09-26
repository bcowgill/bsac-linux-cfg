"""Template an example python module this is the documentation"""

import sys

__all__ = ["go", "Place"]

# Modue functions

def go(place = "home"):
    """Documentation for the go function

    The 'place' argument gives the name of the place to go.
    It defaults to "home."
    """
    print "I am going to", place

# Module classes

class Place(object):

    """Documentation for the Place class."""

    def __init__(self, name = "home"):
        self.name = name

    def __str__(self):
        return ("{There's no place like %s}" % self.name)

# Module initialization
