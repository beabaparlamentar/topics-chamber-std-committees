import pandas as pd


def extract_metadata(data, columns=[], save_as=None):
    metadata = data.filter(items=columns)

    if save_as:
        path = f'data/ready/{save_as}.csv'
        metadata.to_csv(path, index=False)

    return metadata


def get_month_from_date(date):
    return date[0:7] + '-01'
