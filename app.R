library(shiny)
library(tidyverse)
library(rsconnect)

theme_set(theme_light())

grad <- read_csv("https://raw.githubusercontent.com/jpedroza1228/exitsurveys/main/data/student_experience.csv") %>% 
  janitor::clean_names() %>% 
  mutate(program = str_to_title(program),
         program = str_replace_all(program, pattern = '_', " "))

grad_require <- grad %>%
  select(1:54)

grad_inclusive <- grad %>% 
  select(1:3,
         81:113)

# grad_long <- grad_long %>%
#   pivot_longer(4:29, names_to = "advisor", values_to = "advisor_values")

# grad_long <- grad_long %>% 
#   pivot_longer(4:36, names_to = "inclusive", values_to = "inclusive_values")


grad_require %>% 
  pivot_longer(c(-year, -program, -number_respondents),
               names_to = 'program_req',
               values_to = 'program_req_values') %>% 
  filter(str_detect(program_req, 'fac_qual'))


#app stuff
ui <- fluidPage(
  titlePanel(title = 'University of Oregon (UO) Graduate Student Experiences'),
  
  sidebarLayout(
    sidebarPanel(
      selectInput('program',
                     'Choose 1st Program to Compare',
                     unique(grad$program),
                     multiple = FALSE), 
      selectInput('program2',
                  'Choose 2nd Program to Compare',
                  unique(grad$program),
                  multiple = FALSE), 
      selectInput('program_req_type',
                  'Program Topic',
                  choices = c('Quality of Faculty' = 'fac_qual',
                              'Program Quality' = 'pro_qual',
                              'Financial Support' = 'money_sup',
                              'Keeping up in Field' = 'field_dev_pace',
                              'Quality of Advising' = 'advising_qual',
                              'Intellectual Community' = 'smart_community',
                              'Professional Development' = 'prof_dev',
                              'Space, Facilities, Equipment' = 'equipment',
                              'Involving Students in Program Decisions' = 'grad_involve',
                              'Research Opportunities' = 'research_opp',
                              'Fairness in Evaluation Criteria of Students' = 'grad_fair_assess',
                              'Promoting Diversity & Inclusivity' = 'promote_inclu',
                              'Grant Training' = 'grant_train',
                              'Preparation of Teaching' = 'teach_prep',
                              'Clarity in Evaluation Criteria of Students' = 'grad_clear_assess',
                              'Interdisciplinary Inquiry Support' = 'inter_sup',
                              'Training about Ethics' = 'prof_ethic_train')),
      selectInput('program_inclu_type',
                  'Program Inclusivity Topic',
                  choices = c('Collegial' = 'collegial',
                              'Encouraging' = 'encouraging',
                              'Supportive' = 'supportive',
                              'Intellectually Open to Different Approaches' = 'intel_open',
                              'Open to Interdisciplinary Inquiry' = 'inter_open',
                              'Inclusive of Students of Color' = 'inclu_stu_color',
                              'Inclusive by Gender' = 'inclu_gender',
                              'Inclusive of International Students' = 'inclu_intern_stu',
                              'Inclusive of Students with Disabilities' = 'inclu_stu_disab',
                              'Inclusive of First-Gen Students' = 'inclu_first_gen',
                              'Inclusive of Students of all Sexual Orientations' = 'inclu_stu_sex_orient'))
                  ),
    mainPanel(
      tabsetPanel(
        type = 'tabs',
        tabPanel('Program', plotOutput('plot1')),
        tabPanel('Inclusivity', plotOutput('plot2'))
        )
      )
  )
)



server <- function(input, output, session){

  grad_re <- reactive({
    grad_require[paste0({{input$program_req_type}}, '_good')] <-  grad_require[paste0({{input$program_req_type}}, '_ex_good')] -
      grad_require[paste0({{input$program_req_type}}, '_ex')]
    
    grad_require %>% 
      pivot_longer(c(-year, -program, -number_respondents),
                   names_to = 'program_req',
                   values_to = 'program_req_values') %>% 
      filter(str_detect(program_req, input$program_req_type)) %>% 
      filter(input$program == program |
               input$program2 == program) %>% # issue here where it splits the two programs between the responses
      filter(program_req != paste0(input$program_req_type,
                                   '_ex_good')) %>% 
      mutate(program_req = fct_relevel(program_req,
                                       c(paste0(input$program_req_type, '_ex'),
                                         paste0(input$program_req_type, '_good'),
                                         paste0(input$program_req_type, '_fair_poor'))))
             # program_req = recode(program_req, #not sure why this isn't working
             #                      'Excellent' = paste0(input$program_req_type, '_ex'),
             #                      'Good' = paste0(input$program_req_type, '_good'),
             #                      'Fair or Poor' =  paste0(input$program_req_type, '_fair_poor')))
  })
  
  grad_inc <- reactive({
    grad_inclusive[paste0({{input$program_inclu_type}}, '_strongly_agree')] <-  grad_inclusive[paste0({{input$program_inclu_type}}, '_agree')] -
      grad_inclusive[paste0({{input$program_inclu_type}}, '_strong')]

    grad_inclusive %>%
      pivot_longer(c(-year, -program, -number_respondents),
                   names_to = 'program_inclu',
                   values_to = 'program_inclu_values') %>%
      filter(str_detect(program_inclu, input$program_inclu_type)) %>%
      filter(input$program == program |
               input$program2 == program) %>% # issue here where it splits the two programs between the responses
      filter(program_inclu != paste0(input$program_inclu_type,
                                   '_strong')) %>%
      mutate(program_inclu = fct_relevel(program_inclu,
                                       c(paste0(input$program_inclu_type, '_strongly_agree'),
                                         paste0(input$program_inclu_type, '_agree'),
                                         paste0(input$program_inclu_type, '_disagree'))))
  })
  
  output$plot1 <- renderPlot({
    ggplot(data = grad_re(),
           aes(program, program_req_values,
                 fill = program_req)) +
      geom_bar(position = 'fill',
               stat = 'identity') + 
      facet_grid(rows = vars(year)) +
      coord_flip() +
      labs(x = '',
           y = "Percent of Grad Students' Experiences with Program") +
      scale_y_continuous(breaks = c(.00, .10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00),
                       labels = c('0', '10', '20', '30', '40', '50',
                                  '60', '70', '80', '90', '100')) +
      theme(legend.title = element_blank(),
            legend.position = 'bottom',
            legend.text = element_text(size = 20),
            axis.text = element_text(size = 20),
            strip.text = element_text(size = 20),
            axis.title = element_text(size = 20)) +
      scale_fill_manual(values = c('#669b3e', '#398b98', '#ea5227'))
  })
  
  output$plot2 <- renderPlot({
    ggplot(data = grad_inc(),
           aes(program, program_inclu_values,
               fill = program_inclu)) +
      geom_bar(position = 'fill',
               stat = 'identity') +
      facet_grid(rows = vars(year)) +
      coord_flip() +
      labs(x = '',
           y = "Percent of Grad Students' Experiences with Program") +
      scale_y_continuous(breaks = c(.00, .10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00),
                         labels = c('0', '10', '20', '30', '40', '50',
                                    '60', '70', '80', '90', '100')) +
      theme(legend.title = element_blank(),
            legend.position = 'bottom',
            legend.text = element_text(size = 20),
            axis.text = element_text(size = 20),
            strip.text = element_text(size = 20),
            axis.title = element_text(size = 20)) +
      scale_fill_manual(values = c('#669b3e', '#398b98', '#ea5227'))
  })
  
}

shinyApp(ui, server)
# stopApp()

rsconnect::deployApp('path/to/your/app')
