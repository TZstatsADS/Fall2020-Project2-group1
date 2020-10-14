# Project 2: Shiny App Development

### Output folder

The output directory contains analysis output, processed datasets, logs, or other processed things.

The covid_zip_code.RData file is pre-processed data from the gloabl.R file. It combines data from the NYCHealth Open Data (data-by-modzcta.csv and recent-4-week-by-modzcta.csv) and well as zip code shape data from the 'tigris' package.

The collected_preprocessed_data.RData file contained pre-processed that includes both the covid_zip_code.RData above and data from the .csv files below. 

	hospital.csv: data on NYC hospitals 
	
	hotels.csv: data on NYC hotels

	Restaurant_cleaned.csv: data on NYC restaurants 

	testingcenter_geocode.csv: data on NYC testing centers

We note several log files below:

	.DS_Store
	
	How.md: how to use this app

	Welcome.md: welcome message

	Who.md: who can benefit from this app?