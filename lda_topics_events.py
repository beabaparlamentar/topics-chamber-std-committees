import pandas as pd

import toolkit

METADATA_COLUMNS = ['event_id', 'event_type', 'committee', 'date', 'month']

PERCENTILES = (5, 80)
NGRAMS = (1, 2)

GRID_PARAMETERS = {
    'n_components': [x for x in range(20, 31)],
    'learning_decay': [0.60, 0.75, 0.90]
}

print('Reading data...')
data = pd.read_csv('data/raw/speeches_per_event_2008_2019.csv')

print('\nReading stopwords...')
stopwords = pd.read_csv('data/util/stopwords.csv')
stopwords = stopwords['word'].tolist()

print('\nExtracting metadata...')
data['month'] = data['date'].apply(toolkit.get_month_from_date)
toolkit.extract_metadata(data=data, columns=METADATA_COLUMNS,
                         save_as='metadata')

print('\nApplying tokenization...')
data = toolkit.apply_tokenization(data=data, content_header='content',
                                  id_header='event_id', stopwords=stopwords)

print('\nApplying stemming using RSLP...')
data = toolkit.apply_stemming(data=data, content_header='tokens',
                              id_header='event_id')

print('\nApplying vectorization using Term-Frequency...')
tf_matrix, features = toolkit.apply_vectorization(data=data,
                                                  content_header='stems',
                                                  percentiles=PERCENTILES,
                                                  ngrams=NGRAMS,
                                                  save_vocab_as='lda-features')

print('\nEvaluating parameters for Latent Dirichlet Allocation model...')
model = toolkit.evaluate_lda_model(term_fequency=tf_matrix, words=features,
                                   parameters=GRID_PARAMETERS,
                                   save_evaluation_as='model-evaluation',
                                   save_model_as='lda-standing-committees',
                                   save_words_as='topics-main-words')

print('\nApplying best Latent Dirichlet Allocation model to data...')
identifiers = data['event_id'].tolist()
document_topics = toolkit.apply_lda_model(model=model,
                                          term_frequency=tf_matrix,
                                          id_header='event_id',
                                          identifiers=identifiers,
                                          save_as='event-topic-distribution')

print('\nApplying UMAP for dimension reduction of term frequency...')
toolkit.apply_umap_model(values=tf_matrix, id_header='event_id',
                         identifiers=identifiers, n_components=2,
                         save_as='umap-term-frequency')

print('\nApplying UMAP for dimension reduction of topic distribution...')
doc_topic_distribution = document_topics.copy().iloc[:, 2:]
toolkit.apply_umap_model(values=doc_topic_distribution, id_header='event_id',
                         identifiers=identifiers, n_components=2,
                         save_as='umap-event-topic-distribution')

print('\nDone!')
