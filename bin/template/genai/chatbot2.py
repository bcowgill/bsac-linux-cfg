# Create a chat bot with langchain and open ai

# Install

# python3 -m pip install openai
# python3 -m pip install langchain --user

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


ROWS=100
batch_size=10
df_sample = df.sample(ROWS, random_state=45)

# embedding function from OpenAI

from langchain.embeddings.openai import OpenAIEmbeddings

model_name = MODEL

embed = OpenAIEmbeddings(
        model=model_name,
        openai_api_key=OPENAI_API_KEY
)
#embed.embed_query(query)
#embed.embed_documents(["first doc", "second doc"])

# Metadata creation

import time
from tqdm.auto import tqdm  # to show progress bar in jupyter notebook

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
    #emb_vectors = [get_embedding(doc, MODEL) for doc in docs]
    emb_vectors = embed.embed_query(docs) # list of lists
    # above line can get openAI rate limit errors so you may need a function to do this with slower requests.
    time.sleep(60) # slow down the rate limit...

    # upsert the data
    ids = batch['id'].tolist()
    to_upsert = zip(ids, emb_vectors, meta_data)
    index.upsert(vectors=to_upsert)

# Using

def get_embedding2(text):
    text = text.replace("\n", " ")
    res = openai.Embedding.create(input=text, engine="text-embedding-ada-002")
    return res['data'][0]['embedding']

# Langchain vectorstore definition

from langchain.vectorstores import Pinecone

index.describe_index_stats()

#vectorstore = Pinecone(index, get_embedding2, "text")
vectorstore = Pinecone(index, embed.embed_query, "text")

query = "When was University of Notre dame established?"

openai.api_key = OPENAI_API_KEY

# pure semantic search, non generative, non ai agent just gives the matching documents, no comprehension
#vectorstore.similarity_search(query, k=3)

# above is all semantic search, now we get into generative below

# Define AI Agent

from langchain.chat_models import ChatOpenAI
from langchain.chains.conversation.memory import ConversationBufferWindowMemory

from langchain.chains import RetrievalQA

# OpenAI LLM
MODEL_AI="gpt-3.5-turbo"
llm = ChatOpenAI(openai_api_key=OPENAI_API_KEY,
                 model=MODEL_AI,
                 temperature=0.0, # tell the truth, don't be creative
)

# conversational memory
conv_mem = ConversationBufferWindowMemory(
    memory_key="chat_history",
    k=5, # keep last five lines of history
    return_messages=True
)

# retrieval qa - question answer
qa = RetrievalQA.from_chain_type(
    llm=llm,
    # chain types details
    # https://python.langchain.com/en/latest/modules/chains/index_examples/question_answering.html
    # https://docs.langchain.com/docs/components/chains/index_related_chains
    chain_type="stuff", # map_reduce, refine, map_rerank
    retriever=vectorstore.as_retriever()
)

# Defining Retrieval QA Agent

qa.run(query)
# Ai agent tells you the answer directly, not a list of documents.

from langchain.agents import Tool

tools = [
        Tool(
            name="Knowledge Base",
            func=qa.run,
            description =('use this when answering based on knowledge base')
            )]

from langchain.agents import initialize_agent
from langchain.agents import AgentType

AGENT=~AgentType.CHAT_CONVERSATIONAL_REACT_DESCRIPTION

agent = initialize_agent(
        agent=AGENT,
        tools=tools,
        llm=llm,
        verbose=True,
        max_iterations=3,
        early_stopping_methid="generate",
        memory=conv_mem,
)


# Invoking Retrieval QA Agent

agent(query)
# returns an object with the input query string; chat_history list of previous messages broken into types like HumanMessage,AIMessage; output answer string

agent("Who founded the university") # no mention of Notre Dame, it gets from history


