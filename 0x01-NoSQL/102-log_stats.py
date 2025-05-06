#!/usr/bin/env python3
"""Provides statistics about Nginx logs stored in MongoDB.
"""
from pymongo import MongoClient
from collections import Counter


def display_nginx_stats(collection):
    """Displays stats for Nginx logs."""
    total_logs = collection.count_documents({})
    print(f"{total_logs} logs")

    print("Methods:")
    for method in ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']:
        count = collection.count_documents({'method': method})
        print(f"\tmethod {method}: {count}")

    status_check_count = collection.count_documents({
        'method': 'GET',
        'path': '/status'
    })
    print(f"{status_check_count} status check")

    # Extract and count the top 10 IP addresses
    ip_addresses = collection.distinct('ip')  # Get all distinct IPs
    ip_counts = Counter(
        entry['ip'] for entry in collection.find({'ip': {'$in': ip_addresses}})
    )
    
    print("IPs:")
    # Sorting by count in descending order and printing the top 10
    for ip, count in ip_counts.most_common(10):
        print(f"\t{ip}: {count}")


def main():
    """Connects to MongoDB and displays Nginx stats."""
    client = MongoClient("mongodb://127.0.0.1:27017")
    db = client.logs
    display_nginx_stats(db.nginx)


if __name__ == "__main__":
    main()
