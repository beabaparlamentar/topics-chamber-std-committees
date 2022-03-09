import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer


def apply_vectorization(data, content_header, vocabulary=None,
                        percentiles=(5, 80), ngrams=(1, 2),
                        save_vocab_as=None):
    content = data[content_header].copy()
    min_frequency = int(data.shape[0] * percentiles[0] / 100)
    max_frequency = int(data.shape[0] * percentiles[1] / 100)

    vectorizer = CountVectorizer(max_features=None, vocabulary=vocabulary,
                                 min_df=min_frequency, max_df=max_frequency,
                                 ngram_range=ngrams, lowercase=False,
                                 tokenizer=(lambda x: x))

    term_frequency = vectorizer.fit_transform(content)
    features = np.array(vectorizer.get_feature_names())

    if save_vocab_as:
        path = f'models/{save_vocab_as}.csv'
        features_list = pd.DataFrame({'word': features.tolist()})
        features_list.to_csv(path, index=False)

    return term_frequency, features
