from pymongo import MongoClient
from dotenv import load_dotenv
from faker import Faker
from random import randint
import os

load_dotenv()
fake = Faker()
uri = os.getenv("MONGO_URI")

client = MongoClient(uri)
db = client["test_db"]  # Make sure you're using test_db as in Atlas
collection = db["students"]

def insert_students(n=200):
    cities = ['Ahmedabad', 'Surat', 'Rajkot', 'Vadodara', 'Gandhinagar']
    grades = ['A', 'B', 'C']
    data = []
    for _ in range(n):
        data.append({
            'name': fake.first_name(),
            'age': randint(18, 30),
            'grade': grades[randint(0, 2)],
            'city': cities[randint(0, 4)]
        })
    collection.insert_many(data)
    print(f" Inserted {n} records.")

def insert_test_baroda_students():
    data = []
    for _ in range(5):
        data.append({
            'name': fake.first_name(),
            'age': randint(18, 30),
            'grade': 'C',
            'city': 'Baroda'
        })
    collection.insert_many(data)
    print(" Inserted 5 test students with city 'Baroda'.")

def update_students():
    result = collection.update_many({'city': 'Baroda'}, {'$set': {'city': 'Vadodara'}})
    print(f" Updated {result.modified_count} records where city was 'Baroda'.")

def create_index():
    print("\nBefore Indexing:")
    before = collection.find({'city': 'Vadodara', 'name': 'Arya'}).explain()['executionStats']['executionTimeMillis']
    collection.create_index([('name', 1), ('city', 1), ('age', -1)])
    print(" Compound Index created on name, city, age.")
    print(" After Indexing:")
    after = collection.find({'city': 'Vadodara', 'name': 'Arya'}).explain()['executionStats']['executionTimeMillis']
    print(f" Query time reduced from {before}ms ➝ {after}ms")

def find_duplicates(field='name'):
    pipeline = [
        {"$group": {"_id": f"${field}", "count": {"$sum": 1}}},
        {"$match": {"count": {"$gt": 1}}},
        {"$project": {"_id": 1, "count": 1}}
    ]
    results = collection.aggregate(pipeline)
    print(f"\n Duplicates in '{field}':")
    for r in results:
        print(f"{r['_id']} → {r['count']} times")

def main():
    while True:
        print("\n MongoDB Student Batch Tasks")
        print("1. Insert 200 students")
        print("2. Batch Update city")
        print("3. Create Compound Index (name, city, age)")
        print("4. Find Duplicates")
        print("5. Exit")
        print("6. Insert 5 test students with city = 'Baroda'")

        choice = input("Pick a task (1-6): ").strip()

        if choice == '1':
            insert_students()
        elif choice == '2':
            update_students()
        elif choice == '3':
            create_index()
        elif choice == '4':
            field = input("Enter field to check duplicates (e.g. name): ")
            find_duplicates(field)
        elif choice == '5':
            print(" Exiting. All done!")
            break
        elif choice == '6':
            insert_test_baroda_students()
        else:
            print(" Invalid choice. Try again.")

if __name__ == "__main__":
    main()
