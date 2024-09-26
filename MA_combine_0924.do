//compared to previous version, main difference is 1993-2001 applied protection policy and replaced by missing when enrolled is <=10, this generated more missing values but essentially just for those years. 

//in 2006-2007 all interpolated, in other years some interpolation as well, especially in the earlier years but not the later years. So should consider versions with interpolation vs no interpolations.

//2008 onwards data is actually monthly, can try to use this and see if performs better 


//imports and cleans data on MA penetration by county, combines to get panel for MA penetration 1993-2022. 

//for now ignore the under 11s, in future could distribute evenly as suggested by the data provider. 

//state, state fips, county, county_fips year 

//data source: 2008 onwards  https://www.cms.gov/data-research/statistics-trends-and-reports/medicare-advantagepart-d-contract-and-enrollment-data/ma-state/county-penetration (monthly information), so can do monthly regressions rather than yearly for a lot of outcome variables. 

//https://cms.gov/data-research/statistics-trends-and-reports/health-plans-reports-files-data (2006 and before, quarterly)





/*
For now use June of each year when available, and just the yearly for 1993-1996
1997 onwards quarterly
2008 onwards monthly 
2006-2007 missing

1999 data is from July not June 

06 07 years interpolate.

More information in onenote -Data cleaning - Medicare penetration 

//the under 11 distributions are not used for now

*/

//2008-2023
 
import delimited "/Users/bubbles/Desktop/hha_data/MA/clean/MA_2008.csv", clear 

cd  "/Users/bubbles/Desktop/HomeHealth/output/"

forvalues i = 2008/2023 { 
	import delimited "/Users/bubbles/Desktop/hha_data/MA/clean/MA_`i'.csv", clear 
	gen year = `i'
	di `i'
	destring, replace 
	describe 
	save MA_`i'.dta, replace 
}

use MA_2008.dta, clear 
drop if fipsst=="UK" //pending designation  
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
gen small = (enrolled =="*") //10 or less 
destring enrolled, replace ignore("," "*")

//enrolled between 1-10 results in * for this group, missing variable for MA penetration, not many counties have this issue, 1,146/51,515=2%

//in these years basically all missings are due to small, some counties enrolled is also missing

save MA_merged_08_23.dta, replace 


////////2002-2005///////////

import delimited "/Users/bubbles/Desktop/hha_data/MA/clean/MA_2002.csv", clear 
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
replace penetration = "." if penetration == "#VALUE!" //more missing in earlier years

destring, replace 
drop if ssa == 99999 //combined all counties with unusual code

save MA_2002.dta, replace 


import delimited "/Users/bubbles/Desktop/hha_data/MA/clean/MA_2003.csv", clear 
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
//there is state and county under 11 value can distribute evenly across counties in that state with missing values 

drop part_a_aged part_b_aged part_ab_aged_rate v10 v11

drop if strpos(countyname,"UNDER-11") //this year county name for under_11 not good (not numeric), drop them for now
destring, replace 
gen small = (missing(enrolled) & !missing(eligibles)) //there are a couple with both missing
drop if ssa == 99999 //unusual code
save MA_2003.dta, replace 

import delimited "/Users/bubbles/Desktop/hha_data/MA/clean/MA_2004.csv", clear 
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

//drop if ssa=="99xxx" //not sure why this doesn't work 
drop if strpos(countyname,"UNDER-11") //this year county name for under_11 not good (not numeric), drop them for now
drop if strpos(ssa,"xxx")
destring, replace 
gen small = (missing(enrolled) & !missing(eligibles))
drop if ssa == 99999
save MA_2004.dta, replace 

import delimited "/Users/bubbles/Desktop/hha_data/MA/clean/MA_2005.csv", clear 
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


//apply the same privacy protection rules for consistency 
gen small = (enrolled <=10)
replace enrolled = . if enrolled <=10
replace penetration=. if enrolled ==. 
save MA_merged_93_01.dta, replace  //most are missing in these years, probably won't use them much anyway.


//////putting all together 

use MA_merged_93_01.dta, clear 
append using MA_merged_02_05.dta, force
append using MA_merged_08_23.dta, force
rename ssa county_ssa 
drop if strpos(countyname,"UNDER-11")

bys county_ssa year: gen dup = cond(_N==1,0,_n)
drop if dup>1 //a couple of duplications

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

//penetration is often missing even when small is not 1 because of 2005 and 2006 being all interpolated

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

drop if penetration >100 & !missing(penetration) //only 6 

save MA_merged_93-23.dta, replace 

//12,546 missing penetration after interpolation, but only 1303 for 2004 and after. 
//24,104 missing penetration without interpolation
//176 missing eligibles
//some of the observations with small has penentration value because of interpolation. 
