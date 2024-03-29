## Reformat GO enrichment results to human-readable and plot friendly format
library(tidyverse)
library(magrittr)

gost_results_table <-
  snakemake@input[[1]] %>%
  read_rds() %>%
  map_df(.f = ~ .x$result, .id = "contrast"
  ) %>% 
  dplyr::select(contrast, term_id, term_name, significant, source, term_size, p_value, precision, recall, intersection_size, effective_domain_size, query_size
  ) %>% 
  group_by(term_id) %>% 
  filter(any(significant == TRUE)) %>% 
 # mutate_at(
#    .vars = vars(starts_with("intersection")),
#    .funs = ~ round(.x * 100 / term_size, digits = 1)) %>% 
  dplyr::select(
    contrast, source, term_id, term_name, term_size, p_value, precision, recall, significant, intersection_size, effective_domain_size, query_size
  ) 

write_csv(x = gost_results_table, file = snakemake@output[['go_long_format']])

gost_results_table_wider <-
  gost_results_table %>% 
  pivot_wider(
    names_from = contrast, values_from = c(significant, p_value, precision, recall, intersection_size, effective_domain_size, query_size)
  ) 

write_csv(x = gost_results_table_wider, file = snakemake@output[['go_wide_format']])  