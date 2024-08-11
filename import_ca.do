**this file converts all the ca files in different years from excel to dta. 

//Home health agencies are not really all operating, sizes very different 

**first rename the excel data files downloaded from https://data.chhs.ca.gov/dataset/home-health-hospice-annual-utilization-report-complete-data-set  so that the name of files are the same across the years. 
**variables and variable names seem to change across the years, there are cross walks inside the documents 
**should make a distinction between not operating FAC_OPERATED_THS_YR = No and not responding (usually there is about 20% non-responding rate to the ca survey, which can be a problem, should check across Medicare cost reports )

**22-18 used the same format, different from 17 
*17 and before information in different sheets, need to merge together 
*minor changes everywhere 


**non response seemed very low previously 


cd "/Users/bubbles/Desktop/NH_data_&_application"

forvalues i = 18/22 {
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`i'_util_data_final.xlsx", sheet("Page 1-11") firstrow clear
	drop in 1/4 
	drop Description
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`i'.dta", replace 
	
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`i'_util_data_final.xlsx", sheet("NonResp 1-11") firstrow clear 
	drop in 1/4
	drop Description
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`i'_nonresp.dta", replace 
}



import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah17_util_data_final.xlsx", sheet("Section 1-4") firstrow clear //only take out the really important information for now. 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah17.dta", replace 
	
import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah17_util_data_final.xlsx", sheet("NonResp 1-4") firstrow clear 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah17_nonresp.dta", replace 
	

import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah16_util_data_final.xlsx", sheet("Section 1-4") firstrow clear //only take out the really important information for now. 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah16.dta", replace 
	
import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah16_util_data_final.xlsx", sheet("NonResp 1-4") firstrow clear 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah16_nonresp.dta", replace 
	
	

import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah15_util_data_final.xlsx", sheet("Sect 1-4") firstrow clear //only take out the really important information for now. 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah15.dta", replace 
	
import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah15_util_data_final.xlsx", sheet("NonResp Sect 1-4") firstrow clear 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah15_nonresp.dta", replace 	
	

import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah15_util_data_final.xlsx", sheet("Sect 1-4") firstrow clear //only take out the really important information for now. 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah15.dta", replace 
	
import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah15_util_data_final.xlsx", sheet("NonResp Sect 1-4") firstrow clear 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah15_nonresp.dta", replace 	
	

forvalues i = 11/14 {
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`i'_util_data_final.xlsx", sheet("Sec 1-4") firstrow clear
	drop in 1/3 
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`i'.dta", replace 
	
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`i'_util_data_final.xlsx", sheet("NonResp 1-4") firstrow clear 
	drop in 1/3
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`i'_nonresp.dta", replace 
}


//Sect became Section

import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah10_util_data_final.xlsx", sheet("Section 1-4") firstrow clear
drop in 1/3 
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah10.dta", replace 
	
import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah10_util_data_final.xlsx", sheet("NonResp 1-4") firstrow clear 
drop in 1/3
save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah10_nonresp.dta", replace 
	

//Sect became Section, xlsx became xls
	
foreach var in 07 08 09 {
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`var'_util_data_final.xls", sheet("Section 1-4") firstrow clear
	drop in 1/3 
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`var'.dta", replace 
	
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`var'_util_data_final.xls", sheet("NonResp 1-4") firstrow clear 
	drop in 1/3
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`var'_nonresp.dta", replace 
}
	
//drop 1/4 	

foreach var in 05 06 {
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`var'_util_data_final.xls", sheet("Section 1-4") firstrow clear
	drop in 1/4
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`var'.dta", replace 
	
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`var'_util_data_final.xls", sheet("NonResp 1-4") firstrow clear 
	drop in 1/4
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`var'_nonresp.dta", replace 
}

//Sections 1-4, Nonresponders no section, drop 1/3 

foreach var in 02 03 04 {
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`var'_util_data_final.xls", sheet("Sections 1-4") firstrow clear
	drop in 1/4
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`var'.dta", replace 
	
	import excel "/Users/bubbles/Desktop/hha_data/ca_hha/data/hhah`var'_util_data_final.xls", sheet("NonResponders") firstrow clear 
	drop in 1/4
	save "/Users/bubbles/Desktop/hha_data/ca_hha/output/hhah`var'_nonresp.dta", replace 
}





//to do calculation of number of HHAs 

//for now keep if HHA 
//responding - non-operating 
//total across two sheets --but with non responding hard to tell hospice vs home health accurately, have to do basically by name -but has id so can check across to other data sets like POS and medicare cost reports. 
//total across two sheets - not operating 


