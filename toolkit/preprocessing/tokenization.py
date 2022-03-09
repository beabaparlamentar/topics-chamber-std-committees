import re

import pandas as pd
from nltk.tokenize import RegexpTokenizer

from toolkit.constants import REGEX


def apply_tokenization(data, content_header, id_header=None, stopwords=None,
                       save_as=None):
    tokenizer = RegexpTokenizer(REGEX['Tokens'])

    tokens = pd.DataFrame()
    content = data[content_header].copy()

    content = content.apply(lambda text: re.sub(REGEX['Punct'], '', text))
    content = content.apply(lambda text: text.lower())
    content = content.apply(lambda text: tokenizer.tokenize(text))

    if stopwords:
        content = content.apply(
            lambda tokens: [t for t in tokens if t not in stopwords]
        )

    if isinstance(id_header, str):
        tokens[id_header] = data[id_header].copy()

    if isinstance(id_header, list):
        for column in id_header:
            tokens[column] = data[column].copy()

    tokens['tokens'] = content

    if save_as:
        path = f'data/ready/{save_as}.csv'
        tokens.to_csv(path, index=False)

    return tokens
