# Libraries and Themes
library(dplyr)
library(gghighlight)
library(ggplot2)
library(hrbrthemes)
library(lubridate)
library(scales)
library(stringr)
#library(tidymodels)
library(tidyr)

theme_set(theme_ipsum_tw())


# Constants
n_topics <- 22

legend_values <- c(0.01, 0.25, 0.5)

target_topics <- c('Social Security', 'Human Rights', 'Health Care',
                   'Education', 'Traffic and Transport', 'Industry and Economy',
                   'Regulation and Control', 'Labor')

ccjc_main_topics <- c('Legislation', 'Justice', 'Labor', 'Public Security',
                      'Taxation', 'Social Security', 'Investigations',
                      'Regulation and Control', 'Industry and Economu',
                      'Human Rights')

highlighted_dates <- c(date('2016-08-31'), date('2017-06-26'),
                       date('2017-09-14'), date('2019-01-01'))

topics_order <- c('Legislation', 'Sports', 'Traffic and Transport',
                  'Education', 'Mines and Energy', 'Public Security',
                  'Agriculture', 'Regulation and Control', 'Social Security',
                  'Labor', 'Urban Development', 'Environment', 'Health Care',
                  'Taxation', 'Human Rights', 'Industry and Economy',
                  'Education and Culture', 'Health Research', 'Amazon',
                  'Justice', 'Investigations', 'Indigenous and Quilombolas')

committes_order <- c('CCJC', 'CEsp', 'CVT', 'CEdu', 'CME', 'CT', 'CSPCCO',
                     'CAPADR', 'CDC', 'CDM', 'CTASP', 'CDU', 'CMADS', 'CCTCI',
                     'CSSF', 'CFT', 'CDHM', 'CREDN', 'CDPI', 'CC', 'CDPD',
                     'CDEICS', 'CINDRA', 'CFEC', 'CLP')


# Color and Scales
purple <- '#5D2A42'
pink <- '#FB6376'
beige <- '#FCB1A6'
light_gray <- '#F0F0F0'

color_scale_3 <- c(purple, pink, beige)


# Theme
theme_settings <- theme(
  axis.title.x = element_text(family = 'Times New Roman', face = 'bold',
                              size = 18, vjust = 0, hjust = 0.5),
  axis.title.y = element_text(family = 'Times New Roman', face = 'bold',
                              size = 18, vjust = 2.75, hjust = 0.5),
  axis.text.x = element_text(family = 'Times New Roman', size = 16,
                             vjust = 1, hjust = 0.5),
  axis.text.y = element_text(family = 'Times New Roman', size = 16,
                             vjust = 0.5, hjust = 1),
  strip.text = element_text(family = 'Times New Roman', face = 'bold',
                            size = 17, vjust = 0, hjust = 0.5),
  legend.box.margin = margin(0, 0, 10, -90, 'pt'),
  legend.box.just = 'center',
  legend.title = element_text(family = 'Times New Roman', face = 'bold',
                              size = 17),
  legend.text = element_text(family = 'Times New Roman', size = 17),
  legend.key.size = unit(1.5, 'cm'),
  legend.position = 'top',
  legend.direction = 'horizontal'
)


# Functions
scientific_10 <- function(x) {
  parse(text = gsub('e\\+*', ' %*% 10^', scientific_format()(x)))
}

