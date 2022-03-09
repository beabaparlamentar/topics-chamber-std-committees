library(dplyr)
library(here)
library(readr)

acronyms <- read_csv(here('data/util/acronyms.csv'))
topics <- read_csv(here('data/util/topics.csv'))
parties <- read_csv(here('data/util/parties.csv'))

topic_mapping <- setNames(paste0('topic_', topics %>% pull('topic')), topics %>%
                            pull(topic_name))

events_metadata <- read_csv(here('data/ready/metadata.csv')) %>%
  left_join(acronyms)

model_evaluation <- read_csv(here('data/ready/model-evaluation.csv')) %>%
  mutate(learning_decay = gsub('6', '60', learning_decay)) %>%
  mutate(learning_decay = gsub('9', '90', learning_decay))

umap_event_topics <- read_csv(here('data/ready/umap-event-topic-distribution.csv'))
umap_event_topics <- events_metadata %>%
  right_join(umap_event_topics) %>%
  select(event_id, committee_acronym, umap_x, umap_y)

event_topic_association <- read_csv(here('data/ready/event-topic-distribution.csv')) %>%
  pivot_longer(cols = starts_with("topic_"), names_to = "topic",
               names_prefix = "topic_", values_to = "association") %>%
  left_join(topics %>% mutate(topic = as.factor(topic)), by = 'topic') %>%
  select(-topic) %>%
  rename(topic = topic_name)

event_topic_association <- events_metadata %>%
  inner_join(event_topic_association)

event_topic_association_2021 <- read_csv(here('data/ready/event-topic-distribution-2021.csv')) %>%
  pivot_longer(cols = starts_with("topic_"), names_to = "topic",
               names_prefix = "topic_", values_to = "association") %>%
  left_join(topics %>% mutate(topic = as.factor(topic)), by = 'topic') %>%
  select(-topic) %>%
  rename(topic = topic_name) %>%
  left_join(acronyms)

deputy_topic_association <- read_csv(here('data/ready/deputy-topic-distribution.csv')) %>%
  pivot_longer(cols = starts_with("topic_"), names_to = "topic",
               names_prefix = "topic_", values_to = "association") %>%
  left_join(topics %>% mutate(topic = as.factor(topic)), by = 'topic') %>%
  select(-topic) %>%
  rename(topic = topic_name)

deputy_topic_association <- deputy_topic_association %>%
  inner_join(parties) %>%
  right_join(events_metadata) %>%
  na.omit()

umap_deputy_topics <- read_csv(here('data/ready/umap-deputy-topic-distribution.csv'))
umap_deputy_topics <- events_metadata %>%
  right_join(umap_deputy_topics) %>%
  inner_join(parties) %>%
  select(speaker, party, state, event_id, committee_acronym, umap_x, umap_y) %>%
  na.omit()
