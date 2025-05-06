#!/usr/bin/env python3
""" Find all schools with a specific topic in a MongoDB collection """

def schools_by_topic(mongo_collection, topic):
    """Returns the list of school documents that include the specified topic
    """
    return list(mongo_collection.find({ "topics": topic }))
