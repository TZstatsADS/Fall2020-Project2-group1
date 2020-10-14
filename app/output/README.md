# Project 2: Shiny App Development

### Output folder

The output directory contains analysis output, processed datasets, logs, or other processed things.

The covid_zip_code.RData file is pre-processed data from the gloabl.R file. It combines data from the NYCHealth Open Data (data-by-modzcta.csv and recent-4-week-by-modzcta.csv) and well as zip code shape data from the 'tigris' package.

The collected_preprocessed_data.RData file contained pre-processed that includes both the covid_zip_code.RData above and data from the .csv files below. 

	center_zipcode.csv: geographical data of zip code 'centers' to orient map when rendering
	
	hospital.csv: data on NYC hospitals 
	
	hotels.csv: data on NYC hotels

	Restaurant_cleaned.csv: data on NYC restaurants 

	testingcenter_geocode.csv: data on NYC testing centers

We note several log files below, some used in the app itself:

	.DS_Store
	
	How.md: how to use this app

	latest.md: what the latest safety protocols are for COVID-19

	warning.md: advisory message

	Who.md: who can benefit from this app?