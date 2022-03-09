import joblib
import pandas as pd

import toolkit

NGRAMS = (1, 2)

print('Reading data...')
data = pd.read_csv('data/raw/speeches_per_deputy_2015_2018.csv')

print('\nReading model...')
model = joblib.load('models/lda-standing-committees.joblib')
vocabulary = pd.read_csv('models/lda-features.csv')['word'].tolist()

print('\nReading stopwords...')
stopwords = pd.read_csv('data/util/stopwords.csv')
stopwords = stopwords['word'].tolist()

print('\nApplying tokenization...')
data = toolkit.apply_tokenization(data=data, content_header='content',
                                  id_header=['speaker', 'event_id'],
                                  stopwords=stopwords)

print('\nApplying stemming using RSLP...')
data = toolkit.apply_stemming(data=data, content_header='tokens',
                              id_header=['speaker', 'event_id'])

print('\nApplying vectorization using Term-Frequency...')
tf_matrix, features = toolkit.apply_vectorization(data=data,
                                                  vocabulary=vocabulary,
                                                  content_header='stems',
                                                  ngrams=NGRAMS)

print('\nApplying Latent Dirichlet Allocation model to data...')
identifiers = [data['speaker'].tolist(), data['event_id'].tolist()]
document_topics = toolkit.apply_lda_model(model=model,
                                          term_frequency=tf_matrix,
                                          id_header=['speaker', 'event_id'],
                                          identifiers=identifiers,
                                          save_as='deputy-topic-distribution')

print('\nApplying UMAP for dimension reduction of topic distribution...')
doc_topic_distribution = document_topics.copy().iloc[:, 2:]
toolkit.apply_umap_model(values=doc_topic_distribution,
                         id_header=['speaker', 'event_id'],
                         identifiers=identifiers, n_components=2,
                         save_as='umap-deputy-topic-distribution')

print('\nDone!')
