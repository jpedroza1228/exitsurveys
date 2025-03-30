# packages
import pandas as pd
from matplotlib import rcParams 
import numpy as np
import streamlit as st
import plotnine as pn
import plotly.express as px
from great_tables import GT
from janitor import clean_names
import seaborn as sns

pd.set_option('mode.copy_on_write', True)
pd.set_option('display.max_columns', None)
rcParams.update({'savefig.bbox': 'tight'})

# data
# @st.cache_data
grad = pd.read_csv("https://raw.githubusercontent.com/jpedroza1228/exitsurveys/main/data/full_grad.csv").clean_names(case_type = 'snake')

# Program Selection/Data Manipulation
program_df = grad[grad.columns[grad.columns.str.contains('year|program|_ex$|ex_good$|_fair_poor$')]]

unique_program_var = program_df.rename(columns = lambda x: pd.Series(x).str.replace(r'(_ex_good|_fair_poor|_ex)$', '', regex = True).iloc[0]).columns.unique()
unique_program_var = unique_program_var.tolist()[2:]

all_programs = program_df['program'].unique().tolist()

# all_programs_df = pd.DataFrame({'program_var': all_programs})
# all_programs_df['program'] = all_programs_df['program_var'].str.title().str.replace('_', ' ')

program_title = ['Faculty Quality', 'Program Quality', 'Financial Support for Grad Students', 'Keeping up With Field', 'Academic Guidance Quality', 'Intellectual Community', 'Career/Professional Development', 'Facilities/Equipment', 'Student Involvement in Program Decisions', 'Research Opportunities', 'Evaluation Criteria Fairness', 'Diversity & Inclusive Community', 'Grant/Funding Training', 'Preparation for Teaching', 'Evaluation Criteria Clarity', 'Interdisciplinary Support', 'Professional Ethics Training']

program_title_df = pd.DataFrame({'var_name': unique_program_var, 'title_name': program_title})

# Sidebar
st.sidebar.title("Select Program and Variable of Interest")
# st.sidebar.write("Customize your options here!")

# functions
def remove_excellent_good(df, var_string, long = False):
  if long == False:
    df = df.loc[:, df.columns.str.contains(f'year|program|{var_string}')]

    df[f'{var_string}_good'] = df.loc[:, df.columns.str.contains('_ex_good$')].squeeze() - df.loc[:, df.columns.str.contains('_ex$')].squeeze()

    df = df.drop(columns = f'{var_string}_ex_good')

    return df

  elif long == True:
    df = df.loc[:, df.columns.str.contains(f'year|program|{var_string}')]

    df[f'{var_string}_good'] = df.loc[:, df.columns.str.contains('_ex_good$')].squeeze() - df.loc[:, df.columns.str.contains('_ex$')].squeeze()

    df = df.drop(columns = f'{var_string}_ex_good')

    df = df.melt(id_vars = ['year', 'program'], value_vars = df.loc[:, df.columns.str.contains(f'{var_string}')])

    return df

def plotly_stacked(df, var_string, program_list):

  ex_var = f'{var_string}_ex'
  good_var = f'{var_string}_good'
  fairpoor_var = f'{var_string}_fair_poor'

  plot_names = {fairpoor_var: 'Fair Poor', good_var: 'Good', ex_var: 'Excellent'}

  df = df.loc[df['program'].isin(program_list)]

  df['program'] = df['program'].str.title().str.replace('_', ' ')
  df['variable'] = pd.Categorical(df['variable'], categories=[fairpoor_var, good_var, ex_var])

  title = program_title_df.loc[program_title_df['var_name'] == f'{var_string}', 'title_name'].iloc[0]

  color_map = {fairpoor_var: '#a1c9f4', good_var: '#ffb482', ex_var: '#8de5a1'}

  pro_fig = px.bar(df, x = 'program', y = 'value', color = 'variable', facet_col = 'year', category_orders = {'variable': [fairpoor_var, good_var, ex_var]}, color_discrete_map = color_map, title = title)
  pro_fig.for_each_xaxis(lambda xaxis: xaxis.update(title = ''))
  pro_fig.for_each_trace(lambda t: t.update(name = plot_names[t.name], legendgroup = plot_names[t.name], hovertemplate = t.hovertemplate.replace(t.name, plot_names[t.name])))
  pro_fig.update_layout(legend_traceorder = 'reversed')

  return pro_fig

def var_table(df, var_string, program_list):

  df = df.round(2).sort_values(['program', 'year'], ascending = True)

  df = df.loc[df['program'].isin(program_list)]

  df['program'] = df['program'].str.title().str.replace('_', ' ')

  df = df.rename(columns = {'year': 'Year', 'program': 'Program', f'{var_string}_ex': 'Excellent', f'{var_string}_good': 'Good', f'{var_string}_fair_poor': 'Fair Poor'})

  return df
  # table = (
  #     GT(df)
  #     .tab_header(title = f'{title}')
  #     .cols_move_to_start(columns = ['year', 'program', f'{var_string}_ex', f'{var_string}_good', f'{var_string}_fair_poor'])
  #     .cols_label(**{'year': 'Year', 'program': 'Program', f'{var_string}_ex': 'Excellent', f'{var_string}_good': 'Good', f'{var_string}_fair_poor': 'Fair Poor'})
  #     )
  # 
  # return table

# Sidebar selection
selected_programs = st.sidebar.multiselect("Select or Compare Programs", all_programs, default = all_programs[0])
selected_var = st.sidebar.selectbox("Select Variable", unique_program_var)

# st.sidebar.dataframe(all_programs_df)
st.sidebar.dataframe(program_title_df)

table_title = program_title_df.loc[program_title_df['var_name'] == f'{selected_var}', 'title_name'].iloc[0]

# datasets for use
wide = remove_excellent_good(program_df, selected_var, long = False)
long = remove_excellent_good(program_df, selected_var, long = True) 

# choose the variable to save as the index value for 
# selected_index = unique_program_var.index(selected_var)
# program_var_num = unique_program_var[selected_index]

# Table
st.write(f'### Differences in {table_title} Between University Programs')
st.table(var_table(wide, selected_var, selected_programs))

# Plot
st.plotly_chart(plotly_stacked(long, selected_var, selected_programs))

# Run this script with: streamlit run script_name.py