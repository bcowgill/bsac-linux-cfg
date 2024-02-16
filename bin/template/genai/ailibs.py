#!/usr/bin/python3
import re
import sys

PIPPED=True # set to 1 after you have pip installed the other modules...
ALL=True

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
import random
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
    import aiohttp
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
    import tkinter # requires python3-tk

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
    from langchain_community.document_loaders import PyPDFLoader
    from langchain_community.document_loaders.generic import GenericLoader
    from langchain_community.document_loaders.parsers import OpenAIWhisperParser
    from langchain_community.document_loaders.blob_loaders.youtube_audio import YoutubeAudioLoader
    from langchain_community.document_loaders import WebBaseLoader
    from langchain_community.document_loaders import NotionDirectoryLoader
    from langchain.text_splitter import RecursiveCharacterTextSplitter, CharacterTextSplitter
    from langchain.text_splitter import TokenTextSplitter
    from langchain.text_splitter import MarkdownHeaderTextSplitter
    from langchain.embeddings.openai import OpenAIEmbeddings
    from langchain_community.vectorstores import Chroma
    from langchain_community.llms import OpenAI
    from langchain.retrievers.self_query.base import SelfQueryRetriever
    from langchain.chains.query_constructor.base import AttributeInfo
    from langchain.retrievers import ContextualCompressionRetriever
    from langchain.retrievers.document_compressors import LLMChainExtractor
    from langchain_community.retrievers import SVMRetriever
    from langchain_community.retrievers import TFIDFRetriever
    from langchain_community.chat_models import ChatOpenAI
    from langchain.chains import RetrievalQA
    from langchain.prompts import PromptTemplate
    from langchain.memory import ConversationBufferMemory
    from langchain.chains import ConversationalRetrievalChain
    from langchain_community.vectorstores import DocArrayInMemorySearch
    from langchain_community.document_loaders import TextLoader

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
