import pandas as pd
from nltk.stem.rslp import RSLPStemmer


def apply_stemming(data, content_header, id_header=None, save_as=None):
    stemmer = RSLPStemmer()

    stems = pd.DataFrame()
    content = data[content_header].copy()

    content = content.apply(lambda tokens: [stemmer.stem(t) for t in tokens])

    if isinstance(id_header, str):
        stems[id_header] = data[id_header].copy()

    if isinstance(id_header, list):
        for column in id_header:
            stems[column] = data[column].copy()

    stems['stems'] = content

    if save_as:
        path = f'data/ready/{save_as}.csv'
        stems.to_csv(path, index=False)

    return stems
