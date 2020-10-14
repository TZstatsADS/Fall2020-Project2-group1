# Project 2: Shiny App Development

### Data folder

The data directory contains data used in the analysis. This is treated as read only; in paricular the R/python files are never allowed to write to the files in here. Depending on the project, these might be csv files, a database, and the directory itself may have subdirectories.

The coronavirus-data-master folder, provided by NYCHealth Open Data was used for the Maps and Averages tabs. Main files used where data-by-modzcta.csv and recent-4-week-by-modzcta.csv. Please see the subfolders for a more detail description of these files.

We note several single .csv files of raw data below: 

	combine_data_res.csv: processed data of NYC restaurants (due to the large size of the original file, we are unable to include the original NYC restaurant dataset)

	Res_cleaned_Or.csv: processed data of NYC restaurants (due to the large size of the original file, we are unable to include the original NYC restaurant dataset)

	testingcenter.csv: raw data on NYC testing centers

	us-zip-code-latitude-and-longitude.csv: contains geographical information on zipcodes to help center the map

Temporary log files:

	.DS_Store