cd  "/Users/bubbles/Desktop/HomeHealth/output/"
use MA_merged_93-22.dta, clear 

merge 1:1 county_fips state year using controls_census.dta 

keep if inrange(year,2004,2019) //generally all matched >99%

drop if _merge ==2
gen no_census_controls =(_merge==1)
drop _merge 

merge 1:1 county_fips state year using pos92-22_hospitals.dta

keep if inrange(year,2004,2019)

replace n_hospitals =0 if _merge==1 //pos hospital data may not be super reliable, try with or without this control to see if has any effect or not

drop if _merge==2
drop _merge 

gen pop_hth = persons_tot/100000
gen n_hosp_phth = n_hospitals/pop_hth

save MA_controls_04-19.dta, replace
