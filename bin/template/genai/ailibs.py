#!/usr/bin/python3
import re
import sys

PIPPED=False # set to 1 after you have pip installed the other modules...
ALL=False

def python_version():
    match = re.search(r'\d+(\.\d+)?', sys.version)
    numeric = '0'
    if match:
        numeric = match.group()
    return float(numeric)


ver = python_version()
print("For Python " + str(ver))

# python 2.7.6 has these libs
print("trying 2+ libs")
import os
import io
import ast
import time
import shutil
import datetime
import requests

if ver < 3:
    print("skip PIL")
    import PIL # not in python 3.4.3

if PIPPED:
    # python 2.7.6 and 3.4.3 does not have these libs... (need to pip install)
    import flask
    import openai
    import secret
    import Random
    import aiohttp
    import tkinter # requires python3-tk
    import dotenv
    import langchain
    import numpy
    import lark
    import panel
    import param

if ver >= 3:
    print("skip asyncio")
    # python 3.4.3 but not 2.7.6
    import asyncio

if ALL:
    import tkinter.scrolledtext as tks #creates a scrollable text window
    from datetime import datetime
    from tkinter import *
    from PIL import Image, ImageOps
    from PIL import ImageEnhance, ImageOps
    from io import BytesIO
    from flask import Flask, jsonify, request, render_template

    # libraries from RAG course on jupityr notebooks
    from dotenv import load_dotenv, find_dotenv
    from langchain.document_loaders import PyPDFLoader
    from langchain.document_loaders.generic import GenericLoader
    from langchain.document_loaders.parsers import OpenAIWhisperParser
    from langchain.document_loaders.blob_loaders.youtube_audio import YoutubeAudioLoader
    from langchain.document_loaders import WebBaseLoader
    from langchain.document_loaders import NotionDirectoryLoader
    from langchain.text_splitter import RecursiveCharacterTextSplitter, CharacterTextSplitter
    from langchain.text_splitter import TokenTextSplitter
    from langchain.textksplitter import MarkdownHeaderTextSplitter
    from langchain.embeddings.openai import OpenAIEmbeddings
    from langchain.vectorstores import Chroma
    from langchain.llms import OpenAI
    from langchain.retrievers.self_query.base import SelfQueryRetriever
    from langchain.chains.query_constructor.base import AttributeInfo
    from langchain.retrievers import ContextualCompressionRetriever
    from langchain.retrievers.document_compressors import LLMChainExtractor
    from langchain.retrievers import SVMRetriever
    from langchain.retrievers import TFIDFRetriever
    from langchain.chat_models import ChatOpenAI
    from langchain.chains import RetrievalQA
    from langchain.prompts import PromptTemplate
    from langchain.memory import ConversationBufferMemory
    from langchain.chains import ConversationalRetrievalChain
    from langchain.vectorstores import DocArrayInMemorySearch
    from langchain.document_loaders import TextLoader

#! pip install openai pandas
#! pip install PIL
#! pip install langchain
#! pip install pypdf
#! pip install yt_dlp
#! pip install pydub
#! pip install chromadb
#! pip install python-dotenv
#! pip install flask
#!pip install lark
