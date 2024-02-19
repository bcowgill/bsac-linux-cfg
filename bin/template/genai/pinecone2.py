import pinecone
from tqdm.autonotebook import tqdm

API_KEY="..."
ENV="..."

pinecone.init(api_key=API_KEY, environment=ENV)
pinecone.list_indexes()
idx=pinecone.Index('insert')
idx.upsert(vectors=[
    ("A", [0.1,0.1,0.1]),
    ("B", [0.2,0.2,0.2]),
    ("C", [0.3,0.3,0.3]),
    ("D", [0.4,0.4,0.4]),
    ("E", [0.5,0.5,0.5]),
])

idx.upsert(vectors=[
    ("E", [0.55,0.55,0.55]),
    ]
)


idx.update(
    id="E",
    values=
    [0.55,0.55,0.55]
)
