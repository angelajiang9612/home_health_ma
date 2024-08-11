clear all
set more off
set maxvar 32767
version 17.0
set seed 0102
macro drop _all

local data_output  "/Users/bubbles/Desktop/HomeHealth/output/"
local data_input "/Users/bubbles/Desktop/hha_data/cost_hha/data/"


//rough logic 
set rmsg on


forvalues i = 1994/2019 { //stop at 2019 for now, 2020 onwards new data format 
	
	//alpha file 
	use `data_input'hha_alpha1728_94_`i'_long.dta, replace 
	destring rpt_rec_num, replace 
	rename alphnmrc_itm_txt _ 
	keep if inlist(substr(wksht_cd, 1, 1),"S") //keep only those variables in S section 
	gen variable_code = wksht_cd + line_num + clmn_num //generates unique variable code 
	drop wksht_cd line_num clmn_num //need to drop these because they are not constant within rpt_rec_num
	reshape wide _ , i(rpt_rec_num) j(variable_code) string 
	bys rpt_rec_num: gen dup = cond(_N==1,0,_n)
	drop if dup>0 //drop observations with duplicates
	drop dup
	tempfile alpha_`i'
	save `alpha_`i''

	//nmrc file 
	use `data_input'hha_nmrc1728_94_`i'_long.dta, replace 
	destring rpt_rec_num, replace 
	rename itm_val_num _ //string variable 
	keep if inlist(substr(wksht_cd, 1, 1),"S") //keep only those variables in S section 
	gen variable_code = wksht_cd + line_num + clmn_num 
	drop wksht_cd line_num clmn_num 
	reshape wide _ , i(rpt_rec_num) j(variable_code) string 
	bys rpt_rec_num: gen dup = cond(_N==1,0,_n)
	drop if dup>0 //drop observations with duplicates
	drop dup
	tempfile nmrc_`i'
	save `nmrc_`i''

	//merge with rpt file 
	use `data_input'hha_rpt1728_94_`i'.dta, replace
	destring rpt_rec_num, replace 
	merge 1:1 rpt_rec_num using `alpha_`i'' //not everything in master is matched, check reason 
	drop _merge 
	merge 1:1 rpt_rec_num using `nmrc_`i''
	drop _merge 
	gen year = `i'
	drop rpt_rec_num //this is no longer useful 
	save `data_output'`i'_S, replace 

}

//converting to long form 

use  "/Users/bubbles/Desktop/HomeHealth/output/1994_S", clear 
************************************************

local data_output  "/Users/bubbles/Desktop/HomeHealth/output/"

forvalues i = 1994/2018 { 
	append using `data_output'`i'_S
	quietly describe 
	di r(k)
} //it seems like the number of variables in section S increased from 167 to 764 over the years 

sort prvdr_num year 

order prvdr_num year _*

drop _S4* _S5* _S6*  //only 319 variables left 


npresent, min(`=ceil(_N/5)') // dropped variables missing more than 80% of the time, 146 left //can edit these and have a look 
keep `r(varlist)'

        
//basically s4 s5 s6 do not apply to most HHAs


preserve
describe, replace clear
list 
export excel using myfile.xlsx, replace first(var)
restore


//https://stackoverflow.com/questions/49850210/excel-formula-to-split-cell-text-based-on-char-count 

use "/Users/bubbles/Desktop/HomeHealth/output/S_all", clear
