*25/09 - update county population, metro population, and ffs to become time varying controls. 
//for now only consider metropolitan areas, not micro 
*currently the MA_distance thing only goes to 2019, so is admin data, so don't worry about these years for now


////////////////////////////
///  Metro level info   ////
////////////////////////////


//2000-2009

import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2009-alldata.csv", clear 

//data on cbsa (metro/micro), counties in each cbsa, county_fips code, and county population in 2007. Data source: https://www2.census.gov/programs-surveys/popest/datasets/2000-2007/metro/totals/
//this doesn't have all counties // https://www.census.gov/geographies/reference-files/time-series/demo/metro-micro/historical-delineation-files.htm
destring cbsa, replace force
drop if missing(cbsa) //obs for other info
drop if !missing(mdiv) //drop divisions
gen tag = 1 if !missing(stcou) //tag county observations 
bys cbsa: egen ncty_metro = total(tag) //this cannot change over time anyway
keep if missing(stcou) //keep metro/micro level observations, exclude county level observations
rename lsad cbsa_type 
keep cbsa cbsa_type  ncty_metro popestimate*
reshape long popestimate, i(cbsa) j(year)
rename popestimate pop_metro

save "/Users/bubbles/Desktop/HomeHealth/temp/msa_2000-2009.dta", replace

//2010-2019

import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2019-alldata.csv", clear 

destring cbsa, replace force
drop if missing(cbsa) //obs for other info
drop if !missing(mdiv) //drop divisions
gen tag = 1 if !missing(stcou) //tag county observations 
bys cbsa: egen ncty_metro = total(tag) //this cannot change over time anyway
keep if missing(stcou) //keep metro/micro level observations, exclude county level observations
rename lsad cbsa_type 
keep cbsa cbsa_type  ncty_metro popestimate*
reshape long popestimate, i(cbsa) j(year)
rename popestimate pop_metro
save "/Users/bubbles/Desktop/HomeHealth/temp/msa_2010-2019.dta", replace

//2020-2023 

import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2023-alldata.csv", clear 

destring cbsa, replace force
drop if missing(cbsa) //obs for other info
drop if !missing(mdiv) //drop divisions
gen tag = 1 if !missing(stcou) //tag county observations 
bys cbsa: egen ncty_metro = total(tag) //this cannot change over time anyway
keep if missing(stcou) //keep metro/micro level observations, exclude county level observations
rename lsad cbsa_type 
keep cbsa cbsa_type ncty_metro popestimate*
reshape long popestimate, i(cbsa) j(year)
rename popestimate pop_metro
save "/Users/bubbles/Desktop/HomeHealth/temp/msa_2020-2023.dta", replace

//putting the metro information together 

use "/Users/bubbles/Desktop/HomeHealth/temp/msa_2000-2009.dta", clear 
append using "/Users/bubbles/Desktop/HomeHealth/temp/msa_2010-2019.dta"
append using "/Users/bubbles/Desktop/HomeHealth/temp/msa_2020-2023.dta"

sort cbsa year 

save "/Users/bubbles/Desktop/HomeHealth/temp/metro_2000_2023.dta", replace


////////////////////////////
///  County level info   ////
////////////////////////////

import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2009-alldata.csv", clear 

destring cbsa, replace force
drop if missing(cbsa)
drop if !missing(mdiv) //drop divisions
keep if !missing(stcou) //keep county_fips
keep cbsa stcou popestimate* 
reshape long popestimate, i(stcou) j(year)
rename stcou fips 
rename popestimate pop_cty
destring fips, replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/cty_2000-2009.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2019-alldata.csv", clear 

destring cbsa, replace force
drop if missing(cbsa)
drop if !missing(mdiv) //drop divisions
keep if !missing(stcou) //keep county_fips
keep cbsa stcou popestimate* 
reshape long popestimate, i(stcou) j(year)
rename stcou fips 
rename popestimate pop_cty
destring fips, replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/cty_2010-2019.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2023-alldata.csv", clear 

destring cbsa, replace force
drop if missing(cbsa)
drop if !missing(mdiv) //drop divisions
keep if !missing(stcou) //keep county_fips
keep cbsa stcou popestimate* 
reshape long popestimate, i(stcou) j(year)
rename stcou fips 
rename popestimate pop_cty
destring fips, replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/cty_2020-2023.dta", replace

use "/Users/bubbles/Desktop/HomeHealth/temp/cty_2000-2009.dta", clear 

append using "/Users/bubbles/Desktop/HomeHealth/temp/county_2010-2019.dta"
append using "/Users/bubbles/Desktop/HomeHealth/temp/county_2020-2023.dta"
sort fips year 

save "/Users/bubbles/Desktop/HomeHealth/temp/cty_2000_2023.dta", replace


//////////////////////////////////////////
// Combine county level with metro info //
//////////////////////////////////////////

use "/Users/bubbles/Desktop/HomeHealth/temp/cty_2000_2023.dta", clear, 

merge m:1 cbsa year using "/Users/bubbles/Desktop/HomeHealth/temp/metro_2000_2023.dta"

drop if _merge ==2 //some metro areas don't contain any counties, these are usually large city regions

drop _merge 

keep if cbsa_type == "Metropolitan Statistical Area"

drop cbsa_type
save "/Users/bubbles/Desktop/HomeHealth/temp/cty_metro_2000_2023.dta", replace 


////////////////////////////////////////////////////////
//   generate fips to ssa conversions for 2000-2023  ///
////////////////////////////////////////////////////////

* source: https://www.nber.org/research/data/ssa-federal-information-processing-series-fips-state-and-county-crosswalk

//can double check with county name 

//use the 2003 to stand in for 1993-2010 because it was the only one available 
use "/Users/bubbles/Desktop/hha_data/ssa_fips/county_ssa_fips_2003.dta", clear
bys fips: gen dup =cond(_n==1,0,_n)
drop if dup>1 //1 duplicate 
bys ssa: gen dup2 =cond(_n==1,0,_n)
drop if dup2>1 //1 duplicate 
destring fips ssa, replace 
drop dup dup2
rename county county_name 
rename abbr state 
keep fips ssa county_name state 
gen year =1993
expand 18, gen(new)
replace year = . if new==1
sort fips year 
by fips: replace year = year[_n-1]+1 if new == 1
drop new 
save "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_1993_2010.dta", replace 


forvalues t = 2011/2017 {
	use "/Users/bubbles/Desktop/hha_data/ssa_fips/ssa_fips_state_county`t'.dta", clear
	if `t' <=2012 {
		drop if _n==1 
	}
	rename fipscounty fips
	rename ssacounty ssa
	bys fips: gen dup =cond(_n==1,0,_n)
	drop if dup>1 //1 duplicate 
	bys ssa: gen dup2 =cond(_n==1,0,_n)
	drop if dup2>1 //1 duplicate 
	destring fips ssa, replace 
	drop dup dup2
	rename county county_name 
	keep fips ssa county_name state  
	gen year =`t'
	
	save "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_`t'.dta", replace 
}

//2018-2020 (excel form)


forvalues t = 2018/2020 {
	import excel "/Users/bubbles/Desktop/hha_data/ssa_fips/ssa_fips_state_county`t'.xlsx", sheet("Crosswalk") clear
	drop if _n==1 
	rename C ssa
	rename D fips
	bys fips: gen dup =cond(_n==1,0,_n)
	drop if dup>1 //1 duplicate 
	bys ssa: gen dup2 =cond(_n==1,0,_n)
	drop if dup2>1 //1 duplicate 
	destring fips ssa, replace 
	drop dup dup2
	rename B state 
	rename A county_name 
	keep fips ssa county_name state 
	gen year =`t'
	save "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_`t'.dta", replace 
}

//the 2021-2023 ones don't seem reliable, just duplicate 2020 

//combining the ssa to fips translations 

use "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_1993_2010.dta", clear 
forvalues t = 2011/2020 {
	append using "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_`t'.dta"
}
gen diff = ssa-fips
sort fips ssa year 
by fips (diff), sort: gen difftrue = diff[1] != diff[_N] 
list fips diff if difftrue
//seems like there was only one change in fips ssa conversion over these years, so probably didn't have to use all these years. 
drop diff difftrue
expand 4 if year==2020, gen(new)
replace year = . if new==1
sort fips year 
by fips: replace year = year[_n-1]+1 if new == 1
drop new
rename ssa county_ssa

save "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_1993_2023.dta", replace 


///////////////////////////////////////////////////////
//combine with county metro with fips_ssa crosswalk to get ssa 
///////////////////////////////////////////////////////

use "/Users/bubbles/Desktop/HomeHealth/temp/cty_metro_2000_2023.dta", clear 
merge 1:1 fips year using "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_1993_2023.dta"
keep if _merge==3 //only 28 not matched from master, not matched from using is normal because master has fewer counties 
drop _merge 
save "/Users/bubbles/Desktop/HomeHealth/temp/cty_metro_2000_2023_ssa.dta", replace 


///////////////////////////////////////////////////////
//combine with county msa info with MA_distance to get FFS, base, urban and distance//
///////////////////////////////////////////////////////

use "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance.dta", clear  //note that >=2020 actually no info, empty observations
keep countySSA year base urbanMSA1999 floor base_ffs binding urban_04 distance
rename urbanMSA1999 urban_99 
rename countySSA county_ssa 
save "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance_selected.dta", replace 

use "/Users/bubbles/Desktop/HomeHealth/temp/cty_metro_2000_2023_ssa.dta", clear 
merge 1:1 county_ssa year using "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance_selected.dta" //only 28 not matched from master 
keep if _merge==3 
drop _merge 

save "/Users/bubbles/Desktop/HomeHealth/temp/cty_metro_2000_2023_distance.dta", replace


///////////////////////////////////////////////////////
//       Combine with MA penetration and pos info    //
///////////////////////////////////////////////////////

use "/Users/bubbles/Desktop/HomeHealth/temp/cty_metro_2000_2023_distance.dta", clear 

merge 1:1 county_ssa year using "/Users/bubbles/Desktop/HomeHealth/output/MA_merged_93-23.dta" //only 1 not matched from master

keep if _merge==3 
drop _merge 
drop countyname 

merge 1:1 fips year using "/Users/bubbles/Desktop/HomeHealth/output/merged_pos_census.dta"
drop if _merge ==2 //not matched all due to POS have more counties but do not have year 2023
drop _merge 
save "/Users/bubbles/Desktop/HomeHealth/temp/duggan092624.dta", replace
























