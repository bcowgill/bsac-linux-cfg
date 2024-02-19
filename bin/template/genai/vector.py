import sqlite3
import numpy as np

### Setting up vector database
conn=sqlite3.connect('vector-db.db')
cursor=conn.cursor()
cursor.execute(
"""
CREATE TABLE IF NOT EXISTS vectors (
    id INTEGER PRIMAR?Y KEY,
    vector BLOB NOT NULL
)
"""
)
# generate some vectors
vect1 = np.array[1.2,3.4,2.1,0.8]
vect2 = np.array[2.7,1.5,3.9,2.3]

# store vectors into database
cursor.execute~(
"INSERT INTO vectors (vector) VALUES (?)",
(sqlite3.Binary(vect1.tobytes()),)
)

cursor.execute~(
"INSERT INTO vectors (vector) VALUES (?)",
(sqlite3.Binary(vect2.tobytes()),)
)

# grab vectors from database
cursor.execute("SELECT vector FROM vectors")
rows = cursor.fetchall()
vector1 = np.frombuffer(rows[0][0], dtype=np.float64)
vector2 = np.frombuffer(rows[1][0], dtype=np.float64)

# convert back into an array of arrays
for row in rows:
    vector = np.frombuffer(row[0], dtype=np.float64)
    vectors.append(vector)

### Vector Similarity Search
query_vect = np.array([1.0,3.2,2.0,0.5])

# Order the result by difference between our query vector and hte one in the database
cursor.execute("""
SELECT vector FROM vectors
ORDER BY abs(vector - ?) ASC
""", (sqlite3.Binary(query_vect.tobytes()),)
)

res = cursor.fetchone() # finding the closest vector
closest_vec = np.frombuffer(res[0], dtype=np.float64)
