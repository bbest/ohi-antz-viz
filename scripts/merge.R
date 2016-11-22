library(tidyverse)

# get regions
rgns = data_frame(
  region_id = 0,
  type      = 'global',
  label     = 'GLOBAL') %>%
  bind_rows(
    read_csv('https://github.com/OHI-Science/ohi-global/raw/draft/eez2015/layers/rgn_labels.csv') %>%
      mutate(region_id = rgn_id) %>%
      select(-rgn_id))

for (yr in 2012:2016){ # yr = 2012
  
  # get scores
  url = sprintf('https://github.com/OHI-Science/ohi-global/raw/draft/eez%d/scores.csv', yr)
  csv = sprintf('data/ohi_eez%d_scores.csv', yr)

  read_csv(url) %>%
    left_join(rgns, by='region_id') %>%
    unite(goal_dimension, goal, dimension, sep='_') %>%
    spread(goal_dimension, score) %>%
    write_csv(csv)

}
