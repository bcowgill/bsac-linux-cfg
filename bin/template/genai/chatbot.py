# Create a chat bot with langchain and open ai

# Install

# python3 -m pip install openai


# Data Load
# Using Stanford Question Answering Dataset SQuAD 2.0
# rajpurkar.github.io/SQuAD-explorer/

from datasets import load_dataset

data = load_dataset('squad', split="train") # training data
# id, title, context, question, answer
df = data.to_pandas()
df.columns
df.iloc[0]['context'] # the textual context for the question an answer
df.iloc[0]['question'] # the text of the question to answer
df.iloc[0]['answers'] # text an array of strings; answer_start array of integer32 positions within the content;

import pandas as pd
df=pd.DataFrame(data)
sum(df['context'].duplicated()) # shows duplicat contexts with multiple question/answers
df.drop_duplicates(
        subset='context',
        keep_first=True,
        inplace=True
)
df.shape

# Embedding API

# OpenAI

OPENAI_API_KEY=""

import openai
openai.api_key = OPENAI_API_KEY
# platform.openai.com Openai Embedding model 3000 pages per dollar
MODEL="text-embedding-ada-002"
DIM=1536 # vector dimension

res = openai.Embedding.create(input="I love openAI", engine=MODEL)

emb_vector = res['data'][0]['embedding'] # list of vectors for the text

def get_embedding(text, model):
    text = text.replace("\n", " ")
    res = openai.Embedding.create(input=text, engine=model)
    return res['data'][0]['embedding']

vec = get_embedding("I am trying a new text \n And see what happens", MODEL)
len(vec) # must match DIM!!


# Vector DB Setup 1536 dimensions

import pinecone

# Pinecone
PC_API_KEY=""
PC_ENV=""
INDEX="ai-agent"

pinecone.init(api_key=-PC_API_KEY, environment=PC_ENV)

# Create index
pinecone.create_index(INDEX, dimension=DIM, metric="dotproduct")

index = pinecone.index(INDEX)

index.delete(delete_all=True)

# Indexing

import time
from tqdm.auto import tqdm  # to show progress bar in jupyter notebook

ROWS=100
batch_size=10
df_sample = df.sample(ROWS, random_state=45)

# Metadata creation

%%time
# in jupyter notebook %%time will show the time taken for running the cell
for i in tqdm(range(0, len(df_sample), batch_size)):
    i_end = min(i+batch_size, len(df_sample))
    print(i, i_end)
    batch = df_sample.iloc[i:i_end]
    # id,title,context,question,answers
    # dataframe to dictionary
    #for i, row in batch.iterrows():
    #    print({"title": row['title'], "context": row['context']})
    # or as a list comprehension
    meta_data = [ {"title": row['title'],
                   "context": row['context']}
                   for i, row in batch.iterrows() ]

    # Embedding vectors calculations with openai api calls
    docs = batch['context'].tolist()  # panda series to python list
    emb_vectors = [get_embedding(doc, MODEL) for doc in docs]
    # above line can get openAI rate limit errors so you may need a function to do this with slower requests.
    time.sleep(60) # slow down the rate limit...

    # upsert the data
    ids = batch['id'].tolist()
    to_upsert = zip(ids, emb_vectors, meta_data)
    index.upsert(vectors=to_upsert)




# Using

