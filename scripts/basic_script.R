# data sources - graduate school
# IR - https://ir.uoregon.edu/

library(tidyverse)
library(rio)
library(here)
# install.packages('pdftools')
library(pdftools)

exit <- import(here('data', 'exit_surveys_all.csv'),
               setclass = 'tbl_df') %>% 
  janitor::clean_names()

theme_set(theme_minimal())

names(exit)

exit %>% 
  pivot_longer(cols = c(climate_str_agree_inclusive_stu_color, climate_agree_inclusive_stu_color, climate_disagree_inclusive_stu_color),
               names_to = 'climate', values_to = 'agreeance_level') %>% 
  drop_na(agreeance_level) %>% 
  ggplot(aes(climate, agreeance_level)) +
  geom_col(aes(fill = climate), color = 'white', position = 'dodge2') +
  # coord_flip() +
  viridis::scale_fill_viridis(option = 'D', discrete = TRUE) +
  facet_wrap(~program_dept_college) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

library(rvest)
