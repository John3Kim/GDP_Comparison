# -*- coding: utf-8 -*-
"""
preprocessing_GDP_files.py
Created on Wed Jan  2 20:22:36 2019

@author: john3kim
Description: 
Preprocesses the data to ensure that the map data in the maps and mapsdata 
library in R and the GDP files are consistent with each other.

"""
import pandas as pd

GDP_data = pd.read_csv("C:/Users/johna/Desktop/GDP_Analytics/API_NY.GDP.MKTP.CD_DS2_en_csv_v2_10224782.csv")
GDP_data = GDP_data.drop(["Country Code","Indicator Name","Indicator Code"],axis=1)
country_data = pd.read_csv("C:/Users/johna/Desktop/GDP_Analytics/country_maps.csv")[["region","subregion"]].drop_duplicates()

# Remove entire regions in the GDP data 
regions_to_remove = ["Arab World","Central Europe and the Baltics", 
                    "Caribbean small states", "East Asia & Pacific (excluding high income)", 
                   "Early-demographic dividend","East Asia & Pacific", 
                   "Europe & Central Asia (excluding high income)", "Europe & Central Asia", 
                   "Euro area", "European Union","Fragile and conflict affected situations", 
                   "High income","Heavily indebted poor countries (HIPC)",
                   "IBRD only","IDA & IBRD total","IDA total","IDA blend",
                   "IDA only","Not classified","Least developed countries: UN classification",
                   "Low income","Lower middle income","Low & middle income",
                   "Late-demographic dividend","Middle East & North Africa",
                   "Middle income","Middle East & North Africa (excluding high income)",
                   "North America", "OECD members","Other small states",
                   "Pre-demographic dividend","West Bank and Gaza",
                   "Pacific island small states","Post-demographic dividend",
                   "Sub-Saharan Africa (excluding high income)","Sub-Saharan Africa",
                   "Small states", "East Asia & Pacific (IDA & IBRD countries)",
                   "Europe & Central Asia (IDA & IBRD countries)",
                   "Latin America & the Caribbean (IDA & IBRD countries)",
                   "Middle East & North Africa (IDA & IBRD countries)",
                  "South Asia (IDA & IBRD)", "Sub-Saharan Africa (IDA & IBRD countries)", 
                  "Upper middle income","World","Upper middle income","Latin America & Caribbean (excluding high income)", 
                   "Latin America & Caribbean", "South Asia"] 

GDP_data = GDP_data[~GDP_data.isin(regions_to_remove)].dropna(subset=["Country Name"])
GDP_data_names = GDP_data["Country Name"]
country_data_names = country_data["region"]

# Run different pandas queries to see which countries are different between 
GDP_notin_country = GDP_data_names[~GDP_data_names.isin(country_data_names)].drop_duplicates()
country_notin_gdp = country_data_names[~country_data_names.isin(GDP_data_names)].drop_duplicates()

# Resolve GDP_notin_country.  Use a dictionary to map out all the values 
''' 
Notes: 
Need to Resolve
Antigua and Barbuda are separate in maps -> Antigua, Barbuda
Channel Islands become Guernsey and Jersey
Gibraltar doesn't exist
Hong Kong resolves into China with region Hong Kong 
St. Kitts and Nevis resulves to Saint Kitts and Nevis
Macao SAR, China resolves as China with region Macao
Trinidad and Tobago resolves into Trinidad, Tobago
Tuvalu does not exist
St. Vincent and the Grenadines resolves to Saint Vincent, Grenadines 
British Virgin Islands resolves to Virgin Islands -> UK 
Virgin Islands (U.S.) resolves to Virgin Islands -> US
'''
GDP_resolve_dic={"Bahamas, The":"Bahamas",
                 "Brunei Darussalam":"Brunei",
                 "Cote d'Ivoire":"Ivory Coast", 
                 "Congo, Dem. Rep.":"Democratic Republic of the Congo", 
                 "Congo, Rep.":"Republic of Congo",
                 "Cabo Verde":"Cape Verde", 
                 "Egypt, Arab Rep.":"Egypt", 
                 "Micronesia, Fed. Sts.":"Micronesia", 
                 "United Kingdom":"UK", 
                 "Gambia, The":"Gambia",
                 "Iran, Islamic Rep.":"Iran",
                 "Kyrgyz Republic":"Kyrgyzstan",
                 "Korea, Rep.":"South Korea",
                 "Lao PDR":"Laos",
                 "St. Lucia":"Saint Lucia", 
                 "St. Martin (French part)":"Saint Martin", 
                 "Macedonia, FYR":"Macedonia", 
                 "Korea, Dem. People’s Rep.":"North Korea", 
                 "Russian Federation":"Russia", 
                 "Slovak Republic":"Slovakia", 
                 "Eswatini":"Swaziland", 
                 "Sint Maarten (Dutch part)":"Sint Maarten",
                 "Syrian Arab Republic":"Syria", 
                 "United States":"USA", 
                 "Venezuela, RB":"Venezuela", 
                 "Yemen, Rep.":"Yemen"}

for k,v in GDP_resolve_dic.items(): 
    GDP_data = GDP_data.replace(to_replace=k,value=v) 

# Double ckeck to see if resolved
GDP_data = GDP_data[~GDP_data.isin(regions_to_remove)].dropna(subset=["Country Name"])
GDP_data_names = GDP_data["Country Name"]
GDP_notin_country = GDP_data_names[~GDP_data_names.isin(country_data_names)].drop_duplicates()
country_notin_gdp = country_data_names[~country_data_names.isin(GDP_data_names)].drop_duplicates()

# Save it as a separate csv 
GDP_data.to_csv("C:/Users/johna/Desktop/GDP_Analytics/GDP_data_preprocessed.csv")

# Deal with case country_notin_gdp and the unresolved cases in Resolve GDP_notin_country

