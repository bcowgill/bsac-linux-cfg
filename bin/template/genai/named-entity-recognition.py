import spacy

# natural language processor for english
nlp = spacy.load("en_core_web_sm")
doc = nlp("Apple is looking at buying U.K. startup for $1 billion")

for ent in doc.ents:
    print(ent.text, ent.start_char, ent.end_char, ent.label_)

# Named Entity Recognition

from transformers import AutoTokenizer, AutoModelForTokenClassification
from transformers import pipeline
import torch

# model for NER chosen from HuggingFace site.
model_id = "dslim/bert-base-NER"

tokenizer = AutoTokenizer.from_pretrained(model_id)

ner_model = AutoModelForTokenClassification.from_pretrained(model_id)

device = torch.cuda.current_device() if torch.cuda.is_available() else 'cpu'

nlp = pipeline('ner',
               model=ner_model,
               tokenizer=tokeniser_ner,
               aggregation_strategy="max",
               device=None
)
nlp('My name is Hohsin, I work in Udemy, I love AI')
# list of objects back:
# entity_group PER
# score .999  high confidence it's a person
# word Hohsin
# start,end position

# entity_group ORG
# score .64  somewhat sure it's an organisation
# word Udemy
# start,end position

# AI not identified as an entity

text = "grab some text from a news story online \
        and paste here\
"
nlp(text)
text[start:end]

