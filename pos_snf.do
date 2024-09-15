//this keeps nursing home provider id and state_cty_fips, as county information is not in mds 

local vars prvdr_ctgry_sbtyp_cd prvdr_ctgry_cd pgm_trmntn_cd prvdr_num ssa_cnty_cd  fips_cnty_cd state_cd state_rgn_cd fips_state_cd


forvalues i = 1992/1992 {
 use pos/pos`i'.dta, clear
 rename prov2805 pgm_trmntn_cd
 isvar `vars'
 keep `r(varlist)' //keeping the variables in list 
 destring, replace 
 keep if prvdr_ctgry_cd ==2 
 keep if pgm_trmntn_cd ==0 //keep active providers 
 gen year = `i'
 save temp/pos`i'_snf.dta, replace 
}

forvalues i = 1994/2022 {
 use pos/pos`i'.dta, clear
 isvar `vars'
 keep `r(varlist)'
 destring, replace 
 keep if prvdr_ctgry_cd ==2
 keep if pgm_trmntn_cd ==0 //keep active providers 
 gen year = `i'
 save temp/pos`i'_snf.dta, replace 
}


use temp/pos2022_snf.dta, clear

//appending to get panel 

forvalues i = 1992/2021 { 
	append using temp/pos`i'_snf.dta, force
	quietly describe 
	di r(k)
} 

save  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22_snf_raw.dta", replace 


use  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22_snf_raw.dta", clear

rename fips_cnty_cd county_fips
rename state_cd state 
rename fips_state_cd state_fips

gen state_fips_string = string(state_fips,"%02.0f") //two digit state code
gen county_fips_string = string(county_fips,"%03.0f") //three digits county code 
gen state_cty_fips = state_fips_string  + county_fips_string

keep prvdr_num state_cty_fips state state_fips county_fips

save  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22_snf.dta", replace 

