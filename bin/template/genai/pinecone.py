import pinecone

# get these from your pinecone accoutn details
pinecone.init(
    api_key="nnnnnnn",
    environment="asia-southeast1-gcp"
)

pinecone.create_index(name="insert", dimension=3)

pinecone.list_indexes()
vectors= [[1,2,3],[5,6,7],[8,9,0]]
vect_ids = ['vect1','vect2','vect3']
idx = pinecone.Index('insert')
idx.upsert([ # list of vectors
    (vect_id[0], vectors[0])  # tuple with id, vector
    (vect_id[1], vectors[1])
    (vect_id[2], vectors[2])
])

idx.query([0,0,0], top_k=2, include_values=True)
# object returned with keys
# matches: list of [id,score,values] will be returned
# namespace: string

idx.fetch(ids=['vect1'])
# object returned with keys
# namespace: string
# vectors: { 'vect1': {
#             id: 'vect1',
#             values: [1,2,3],
#             sparse_values:{indices:[n,n,n] values:[n,n,n]}} }

# delete vectors

idx.delete(ids=['vect3']) # no error message if id is not in database
idx.delete(delete_all=True)

"""

# Index is a named collection of vectors which you can query
# Collection is a static copy of an index -- cannot query on it though
# useful to backup an Index or move the collection to a new Index
pinecone.create_index("name", dimension=N, metric="dotproduct/cosine/euclidean", pod_type="s1")
# pod_type S1 best storage capacity
#   P1 faster queries
#   P2 lowest latency and highest throughput
pinecone.list_indexes()
description=pinecone.describe_index("name")
    description.status['state']
    description.dimension
    description.pod_type.split(".")[0]

idx=pinecone.Index("name")
idx.upsert(vectors=[])
idx.query()
idx.fetch()
idx.delete(ids=[],delete_all=False/True)
idx.update(id="",values=[])
pinecone.delete_index("name")

"""

# Create a collection

pinecone.create_collection(name="name_of_new_collection", source="insert")
pinecone.list_collections()
response=pinecone.describe_collection("name")
    response.dimension
    response.vector_count
    response.status
    response.name
    response.size
pinecone.delete_collection("name")


# Namespaces like subject, body, other for an email
# so you can search different parats of a document
# otherwise you would need 3 different indexes for each section. can also add metadata to partition

dimensions=3
emails_with_subject=20
emails_with_body=45
emails_with_other=45

# Make random vectors so we have data to work with

import numpy as np
#np.random.rand(5,3) #
# 5 random vectors of 3 dimensions

vects_subj=np.random.rand(emails_with_subject,dimensions).tolist() #
vects_body=np.random.rand(emails_with_body,dimensions).tolist() #
vects_other=np.random.rand(emails_with_other,dimensions).tolist() #

# create id's for each vector
#np.arange(5) => [0,1,2,3,4]

# need to convert random numbers to string for pinecone.
ids_subj=map(str, np.arange(emails_with_subject).tolist())
ids_body=map(str, np.arange(emails_with_body).tolist())
ids_other=map(str, np.arange(emails_with_other).tolist())

# zip the id's together with the vectors

vectors_subj=list(zip(ids_subj, vects_subj)) # list of tuples (id,vector)
vectors_body=list(zip(ids_body, vects_body))
vectors_other=list(zip(ids_other, vects_other))

# put the namespaced vectors in the database
idx.upsert(
    vectors_subj,
    namespace="subject",
)
idx.upsert(
    vectors_body,
    namespace="body",
)
idx.upsert(
    vectors_other,  # default namespace "" for other data
)

#========================
# Using metadata

idx.upsert([
    ("1", [0.1,0.1,0.1], {"topic": "subject", "year": 2020 }),
    ("2", [0.2,0.2,0.2], {"topic": "other", "year": 2019 }),
    ("3", [0.3,0.3,0.3], {"topic": "body", "year": 2019 }),
    ("4", [0.4,0.4,0.4], {"topic": "body" }),
    ("5", [0.5,0.5,0.5], {"topic": "subject" }),
])

idx.query(
    vector = [0,0,0],
    top_k=2,
    include_metadata=True,
    include_values=True,
    filter={
        "topic": {"$eq": "subject"},
        "year": 2019,
    }
)

idx.fetch(ids=['1'])
idx.update(
        id='1',
        values=[0.1,0.1,0.1],
        set_metadata={"topic":"other", "year": 2022}
)


idx.delete(
    filter={
        "topic": {"$eq": "other"},
    }
)
