# Semantic Search example with Named Entity Recognition
# init pinecone

import pinecone

API_KEY=""
ENV=""
pimecone.init(api_key=API_KEY, environment=ENV)
index=pinecone.Index("medium-data")

# clean up the pinecone index

# because of trial limit of only one index...
# delete data from index
index.delete(delete_all=True)

# delete index, dimension no longer useful

# load libraries for NER
from transformers import AutoTokenizer, AutoModelForTokenClassification
from transformers import pipeline
import torch

# init NER engine

model_id="dslim/bert-base-NER"

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForTokenClassification.from_pretrained(model_id)

# nlp pipeline
nlp = pipeline("ner",
               model=model,
               tokenizer=tokenizer,
               aggregation_strategy="max",
               device="cpu"
)

nlp("Bill Gates is the foundeer of Microsoft")

# load libraries for retriever

from sentence_transformers import SentenceTransformer

model_768="flax-sentence-embettings/all_datasets_v3_mpnet-base"

# huggingface.co/flax-sentence-embettings/all_datasets_v3_mpnet-base
# maps sentences and paragraphs to a 768 dimensional dense vector space for tasks like clustring and semantic search
retriever = SentenceTransformer(model_768)
retriever

# Create pinecone index

pinecone.create_index("medium-data",
                      dimension=768,
                      metric="cosine"
)
index=pinecone.Index("medium-data")

# obtain Raw Data
from datasets import load_dataset
df=load_dataset(
    "fabiochiu/medium-articles",
    data_files="medium_articles.csv",
    split="train"
).to_pandas()


# clean up data
limit=100 # 10000 rows
batch_size=5 #64
body=1000 # characters from document
df=df.dropna().sample(limit, random_state=45)
df.shape()  # 10000, 6 cols
#df=df.iloc[0:10000] # work with first 10000 items only
df.head()
# title,text,url,authors,timestamp,tags
df.isna().sum()

# concateate the 1000 characters of text to the title
df['text_extended'] = df['title'] + "." + df['text'].str[:body]

# Extract Named Entities
nlp(df['text_extended'].iloc[0]) # get entites from first row
df['text_extended'].iloc[0:2] # gets rows 0..2 by index location

# a batch of 10 texts
df_batch = df['text_extended'].iloc[0:10].tolist()

len(nlp(df_batch))

# helper function for extracting entities from a list of text
def extract_entities(list_of_text)
    entities=[]
    for doc in list_of_text:
        entities.append([item['word'] for item in nlp(doc)])
    return entities

# prepare for upsert vector embettings
len(retriever.encode(df_batch[0])) # 768 vector
emb = retriever.encode(df_batch).tolist() # array to python list

# upsert data

range(0,len(df)) # 0..10000
range(0,len(df), 10) # 0,10,20,...10000

#batch_size=64
list(range(0,len(df), batch_size)) # 0,10,20,...10000

from tqdm.auto import tqdm
for i in range(0, len(df), batch_size):
        i_end = min(i+batch_size, len(df))
        # print(i,i_end) # starting and ending index of each batch
        # get a batch of data
        df_batch = df.iloc[i:i_end]
        # embedding the vector
        emb = retriever.encode(df_batch['text_extended'].tolist()).tolist() # array to python list
        # ner extraction
        entities = extract_entities(df_batch['text_extended'].tolist())
        # [[]] ==> [set1,set2...] convert list of list to list of sets removing duplicate entity names
        df_batch['named_entity'] = [list(set(entity)) for entity in entities] # one list per document
        # create metadata dropping the text as it is too long
        df_batch = df_batch.drop('text', axis=1)]
        #df_batch.head(2).to_dict(orient='records') # show rows as a dictionary
        meta_data=df_batch.to_dict(orient='records')

        # create id's for each document
        ids=[f"{idx}" for idx in range(i,i_end)]

        # upsert, zipping the ids with the data
        vectors_to_upsert = list(zip(ids, emb, meta))
        _ = index.upsert(vectors=vectors_to_upsert)

# trick to remove duplicates from a list
list(set([1,1,3,4]))  => [1,3,4]

# look at last one
df_batchf.iloc[-1]
df.iloc[-1] # check it's same as the one above

# query the data

# Same process as upserting, vector embed, NER processing

query="How to make a Wordpress website?  " # Natural language query

emb_qx = retriever.encode(query).tolist() # query vector for pinecone to python list

ne = extract_entities([query])[0] # named entities as search filter

xc = index.query(
    emb_qx,
    top_k=5,
    include_metadata=True,
    filter={
        'named_entity': {"$in": ne }
    }
)

for result in xc['matches']:
    print(result['score'], " ", result['metadata']['named_entity'])


