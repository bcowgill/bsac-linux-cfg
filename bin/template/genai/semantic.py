# a Title and Subtitle Semantic search on CSV data file from Medium Blog site
import pandas as pd

# CSV file from 'Medium' Blogging Site Post titles
# kaggle.com/datasets/nulldata/medium-post-titles
#https://www.kaggle.com/datasets/nulldata/medium-post-titles/download?datasetVersionNumber=1
# get data frame from CSV file
df = pd.read_csv("medium_post_titles.csv", nrows=10000) # limit the number of rows for safety
df.head()
#category,title,subtitle,subtitle truncated flag
#work,"21 Conversations - fun (and easy) game for parties.","A (new?) Icebreaker game to get your team to share...",True
# subtitle can be NaN when absent
df["subtitle_truncated_flag"].value_count()

# data cleanup
df.isna().sum()  # rows with NaN in them
df = df.dropna() # delete rows with NaN in them
df = df[~df["subtitle_truncated_flag"]]  # filter out all rows where subtitles are truncated
df.shape # gives number of rows and columns

# combine title and subtitle together into a field
df['title_extended'] = df['title'] + df['subtitle']
df['title_extended'][0]
# remove emoji, clean punctuation etc...

df.head()
df['category'].nunique()  # how many unique categories are there? will use it as metadata

# Prepare for upsert to pinecone

import pinecone
from tqdm.autonotebook import tqdm
pine.init(api_key=API_KEY, environment=ENV)

# hugging face documentation.
# https://huggingface.co/sentence-transformers/all-MiniLM-L12-v2

pinecone.create_index(
        name='medium-data',
        dimension=384, # as specified by Hugging Face Sentence Transformer we used.
        pod_type='s1',
        metric='cosine'
)

from sentence_transformers import SentenceTransformer
import torch
model = SentenceTransformer('all-MiniLM-L6-v2', device='cpu')
df.head(2)
df['values'] = df['title_extended'].map(
    lambda x: (model.encode(x)).tolist()
)

df['id'] = df.reset_index(drop = 'index').index
df['metadata'] = df.apply(
        lambda x: {
            'title': x['title'],
            'subtitle': x['subtitle'],
            'category': x['category'],
        }, axis=1
)

df_upsert = df[['id', 'values', 'metadata']]
df_upsert['id'] = df_upsert['id'].map(lambda x: str(x))
index = pinecone.Index('medium-data')
index.upsert_from_dataframe(df_upsert)

# Now Query the uploaded data...

# encode query as a vector and convert to python list
xc = index.query((model.encode("where is my cat?")).tolist(),
            include_metadata=True,
            include_values=False,
            top_k=10
)

for result in xc['matches']:
    print(f"{round(result['score'], 2)}: {result['metadata']['category']}: {result['metadata']['title']}")


for result in xc['matches']:
    print(f"{round(result['score'], 2)}: {result['metadata']['subtitle']}")

for result in xc['matches']:
    print(f"{round(result['score'], 2)}: {result['metadata']['category']}: {{result['metadata']['category']}")




