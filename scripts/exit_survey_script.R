# Creating function for exit surveys

somd15_exitsurvey <- function(link){
  pdf_file <- link
  text_data <- pdftools::pdf_text(pdf_file)
  
  pdf_pg2 <- pdftools::pdf_data(pdf_file)[2]
  pg2_pull <- pdf_pg2[[1]]$text
  pg2 <- stringr::str_subset(pg2_pull, pattern = '[:digit:]')
  
  df_pg2 <- tibble::tibble(number_respondent = pg2[c(2:4)],
                   number_stu_survey = pg2[c(6:8)],
                   resp_rate = pg2[c(10:12)])
  
  pdf_pg3 <- pdftools::pdf_data(pdf_file)[3]
  pg3_pull <- pdf_pg3[[1]]$text
  pg3 <- stringr::str_subset(pg3_pull, pattern = '\\%')
  
  df_pg3 <- tibble::tibble(fac_qual_ex = pg3[1],
                   pro_qual_ex = pg3[2],
                   money_sup_ex = pg3[3],
                   field_dev_pace_ex = pg3[4],
                   advising_qual_ex = pg3[5],
                   smart_community_Ex = pg3[6],
                   prof_dev_ex = pg3[7],
                   equipment_ex = pg3[8],
                   grad_involve_ex = pg3[9],
                   research_opp_ex = pg3[10],
                   grad_fair_assess_ex = pg3[11],
                   promote_inclu_ex = pg3[12],
                   grant_train_ex = pg3[13],
                   teach_prep_ex = pg3[14],
                   grad_clear_assess_ex = pg3[15],
                   inter_sup_ex = pg3[16],
                   prof_ethic_train_ex = pg3[17]) %>% 
    tibble::rowid_to_column()
  
  pdf_pg4 <- pdftools::pdf_data(pdf_file)[4]
  pg4_pull <- pdf_pg4[[1]]$text
  pg4 <- stringr::str_subset(pg4_pull, pattern = '\\%')
  
  df_pg4 <- tibble::tibble(fac_qual_ex_good = pg4[1],
                   pro_qual_ex_good = pg4[2],
                   money_sup_ex_good = pg4[3],
                   field_dev_pace_ex_good = pg4[4],
                   advising_qual_ex_good = pg4[5],
                   smart_community_ex_good = pg4[6],
                   prof_dev_ex_good = pg4[7],
                   equipment_ex_good = pg4[8],
                   grad_involve_ex_good = pg4[9],
                   research_opp_ex_good = pg4[10],
                   grad_fair_assess_ex_good = pg4[11],
                   promote_inclu_ex_good = pg4[12],
                   grant_train_ex_good = pg4[13],
                   teach_prep_ex_good = pg4[14],
                   grad_clear_assess_ex_good = pg4[15],
                   inter_sup_ex_good = pg4[16],
                   prof_ethic_train_ex_good = pg4[17]) %>% 
    tibble::rowid_to_column()
  
  pdf_pg5 <- pdftools::pdf_data(pdf_file)[5]
  pg5_pull <- pdf_pg5[[1]]$text
  pg5 <- stringr::str_subset(pg5_pull, pattern = '\\%')
  
  df_pg5 <- tibble::tibble(fac_qual_fair_poor = pg5[1],
                   pro_qual_fair_poor = pg5[2],
                   money_sup_fair_poor = pg5[3],
                   field_dev_pace_fair_poor = pg5[4],
                   advising_qual_fair_poor = pg5[5],
                   smart_community_fair_poor = pg5[6],
                   prof_dev_fair_poor = pg5[7],
                   equipment_fair_poor = pg5[8],
                   grad_involve_fair_poor = pg5[9],
                   research_opp_fair_poor = pg5[10],
                   grad_fair_assess_fair_poor = pg5[11],
                   promote_inclu_fair_poor = pg5[12],
                   grant_train_fair_poor = pg5[13],
                   teach_prep_fair_poor = pg5[15],
                   grad_clear_assess_fair_poor = pg5[15],
                   inter_sup_fair_poor = pg5[16],
                   prof_ethic_train_fair_poor = pg5[17]) %>% 
    tibble::rowid_to_column()
  
  pdf_pg6 <- pdftools::pdf_data(pdf_file)[6]
  pg6_pull <- pdf_pg6[[1]]$text
  pg6 <- stringr::str_subset(pg6_pull, pattern = '\\%')
  
  df_pg6 <- tibble::tibble(encourage_agree = pg6[1],
                   idea_resp_agree = pg6[2],
                   construct_feed_agree = pg6[3],
                   time_feed_agree = pg6[4],
                   avail_agree = pg6[5],
                   career_sup_agree = pg6[6],
                   stu_equit_agree = pg6[7],
                   ethic_emp_agree = pg6[8],
                   help_secure_fund_agree = pg6[9],
                   help_prof_dev_agree = pg6[10],
                   publish_help_agree = pg6[11],
                   encourage_intel_diff_agree = pg6[12],
                   comfort_talk_issue_agree = pg6[13]) %>% 
    tibble::rowid_to_column()
  
  pdf_pg7 <- pdftools::pdf_data(pdf_file)[7]
  pg7_pull <- pdf_pg7[[1]]$text
  pg7 <- stringr::str_subset(pg7_pull, pattern = '\\%')
  
  df_pg7 <- tibble::tibble(encourage_disagree = pg7[1],
                   idea_resp_disagree = pg7[2],
                   construct_feed_disagree = pg7[3],
                   time_feed_disagree = pg7[4],
                   avail_disagree = pg7[5],
                   career_sup_disagree = pg7[6],
                   stu_equit_disagree = pg7[7],
                   ethic_emp_disagree = pg7[8],
                   help_secure_fund_disagree = pg7[9],
                   help_prof_dev_disagree = pg7[10],
                   publish_help_disagree = pg7[11],
                   encourage_intel_diff_disagree = pg7[12],
                   comfort_talk_issue_disagree = pg7[13]) %>% 
    tibble::rowid_to_column()
  
  pdf_pg8 <- pdftools::pdf_data(pdf_file)[8]
  pg8_pull <- pdf_pg8[[1]]$text
  pg8 <- stringr::str_subset(pg8_pull, pattern = '\\%')
  
  df_pg8 <- tibble::tibble(collegial_strong = pg8[1],
                   encouraging_strong = pg8[2],
                   supportive_strong = pg8[3],
                   intel_open_strong = pg8[4],
                   inter_open_strong = pg8[5],
                   inclu_stu_color_strong = pg8[6],
                   inclu_gender_strong = pg8[7],
                   inclu_intern_stu_strong = pg8[8],
                   inclu_stu_disab_strong = pg8[9],
                   inclu_first_gen_strong = pg8[10],
                   inclu_stu_sex_orient_strong = pg8[11]) %>% 
    tibble::rowid_to_column()
  
  pdf_pg9 <- pdftools::pdf_data(pdf_file)[9]
  pg9_pull <- pdf_pg9[[1]]$text
  pg9 <- stringr::str_subset(pg9_pull, pattern = '\\%')
  
  df_pg9 <- tibble::tibble(collegial_agree = pg9[1],
                   encouraging_agree = pg9[2],
                   supportive_agree = pg9[3],
                   intel_open_agree = pg9[4],
                   inter_open_agree = pg9[5],
                   inclu_stu_color_agree = pg9[6],
                   inclu_gender_agree = pg9[7],
                   inclu_intern_stu_agree = pg9[8],
                   inclu_stu_disab_agree = pg9[9],
                   inclu_first_gen_agree = pg9[10],
                   inclu_stu_sex_orient_agree = pg9[11]) %>% 
    tibble::rowid_to_column()
  
  pdf_pg10 <- pdftools::pdf_data(pdf_file)[10]
  pg10_pull <- pdf_pg10[[1]]$text
  pg10 <- stringr::str_subset(pg10_pull, pattern = '\\%')
  
  df_pg10 <- tibble::tibble(collegial_disagree = pg10[1],
                   encouraging_disagree = pg10[2],
                   supportive_disagree = pg10[3],
                   intel_open_disagree = pg10[4],
                   inter_open_disagree = pg10[5],
                   inclu_stu_color_disagree = pg10[6],
                   inclu_gender_disagree = pg10[7],
                   inclu_intern_stu_disagree = pg10[8],
                   inclu_stu_disab_disagree = pg10[9],
                   inclu_first_gen_disagree = pg10[10],
                   inclu_stu_sex_orient_disagree = pg10[11]) %>% 
    tibble::rowid_to_column()
  
  df_college <- full_join(df_pg3, df_pg4) %>% 
    full_join(df_pg5) %>% 
    full_join(df_pg6) %>%
    full_join(df_pg7) %>%
    full_join(df_pg8) %>%
    full_join(df_pg9) %>%
    full_join(df_pg10)
  
  return(list(df_pg2, df_college))
  
}


somd15 <- somd_exitsurvey(link = 'C:/Users/cpppe/Desktop/github_projects/exitsurveys/pdf_data/exit_surveys/student_experience_survey/2015/2015-SOMD-Grad-experience-Survey-Report.pdf')
somd15

somd15[[1]]$program <- c('Music & Dance', 'Dance', 'Music')

somd15[[2]]$program <- 'Music'

somd_data <- somd15[[2]]






somd12 <- somd_exitsurvey(link = 'C:/Users/cpppe/Desktop/github_projects/exitsurveys/pdf_data/exit_surveys/student_experience_survey/2012/2012-somd-grad-experience-survey-report.pdf')
somd12



