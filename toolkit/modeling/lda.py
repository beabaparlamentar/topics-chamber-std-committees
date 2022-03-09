import numpy as np
import pandas as pd


def apply_lda_model(model, term_frequency, id_header, identifiers,
                    save_as=None):
    model_parameters = model.get_params()
    n_topics = model_parameters['n_components']

    topics = [f'topic_{i}' for i in range(n_topics)]
    document_topics = model.transform(term_frequency)
    document_topics = pd.DataFrame(data=document_topics, columns=topics)
    document_topics = document_topics.round(3)
    documents_main_topic = np.argmax(document_topics.values, axis=1)

    document_topics.insert(0, 'main_topic', documents_main_topic)

    if isinstance(id_header, str):
        document_topics.insert(0, id_header, identifiers.copy())

    if isinstance(id_header, list):
        for i in range(len(id_header)):
            document_topics.insert(i, id_header[i], identifiers[i].copy())

    if save_as:
        path = f'data/ready/{save_as}.csv'
        document_topics.to_csv(path, index=False)

    return document_topics
