import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2007-alldata.csv", clear 

//data on cbsa (metro/micro), counties in each cbsa, county_fips code, and county population in 2007. Data source: https://www2.census.gov/programs-surveys/popest/datasets/2000-2007/metro/totals/
//this doesn't have all counties 

//first construct each metropolitican area's population and number of counties. 
destring cbsa, replace force
drop if missing(cbsa)
drop if !missing(mdiv) //drop divisions
gen tag = 1 if !missing(stcou) //tag county observations 
bys cbsa: egen ncty2007_metro = total(tag)
keep if missing(stcou) //keep metro/micro level observations, exclude county level observations
rename popestimate2007 pop2007_metro
rename lsad cbsa_type 
keep cbsa ncty2007_metro pop2007_metro cbsa_type 

save "/Users/bubbles/Desktop/HomeHealth/temp/msa_info.dta", replace


//construct msa to county(ssa) matches

use "/Users/bubbles/Desktop/hha_data/misc_duggan/county_ssa_fips_2003.dta", clear
bys fips: gen dup =cond(_n==1,0,_n)
drop if dup>1
destring fips, replace 
keep fips ssa 
save "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_2003.dta", replace

import delimited "/Users/bubbles/Desktop/hha_data/misc_duggan/cbsa-est2007-alldata.csv", clear 

destring cbsa, replace force
drop if missing(cbsa)
drop if !missing(mdiv) //drop divisions
keep if !missing(stcou) //keep county_fips
keep cbsa stcou popestimate2007
rename stcou fips 
rename popestimate2007 pop2007_cty
destring fips, replace 

merge 1:1 fips using "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_2003.dta" //around half have no code
destring ssa, replace 
rename ssa countySSA 
keep if _merge==3
drop _merge 
gen year =2007

save "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_matched.dta", replace 


//merging everything together 

use "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance.dta", clear 
keep if year == 2007
keep countySSA urban_04 base_ffs
rename base_ffs ffs_2007
rename urban_04 urban //last time the urban rural was defined 
merge 1:1 countySSA using "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_matched.dta"
keep if _merge==3 
drop _merge 
merge m:1 cbsa using "/Users/bubbles/Desktop/HomeHealth/temp/msa_info.dta"
keep if _merge==3
drop _merge 
rename countySSA county_ssa 

save "/Users/bubbles/Desktop/HomeHealth/temp/duggan_info.dta", replace 


use "/Users/bubbles/Desktop/HomeHealth/output/MA_merged_93-23.dta", clear 
merge m:1 county_ssa using "/Users/bubbles/Desktop/HomeHealth/temp/duggan_info.dta"
keep if _merge==3
drop _merge
keep if cbsa_type == "Metropolitan Statistical Area"
drop *fips small cbsa_type
order county_ssa year penetration urban pop2007_cty ffs_2007 cbsa cbsa pop2007_metro ncty2007_metro

save "/Users/bubbles/Desktop/HomeHealth/temp/duggan.dta", replace









