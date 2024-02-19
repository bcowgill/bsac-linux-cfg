import chromadb
import pandas as pd

df = pd.read_csv("medium_post_titles.csv")

df = df.dropna()
df = df[~df["subtitle_truncated_flag"]]

topics_of_interest = ['artificial-intelligence', 'data-science', 'machine-learning']

df = df[df['category'].isin(topics_of_interest)]

df['text'] = df['title'] + df['subtitle']

df['meta'] = df.apply( lambda x: {
    'text': x['text'],
    'category': x['category']
}, axis=1)

# Chroma DB Setup

from chromadb.config import Settings
#chroma_client = chromadb.Client()  # in memory database
chroma_client = chromadb.Client(Settings(
    persist_directory="medium-chroma-db",
    chroma_db_impl="duckdb+parquet"
)) # persistent database now

# create a collection
article_collection = chroma_client.create_collection(name="medium-article")
# SentenceTransformerEmbeddingFunction is default
# inserting data with default vector embedding

article_collection.upsert( or # .add or .upsert() to update or insert if ID doesn't exist
    ids=[ f"{x}" for x in df.index.tolist() ],  # convert integers in list to string ids
    documents=df['text'].tolist(),
    metadata=df['meta'].tolist()
)

#article_collection.delete()  to empty the collection if needed

# Vector Query

qry_str = "best data science library?"
article_collection.query(query_texts=qry_str, n_results=1)

