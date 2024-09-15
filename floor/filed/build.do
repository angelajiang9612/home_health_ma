//build dataset close to the Cabral et al dta//
//rate data from https://www.cms.gov/medicare/payment/medicare-advantage-rates-statistics/ratebooks-supporting-data
//https://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/. (CPS U)

//www.ers.usda.gov/data-products/rural-urban-continuum-codes/ --only once in 10 years, county level //rural urban code data 

//https://seer.cancer.gov/seerstat/variables/countyattribs/ruralurban.html //description of code



cd "/Users/bubbles/Desktop/hha_data/ratebook/clean"


local cpi 160.5 163.0 166.6 172.2 177.1 179.9 184.0  // cpi from 1997-2003, use 2000 year as based year 

import delimited "rate1997.csv", clear 
rename partaagedrate part_a_aged 
rename partbagedrate part_b_aged
rename ssastatecountycode county_ssa
gen year = 1997
gen base = part_a_aged + part_b_aged
replace base = base*172.2/160.5 //this generates what is actually paid to the MA in this county, adjusted to 2000 value like Cabral et al. The exact same numbers. 
keep state county_ssa base year
order county_ssa year base state 
save "/Users/bubbles/Desktop/HomeHealth/temp/rate1997.dta", replace 


import delimited "rate1998.csv", clear 
rename partaagedrate part_a_aged 
rename partbagedrate part_b_aged
rename ssastatecountycode county_ssa
gen year = 1998
gen base = part_a_aged + part_b_aged
replace base = base*172.2/163.0
keep state county_ssa base year
order county_ssa year base state 
save "/Users/bubbles/Desktop/HomeHealth/temp/rate1998.dta", replace 


import delimited "rate1999.csv", clear 
rename partaagedrate part_a_aged 
rename partbagedrate part_b_aged
rename ssastatecountycode county_ssa
gen year = 1999
gen base = part_a_aged + part_b_aged
replace base = base*172.2/166.6
keep state county_ssa base year
order county_ssa year base state 
save "/Users/bubbles/Desktop/HomeHealth/temp/rate1999.dta", replace 


import delimited "rate2000.csv", clear //Cabral et al did not use the other adjustments noted in the csv form 

gen row=_n
drop if inrange(row,1,10)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2000
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2000.dta", replace 

import delimited "rate2001.csv", clear //Cabral et al did not use the other adjustments noted in the csv form, not sure why this is the correct thing to do. 

gen row=_n
drop if inrange(row,1,9)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2001
replace base = base*172.2/177.1
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2001.dta", replace 

import delimited "rate2002.csv", clear //Cabral et al did not use the other adjustments noted in the csv form 
gen row=_n
drop if inrange(row,1,10)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2002
replace base = base*172.2/179.9
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2002.dta", replace 

import delimited "rate2003.csv", clear //Cabral et al did not use the other adjustments noted in the csv form 
gen row=_n
drop if inrange(row,1,16)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2003
replace base = base*172.2/184.0 
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2003.dta", replace 

//

use "/Users/bubbles/Desktop/HomeHealth/temp/rate1997.dta", replace 

forvalues i = 1998(1)2003 {
	append using  "/Users/bubbles/Desktop/HomeHealth/temp/rate`i'.dta"
}


sort county_ssa year

save "/Users/bubbles/Desktop/HomeHealth/temp/rate97-03.dta", replace 

use "/Users/bubbles/Desktop/HomeHealth/temp/rate97-03.dta", clear

/*

///////testing using my own urban or rural definition///

import excel "/Users/bubbles/Desktop/hha_data/misc_duggan/ruralurbancodes2003.xls", sheet("beale03") firstrow clear

destring, replace

rename RuralurbanContinuumCode code_93
rename E code_03

gen urban_93 =inlist(code_93,0,1,2) 
gen urban_03 =inlist(code_03,1,2) //what is urban does change over time. 
gen urban_99 = urban_93 //93 seems like a good match for the 1999 data Cabral used.
replace urban_99=1 if inlist(code_93,3) & Population >= 250000 //if already metro area in 1993 but population not large enough at the time.  
//but 2003 might be a better match for 2001 than 1999...so probably can just use 2003 one. 

rename FIPSCode countyFIPS
keep countyFIPS CountyName urban_93 urban_99 urban_03

merge 1:n countyFIPS using "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta"

drop merge 

assert urbanMSA1999 == urban_99 if year==1999 //some not the same, not sure if enough to affect results, use Cabral's for now. 

*/ 
 
use "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta", clear

//for enrollment information they used the last quarter/last month of the year, can get exact results if used that information. 
 
//generate the nominal value of base 

gen base_nominal = base_ if year==2000 
replace base_nominal = base_*160.5/172.2 if year ==1997
replace base_nominal = base_*163.0/172.2 if year ==1998
replace base_nominal = base_*166.6/172.2 if year ==1999
replace base_nominal = base_*177.1/172.2 if year ==2001
replace base_nominal = base_*179.9/172.2 if year ==2002
replace base_nominal = base_*184.0/172.2 if year ==2003

bys countySSA: egen base_2001_nominal = total(base_nominal*(year==2001))

gen binding2001_test =1 if urbanMSA1999==1 & base_2001_nominal==525 //they used the nominal value change to check binding or not
replace binding2001_test =1 if urbanMSA1999==0 & base_2001_nominal==475
replace binding2001_test =0 if missing(binding2001_test)

assert binding2001_test==binding2001 //assertion true 



//generating the distance variable 

/////generate floor and payment in the absence of floor variables for all periods. 

//try nominal first.


gen floor = base_nominal if binding2001 ==1 & year>=2001
replace floor = base_n/1.02 if binding2001 ==1 & year ==2000 
replace floor = base_nominal/(1.02)^2 if binding2001 ==1 & year ==1999
replace floor = base_nominal/(1.02)^3 if binding2001 ==1 & year ==1998
replace floor = base_nominal/(1.02)^4 if binding2001 ==1 & year ==1997

gen base_no_floor = base_nominal if binding2001==0 
gen base_no_floor = base_nominal 










https://www.statalist.org/forums/forum/general-stata-discussion/general/1725042-wooldid-estimation-of-diff-in-diff-treatment-effects-with-staggered-treatment-onset-using-heterogeneity-robust-twfe-regressions? 











/*
forvalues i = 1997(1)1997 {
	import delimited "rate`i'.csv", clear 
	rename partaagedrate part_a_aged 
	rename partbagedrate part_b_aged
	rename ssastatecountycode county_ssa
	gen year = `i'
	gen base = part_a_aged + part_b_aged
	replace base = base*172.2/160.5
	keep state county_ssa base year
	order county_ssa year base state 
	save "/Users/bubbles/Desktop/HomeHealth/temp/rate`i'.dta", replace 
}



