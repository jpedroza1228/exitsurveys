library(tidyverse)
library(pdftools)

getwd()

pdf_link <- 'C:/Users/cpppe/Desktop/github_projects/exitsurveys/pdf_data/exit_surveys/common_dataset/CDS_2019-2020.pdf'
text <- pdf_text(pdf_link)


cat(text[3])

data <- pdf_data(pdf_link)[3]

grad_enroll <- data[[1]]$text[124:154]
grad_enroll

grad_1920 <- tibble(graduate = c('degree seeking, first-time',
                    'all other degree seeking',
                    'all other graduates enrolled in credit courses',
                    'total graduate'),
                    year = '2019-2020',
       men_full_time = grad_enroll[c(4, 11, 20, 28)],
       women_full_time = grad_enroll[c(5, 12, 21, 29)],
       men_part_time = grad_enroll[c(6, 13, 22, 30)],
       women_part_time = grad_enroll[c(7, 14, 23, 31)])

grad_1920

stu_link <- 'C:/Users/cpppe/Desktop/github_projects/exitsurveys/pdf_data/exit_surveys/diversity_inclusion_report/student_demographics(15-16).pdf'
stu_demo <- pdf_text(stu_link)

stu_demo_data <- pdf_data(stu_link)[6]
stu_demo_data[[1]]$text
# get graduate data from here on race/ethnicity










stu_exp_somd_link <- 'C:/Users/cpppe/Desktop/github_projects/exitsurveys/pdf_data/exit_surveys/student_experience_survey/2015/2015-SOJC-Grad-experience-Survey-Report.pdf'
stu_exp_somd <- pdf_text(stu_exp_somd_link)

exp_somd <- pdf_data(stu_exp_somd_link)[2]
exp_somd_pulled <- exp_somd[[1]]$text
pg2 <- str_subset(exp_somd_pulled, pattern = '[:digit:]')

stu_exp_somd_df <- tibble(number_respondent = pg2[c(2:4)],
                          number_stu_survey = pg2[c(6:8)],
                          resp_rate = pg2[c(10:12)])
stu_exp_somd_df

somd_pro_sat_ex <- pdf_data(stu_exp_somd_link)[3]
sat_ex <- somd_pro_sat_ex[[1]]$text
sat_ex_num_only <- str_subset(sat_ex, pattern = '\\%')
  

pg2 <- tibble(fac_qual_ex = sat_ex_num_only[1],
              pro_qual_ex = sat_ex_num_only[2],
              money_sup_ex = sat_ex_num_only[3],
              field_dev_pace_ex = sat_ex_num_only[4],
              advising_qual_ex = sat_ex_num_only[5],
              smart_community_Ex = sat_ex_num_only[6],
              prof_dev_ex = sat_ex_num_only[7],
              equipment_ex = sat_ex_num_only[8],
              grad_involve_ex = sat_ex_num_only[9],
              research_opp_ex = sat_ex_num_only[10],
              grad_fair_assess_ex = sat_ex_num_only[11],
              promote_inclu_ex = sat_ex_num_only[12],
              grant_train_ex = sat_ex_num_only[13],
              teach_prep_ex = sat_ex_num_only[14],
              grad_clear_assess_ex = sat_ex_num_only[15],
              inter_sup_ex = sat_ex_num_only[16],
              prof_ethic_train_ex = sat_ex_num_only[17])


ex <- pdf_data(stu_exp_somd_link)[8]
ex1 <- ex[[1]]$text
ex1_1 <- str_subset(ex1, pattern = '\\%')



















