import pandas as pd
from sklearn.manifold import TSNE


def apply_tsne_model(values, id_header, identifiers, n_components=2,
                     save_as=None):
    tsne_dimensions = pd.DataFrame()
    model = TSNE(n_components=n_components, random_state=0, verbose=0)

    tsne_embeddings = model.fit_transform(values)

    if isinstance(id_header, str):
        tsne_dimensions.insert(0, id_header, identifiers.copy())
        tsne_dimensions.insert(1, 'umap_x', tsne_embeddings[:, 0])
        tsne_dimensions.insert(2, 'umap_y', tsne_embeddings[:, 1])

    if isinstance(id_header, list):
        for i in range(len(id_header)):
            tsne_dimensions.insert(i, id_header[i], identifiers[i].copy())
        tsne_dimensions.insert(i + 1, 'umap_x', tsne_embeddings[:, 0])
        tsne_dimensions.insert(i + 2, 'umap_y', tsne_embeddings[:, 1])

    if save_as:
        path = f'data/ready/{save_as}.csv'
        tsne_dimensions.to_csv(path, index=False)

    return tsne_dimensions
