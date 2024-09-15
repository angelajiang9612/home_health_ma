//this calculates the number of acute hospitals in each county, to use as controls in entry regression

//focus on short term and long term hospitals for now, other categories (e.g. Critical Access Hospitals) are bot included for consistency (they tend to be smaller and they didn't exist as a category in earlier years of the pos)

//assuming that subcategories 1 and 2 for hospitals remained constant throughout the years, looks sort of reasonable.

//not all counties are here, counties that do not have any hospitals for instance will not be in the final dataset constructed here. 2794/3143 counties had any hospital in any of these years

//years 1992-2022

////two digit state abbreviation and three digit county fips code 

////Sep 02 added 1993

local vars prvdr_ctgry_sbtyp_cd prvdr_ctgry_cd pgm_trmntn_cd prvdr_num ssa_cnty_cd  fips_cnty_cd state_cd state_rgn_cd fips_state_cd


cd "/Users/bubbles/Desktop/hha_data/"

///do county and state unique combinations sum 


forvalues i = 1992/1993 {
 use pos/pos`i'.dta, clear
 rename prov2805 pgm_trmntn_cd
 isvar `vars'
 keep `r(varlist)' //keeping the variables in list 
 destring, replace 
 keep if prvdr_ctgry_cd ==1 & inlist(prvdr_ctgry_sbtyp_cd,1,2) //acute hospitals 
 keep if pgm_trmntn_cd ==0 //keep active providers 
 gen year = `i'
 save temp/pos`i'.dta, replace 
}

//why no 1993?

forvalues i = 1994/2022 {
 use pos/pos`i'.dta, clear
 isvar `vars'
 keep `r(varlist)'
 destring, replace 
 keep if prvdr_ctgry_cd ==1 & inlist(prvdr_ctgry_sbtyp_cd,1,2) //
 keep if pgm_trmntn_cd ==0 //keep active providers 
 gen year = `i'
 save temp/pos`i'.dta, replace 
}

//appending to get panel 

forvalues i = 1992/2021 { 
	append using temp/pos`i'.dta, force
	quietly describe 
	di r(k)
} 

save  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22_hospitals_raw.dta", replace 


use  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22_hospitals_raw.dta", clear

 //unique ids for counties 
egen n_hospitals = group(prvdr_num) //destring

rename fips_cnty_cd county_fips
rename state_cd state 
rename fips_state_cd state_fips

drop if missing(county_fips) | missing(state_fips)

//generate five digit unique state+fips first 
gen state_fips_string = string(state_fips,"%02.0f") //two digit state code
gen county_fips_string = string(county_fips,"%03.0f") //three digits county code 
gen state_cty_fips = state_fips_string  + county_fips_string

collapse (count) n_hospitals (firstnm) county_fips state, by (year state_cty_fips) 

save  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22_hospitals.dta", replace 





