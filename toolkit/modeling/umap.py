import pandas as pd
from umap.umap_ import UMAP


def apply_umap_model(values, id_header, identifiers, n_components=2,
                     save_as=None):
    umap_dimensions = pd.DataFrame()
    model = UMAP(n_components=n_components, random_state=0)

    umap_embeddings = model.fit_transform(values)

    if isinstance(id_header, str):
        umap_dimensions.insert(0, id_header, identifiers.copy())
        umap_dimensions.insert(1, 'umap_x', umap_embeddings[:, 0])
        umap_dimensions.insert(2, 'umap_y', umap_embeddings[:, 1])

    if isinstance(id_header, list):
        for i in range(len(id_header)):
            umap_dimensions.insert(i, id_header[i], identifiers[i].copy())
        umap_dimensions.insert(i + 1, 'umap_x', umap_embeddings[:, 0])
        umap_dimensions.insert(i + 2, 'umap_y', umap_embeddings[:, 1])

    if save_as:
        path = f'data/ready/{save_as}.csv'
        umap_dimensions.to_csv(path, index=False)

    return umap_dimensions
