library(tidyverse)
library(shiny)

link <- "https://raw.githubusercontent.com/jpedroza1228/exitsurveys/main/data/student_experience.csv"

exit <- read_csv(link) %>% 
  rowid_to_column()

names(data)

student_yes <- function(percent, total){
  value <- (percent/100)*total
  round(value, digits = 0)
}

exit %>% 
  select(-program) %>% 
  map(~student_yes(percent = .x, total = exit$number_respondents))



# exit %>% 
#   mutate(publish_agree_adjust = student_yes(publish_help_agree, number_respondents))



program_year_diff <- function(data, x){
  
  data <- {{data}} %>% 
    mutate(student_n = student_yes({{x}}, number_respondents))
  
  data %>% 
    filter(program == {{name}}) %>% 
  ggplot(data = data, aes(year, student_n)) +
    geom_point(aes(color = program)) +
    geom_line(aes(color = program)) +
    theme_minimal() +
    labs(title = "Comparison of Variable ")
    theme(legend.position = "none")
}

program_year_diff(exit, intel_open_agree)




grad_long <- grad %>% 
pivot_longer(4:54, names_to = "program_req", values_to = 'program_req_values')

names(grad_long)

grad_long <- grad_long %>% 
pivot_longer(4:29, names_to = "advisor", values_to = "advisor_values")

names(grad_long)

grad_long <- grad_long %>% 

pivot_longer(4:36, names_to = "inclusive", values_to = "inclusive_values")



choices <- c('fac_qual_good' = '#669b3e', 'fac_qual_ex' = '#398b98', 'fac_qual_fair_poor' = '#ea5227')

exit %>%
mutate(fac_qual_good = fac_qual_ex_good - fac_qual_ex) %>% 
pivot_longer(c(4:54, 114), names_to = "program_req", values_to = 'program_req_values') %>% 
filter(str_detect(program_req, "fac_qual")) %>% 
filter(program == 'biology' |
       program == 'chemistry' |
       program == 'computer_information_science' |
       program == 'mathematics') %>% 
filter(program_req != "fac_qual_ex_good") %>% 
mutate(program_req = fct_relevel(program_req, c("fac_qual_ex", "fac_qual_good", "fac_qual_fair_poor"))) %>% 
ggplot(aes(program, program_req_values, fill = program_req)) +
geom_bar(position = "fill",stat = "identity") +
facet_wrap(~year) +
theme_minimal() +
coord_flip() +
scale_fill_manual(values = choices)

grad_program %>% 
filter(program == 'biology' |
       program == 'chemistry' |
       program == 'computer_information_science' |
       program == 'mathematics') %>% 

ggplot(aes(program, program_req_values)) +
geom_point(aes(color = as.factor(year))) +
facet_wrap(~program_req) +
theme_minimal() +
coord_flip() +
theme(legend.title = element_blank())



# ui <-

# server <- 