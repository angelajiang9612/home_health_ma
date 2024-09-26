
use "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance.dta", clear  //note that >=2020 actually no info, empty observations
keep countySSA year base urbanMSA1999 floor base_ffs binding urban_04 distance
rename urbanMSA1999 urban_99 
rename countySSA county_ssa 

merge 1:1 county_ssa year using "/Users/bubbles/Desktop/HomeHealth/output/MA_merged_93-23.dta" //only 1 not matched from master

keep if _merge==3 
drop _merge 
drop countyname 

merge 1:1 county_ssa year using "/Users/bubbles/Desktop/HomeHealth/temp/ssa_fips_1993_2023.dta"
keep if _merge==3 //only 28 not matched from master, not matched from using is normal because master has fewer counties 
drop _merge 

merge 1:1 fips year using "/Users/bubbles/Desktop/HomeHealth/output/merged_pos_census.dta"
drop if _merge ==2 //not matched all due to POS have more counties but do not have year 2023
drop _merge
 
gen pop_hth = persons_tot/100000
gen n_hosp_phth = n_hospitals/pop_hth

save "/Users/bubbles/Desktop/HomeHealth/temp/cabral092624.dta", replace





