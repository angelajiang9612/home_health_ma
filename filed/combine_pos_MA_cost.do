clear all
set more off
set maxvar 32767
version 17.0
set seed 0102
macro drop _all

cd "/Users/bubbles/Desktop/HomeHealth/output/"

use pos92-22.dta, clear
//pos has employment information too, should try the ones in POS. 

merge 1:1 prov_number year using S_all_final.dta, force 

//then generate by county values 









use S_all_final.dta, clear

replace zip_code =substr(zip_code,1,5)

merge 



//calculate HHI index 


//median unduplicated persons, mean unduplicated persons (TM and others), total unduplicated persons , and the same for number of nurses and therapists by county. 



use merged_pos_MA.dta, clear



/*




//zip code to state-countyfips 2010-2019

forvalues i= 2010(1)2019 {
	import excel "/Users/bubbles/Desktop/hha_data/geo_crosswalk/ZIP_COUNTY_03`i'.xlsx", sheet("ZIP_COUNTY_03`i'") firstrow clear	
	keep ZIP COUNTY
	gen year = `i' 
	save crosswalk_`i'.dta, replace 
}

use crosswalk_2010.dta, clear 

forvalues i= 2011(1)2019 {
	append using crosswalk_`i'.dta, force 
}

rename (ZIP COUNTY) (zip county)
save crosswalk_10-19.dta, replace 

