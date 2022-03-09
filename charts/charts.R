source('charts/settings.R')
source('charts/data.R')

# Dimensions: 6 x 12
model_evaluation %>%
  ggplot(aes(x = n_components, y = log_likelihood, color = learning_decay)) +
  geom_line(aes(group = learning_decay), size = 1) +
  geom_point(size = 3) +
  labs(x = 'Topics', y = 'Log-Likelihood', color = 'Learning Rate Decay') +
  scale_x_continuous(breaks = pretty_breaks(n = 15)) +
  scale_y_continuous(breaks = pretty_breaks(n = 3), label = scientific_10) +
  scale_color_manual(values = color_scale_3) +
  theme_settings +
  theme(panel.grid.minor = element_blank())


# Dimensions: 8 x 8
umap_event_topics %>%
  group_by(committee_acronym) %>%
  summarise(sd = sd(umap_x) * sd(umap_y)) %>%
  inner_join(umap_event_topics) %>%
  ggplot(aes(x = umap_x, y = umap_y, color = committee_acronym))  +
  geom_point(size = 1, show.legend = FALSE) +
  gghighlight(unhighlighted_params = list(size = 1,
                                          colour = alpha(light_gray, 0.1),
                                          alpha = 0.05)) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = rep(pink, 25)) +
  facet_wrap(facets = ~reorder(committee_acronym, sd), ncol = 5) +
  theme_settings +
  theme(axis.text.x = element_blank(), axis.text.y = element_blank(),
        panel.grid.major = element_blank())


# Dimensions: 8 x 12
event_topic_association %>%
  group_by(committee_acronym, topic) %>%
  summarise(association = mean(association)) %>%
  ggplot(aes(x = reorder(committee_acronym, -association, min),
             y = reorder(topic, association, max),
             size = association, color = association)) +
  geom_point(alpha = 0.75) +
  labs(x = NULL, y = NULL,
       color = 'Topic Association', size = 'Topic Association') +
  guides(color = guide_legend(), size = guide_legend()) +
  scale_color_viridis_c(option = 'magma', direction = -1,
                        breaks = legend_values,
                        labels = percent(legend_values)) +
  scale_size_continuous(range = c(2, 10), breaks = legend_values,
                        labels = percent(legend_values)) +
  theme_settings +
  theme(axis.text.x = element_text(family = 'Times New Roman', size = 16,
                                   vjust = 0.8, hjust = 0.75, angle = 45),
        legend.box.margin = margin(0, 0, -5, -100, 'pt'),
        panel.grid.minor = element_blank())


# Dimensions: 8 x 12
event_topic_association_2021 %>%
  group_by(committee_acronym, topic) %>%
  summarise(association = mean(association)) %>%
  ggplot(aes(x = committee_acronym, y = topic,
             size = association, color = association)) +
  geom_point(alpha = 0.75) +
  labs(x = NULL, y = NULL,
       color = 'Topic Association', size = 'Topic Association') +
  guides(color = guide_legend(), size = guide_legend()) +
  scale_x_discrete(limits = committes_order) +
  scale_y_discrete(limits = rev(topics_order)) +
  scale_color_viridis_c(option = 'magma', direction = -1,
                        breaks = legend_values,
                        labels = percent(legend_values)) +
  scale_size_continuous(range = c(2, 10), breaks = legend_values,
                        labels = percent(legend_values)) +
  theme_settings +
  theme(axis.text.x = element_text(family = 'Times New Roman', size = 16,
                                   vjust = 0.8, hjust = 0.75, angle = 45),
        legend.box.margin = margin(0, 0, -5, -100, 'pt'),
        panel.grid.minor = element_blank())


# Dimensions: 6 x 12 (RStudio Cloud)
# models <- event_topic_association %>%
#   filter(topic %in% target_topics) %>%
#   group_by(committee_acronym, month, topic) %>%
#   summarise(association = mean(association), events = n()) %>%
#   group_by(topic, month) %>%
#   summarise(total = mean(association), n = n(), .groups = 'drop') %>%
#   filter(n > 10) %>%
#   group_by(topic) %>%
#   nest() %>%
#   mutate(model = map(data, ~ lm(total ~ month, data = .)),
#          coefficients = map(model, tidy),
#          adjust = map(model, glance),
#          predicted = map2(model, data, augment))
#
# models_coefficients <- models %>%
#   unnest(coefficients) %>%
#   select(-model, -adjust, -data) %>%
#   filter(term != '(Intercept)')
#
# models_predictions <- models %>%
#   unnest(predicted) %>%
#   select(-model, -coefficients, -data)
#
# models_predictions %>%
#   left_join(models_coefficients, by = 'topic') %>%
#   ggplot(aes(x = month)) +
#   facet_wrap(~ reorder(topic, -estimate), ncol = 4) +
#   geom_point(aes(y = total), size = 2, alpha = 0.5, color = pink) +
#   geom_line(aes(y = .fitted), size = 1, linetype = 'dashed') +
#   labs(x = NULL, y = NULL) +
#   scale_y_continuous(breaks = c(0, 0.15), labels = percent) +
#   theme_settings +
#   theme(axis.text.x = element_text(family = 'Times New Roman', size = 16,
#                                    vjust = 0.8, hjust = 0.75),
#         axis.text.y = element_text(family = 'Times New Roman', size = 16,
#                                    vjust = 0.5, hjust = 0.5),
#         strip.text = element_text(family = 'Times New Roman', face = 'bold',
#                                   size = 16, vjust = 0, hjust = 0.5))


# Dimensions: 6 x 12
event_topic_association %>%
  mutate(year = strtoi(substring(month, 1, 4))) %>%
  filter(year >= 2015) %>%
  filter(topic %in% ccjc_main_topics) %>%
  filter(committee_acronym == 'CCJC') %>%
  group_by(month, topic) %>%
  summarise(association = mean(association)) %>%
  ggplot(aes(x = month, y = reorder(topic, association),
             size = association, color = association)) +
  geom_point(alpha = 0.75) +
  geom_vline(xintercept = highlighted_dates, linetype = 'dashed') +
  annotate('text', x = date('2016-08-05'), y = 4,
           label = "Dilma Roussef's Impeachment", color = 'black',
           family = 'Times New Roman', fontface = 2,
           size = 14 / .pt, angle = 90) +
  annotate('text', x = date('2017-05-30'), y = 3.9,
           label = '1st complaint against Temer', color = 'black',
           family = 'Times New Roman', fontface = 2,
           size = 14 / .pt, angle = 90) +
  annotate('text', x = date('2017-08-20'), y = 3.9,
           label = '2nd complaint against Temer', color = 'black',
           family = 'Times New Roman', fontface = 2,
           size = 14 / .pt, angle = 90) +
  annotate('text', x = date('2018-12-05'), y = 4.6,
           label = "Bolsonaro's Presidential Inauguration", color = 'black',
           family = 'Times New Roman', fontface = 2,
           size = 14 / .pt, angle = 90) +
  labs(x = NULL, y = NULL,
       color = 'Topic Association', size = 'Topic Association') +
  guides(color = guide_legend(), size = guide_legend()) +
  scale_x_date(breaks = pretty_breaks(n = 6)) +
  scale_color_viridis_c(option = 'magma', direction = -1,
                        breaks = legend_values,
                        labels = percent(legend_values)) +
  scale_size_continuous(range = c(3, 10), breaks = legend_values,
                        labels = percent(legend_values)) +
  theme_settings +
  theme(axis.text.x = element_text(family = 'Times New Roman', size = 16,
                                   vjust = 0, hjust = 0.75),
        legend.box.margin = margin(0, 0, -5, -40, 'pt'),
        panel.grid.minor = element_blank())


# Dimensions: 8 x 12
filtered_deputies <- deputy_topic_association %>%
  group_by(speaker, committee_acronym) %>%
  summarise(events = n() / n_topics) %>%
  filter(events > 5) %>%
  select(speaker, committee_acronym)

deputy_topic_association %>%
  inner_join(filtered_deputies) %>%
  filter(!committee_acronym %in% c('CCJC', 'CFT', 'CLP')) %>%
  group_by(state, topic) %>%
  summarise(association = mean(association)) %>%
  ggplot(aes(x = state, y = topic, size = association, color = association)) +
  geom_point(alpha = 0.75) +
  labs(x = NULL, y = NULL,
       color = 'Topic Association', size = 'Topic Association') +
  guides(color = guide_legend(), size = guide_legend()) +
  scale_y_discrete(limits = rev(topics_order)) +
  scale_color_viridis_c(option = 'magma', direction = -1,
                        breaks = legend_values,
                        labels = percent(legend_values)) +
  scale_size_continuous(range = c(2, 10), breaks = legend_values,
                        labels = percent(legend_values)) +
  theme_settings +
  theme(axis.text.x = element_text(family = 'Times New Roman', size = 16,
                                   vjust = 0.8, hjust = 0.75, angle = 45),
        legend.box.margin = margin(0, 0, -5, -100, 'pt'),
        panel.grid.minor = element_blank())


# Dimensions: 8 x 12
deputy_topic_association %>%
  inner_join(filtered_deputies) %>%
  filter(!committee_acronym %in% c('CCJC', 'CFT', 'CLP')) %>%
  group_by(party, topic) %>%
  summarise(association = mean(association)) %>%
  ggplot(aes(x = party, y = topic, size = association, color = association)) +
  geom_point(alpha = 0.75) +
  labs(x = NULL, y = NULL,
       color = 'Topic Association', size = 'Topic Association') +
  guides(color = guide_legend(), size = guide_legend()) +
  scale_y_discrete(limits = rev(topics_order)) +
  scale_color_viridis_c(option = 'magma', direction = -1,
                        breaks = legend_values,
                        labels = percent(legend_values)) +
  scale_size_continuous(range = c(2, 10), breaks = legend_values,
                        labels = percent(legend_values)) +
  theme_settings +
  theme(axis.text.x = element_text(family = 'Times New Roman', size = 16,
                                   vjust = 0.8, hjust = 0.75, angle = 45),
        legend.box.margin = margin(0, 0, -5, -100, 'pt'),
        panel.grid.minor = element_blank())
