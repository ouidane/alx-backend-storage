#!/usr/bin/env python3
""" Module to return all students sorted by average score """

def top_students(mongo_collection):
    """Returns all students sorted by average score.
    """
    return list(mongo_collection.aggregate([
        {
            "$addFields": {
                "averageScore": { "$avg": "$topics.score" }
            }
        },
        {
            "$sort": { "averageScore": -1 }
        }
    ]))
