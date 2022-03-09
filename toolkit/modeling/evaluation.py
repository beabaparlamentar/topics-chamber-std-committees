
import joblib

import pandas as pd
from sklearn.decomposition import LatentDirichletAllocation
from sklearn.model_selection import GridSearchCV


def evaluate_lda_model(term_fequency, words, parameters,
                       save_evaluation_as=None, save_model_as=None,
                       save_words_as=None):
    model = LatentDirichletAllocation(learning_method='online', random_state=0)
    optimizer = GridSearchCV(estimator=model, param_grid=parameters)

    optimizer.fit(term_fequency)

    best_model = optimizer.best_estimator_
    best_parameters = optimizer.best_params_
    evaluation = pd.DataFrame({
        'learning_decay': optimizer.cv_results_['param_learning_decay'].data,
        'n_components': optimizer.cv_results_['param_n_components'].data,
        'log_likelihood': optimizer.cv_results_['mean_test_score']
    })

    topic_main_words = []
    for topic_association in best_model.components_:
        word_indexes = (-topic_association).argsort()[:10]
        topic_main_words.append(words.take(word_indexes))

    n_components = best_parameters['n_components']
    topic_main_words = pd.DataFrame(topic_main_words)
    topic_main_words.columns = [f'word_{i}' for i in range(10)]
    topic_main_words.insert(0, 'topic', [i for i in range(n_components)])

    if save_evaluation_as:
        path = f'data/ready/{save_evaluation_as}.csv'
        evaluation.to_csv(path, index=False)

    if save_model_as:
        path = f'models/{save_model_as}.joblib'
        joblib.dump(best_model, path)

    if save_words_as:
        path = f'data/ready/{save_words_as}.csv'
        topic_main_words.to_csv(path, index=False)

    return best_model
