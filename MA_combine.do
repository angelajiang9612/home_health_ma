//imports and cleans data on MA penetration by county, combines to get panel for MA penetration 1993-2022. 

//for now ignore the under 11s, in future could distribute evenly as suggested by the data provider. 

//state, state fips, county, county_fips year 

//2008-2023 first 

cd  "/Users/bubbles/Desktop/HomeHealth/output/"

forvalues i = 2008/2023 { 
	import delimited "/Users/bubbles/Desktop/MA_06/MA_`i'.csv", clear 
	gen year = `i'
	di `i'
	destring, replace 
	describe 
	save MA_`i'.dta, replace 
}

use MA_2008.dta, clear 
drop if fipsst=="UK" //tidying up 
drop if fips =="UK"
destring, replace 
save MA_2008.dta, replace 

use MA_2009.dta, clear 
drop if fipsst=="UK"
drop if fips =="UK"
destring, replace 
save MA_2009.dta, replace 

use MA_2023.dta, clear 

forvalues i = 2008/2022 { 
	di `i'
	append using MA_`i'.dta, force
}

save MA_merged.dta, replace 

////////////////////////////////////\
use MA_merged.dta, clear 
sort fips year

drop if countyname == "Pending County Designation"

statastates, name(statename) nogenerate

rename statename state_name 

rename state_abbrev state

replace state = "PR" if state_name == "PUERTO RICO"
replace state_fips = 72 if state_name == "PUERTO RICO"

//convert string variables to numeric 

destring penetration, replace  ignore("%")
destring eligibles, replace ignore(",")
gen small = (enrolled =="*")
destring enrolled, replace ignore("," "*")

save MA_merged_08_23.dta, replace 


////////2002-2005///////////

import delimited "/Users/bubbles/Desktop/MA_06/MA_2002.csv", clear 
gen year =2002
rename v1 state 
rename v2 countyname
rename v3 eligibles
rename v4 enrolled
rename v5 penetration
rename v6 part_a_aged
rename v7 part_b_aged
rename v8 part_ab_aged_rate
rename v9 ssa 
drop part_a_aged part_b_aged part_ab_aged_rate

gen small = (missing(enrolled) & !missing(eligibles))
replace penetration = "." if penetration == "#VALUE!"

destring, replace 

save MA_2002.dta, replace 


import delimited "/Users/bubbles/Desktop/MA_06/MA_2003.csv", clear 
gen year =2003
rename v1 state 
rename v2 countyname
rename v3 eligibles
rename v4 enrolled
rename v5 penetration
rename v6 part_a_aged
rename v7 part_b_aged
rename v8 part_ab_aged_rate
rename v9 ssa
//there is state and county under 11 value can distribute evenly across counties in that state 

drop part_a_aged part_b_aged part_ab_aged_rate v10 v11
destring, replace 
gen small = (missing(enrolled) & !missing(eligibles))
save MA_2003.dta, replace 

import delimited "/Users/bubbles/Desktop/MA_06/MA_2004.csv", clear 
gen year=2004
rename v1 state 
rename v2 countyname
rename v3 eligibles
rename v4 enrolled
rename v5 penetration
rename v6 part_a_aged
rename v7 part_b_aged
rename v8 part_ab_aged_rate
rename v9 ssa
//there is state and county under 11 value can distribute evenly across counties in that state 
drop part_a_aged part_b_aged part_ab_aged_rate v10 v11

gen small = (missing(enrolled) & !missing(eligibles))
//drop if ssa=="99xxx" //not sure why this doesn't work 
drop if strpos(countyname,"UNDER-11") //this year county name for under_11 not good (not numeric), drop them for now
drop if strpos(ssa,"xxx")
destring, replace 

save MA_2004.dta, replace 

import delimited "/Users/bubbles/Desktop/MA_06/MA_2005.csv", clear 
gen year=2005
rename v1 state 
rename v2 countyname
rename v3 eligibles
rename v4 enrolled
rename v5 penetration
rename v6 part_a_aged
rename v7 part_b_aged
rename v8 part_ab_aged_rate
rename v9 ssa
//there is state and county under 11 value can distribute evenly across counties in that state 

drop part_a_aged part_b_aged part_ab_aged_rate v10 v11

//drop if ssa=="99xxx" //not sure why this doesn't work 
drop if strpos(countyname,"UNDER-11") //this year county name for under_11 not good (not numeric), drop them for now
drop if strpos(ssa,"xxx")
destring, replace 

gen small = (missing(enrolled) & !missing(eligibles))

save MA_2005.dta, replace 

forvalues i = 2002/2004 { 
	append using MA_`i'.dta, force
}

save MA_merged_02_05.dta, replace 


////1993-2001///--the under 11 doesn't seem to exist for this section, no privacy protection rules. So for consistency maybe should later try to use the under 11 for the other years as well, probably some bias here. 

forvalues i = 1993/2001 { 
	import excel "/Users/bubbles/Desktop/hha_data/MA/clean/1993-2001.xlsx", sheet("`i'") clear
	gen year =`i'
	rename A countyname
	rename B eligibles
	rename C enrolled
	rename D penetration
	rename E part_a_aged
	rename F part_b_aged
	rename G part_ab_aged_rate
	rename H ssa
	drop part_a_aged part_b_aged part_ab_aged_rate 
	destring, replace 
	save MA_`i'.dta, replace 
}

forvalues i = 1993/2000 { 
	append using MA_`i'.dta, force
}

save MA_merged_93_01.dta, replace 



//////putting all together 

use MA_merged_93_01.dta, clear 
append using MA_merged_02_05.dta, force
append using MA_merged_08_23.dta, force
rename ssa county_ssa 
drop if strpos(countyname,"UNDER-11")

bys county_ssa year: gen dup = cond(_N==1,0,_n)
drop if dup>0 //a couple of duplications

replace state = subinstr(state, " ", "", .)

//fill in missing values for state(2dg) and state_fips 
bysort county_ssa (state) : replace state = state[_N] if missing(state) 
bysort county_ssa (fipscnty) : replace fipscnty = fipscnty[1] if missing(fipscnty) 
drop if missing(state) 
drop if missing(fipscnty) 

rename fipscnty county_fips
replace countyname = lower(countyname)


//extrapolate for 2006 and 2007 
expand 3 if year == 2005, gen(extra) //make copies of the 2005 so that 3 copies in total 
bysort state county_fips (year extra) : replace year = year[_n-1] + 1 if extra

local vars penetration eligibles enrolled

foreach v in `vars'{
	replace `v' = . if extra //replace out values 
}

foreach v in `vars'{
	ipolate `v' year, generate(`v'_int)  by(state county_fips)
}

foreach v in `vars'{
	gen `v'_original = `v'
	replace `v' = `v'_int 
	drop `v'_int 
}

gen pene_inter = missing(penetration_original) & !missing(penetration) //interpolated or not 

keep county_fips countyname eligibles enrolled penetration county_ssa year state state_fips small pene_inter 

drop if penetration >100 //added in 09/24

save MA_merged_93-23.dta, replace 

// 5474/93169 missing penetration for all years excluding 2006 and 2007 if do not extrapolate 

