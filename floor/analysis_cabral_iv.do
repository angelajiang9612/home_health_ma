
cd  "/Users/bubbles/Desktop/HomeHealth/output/"
use MA_merged_93-22.dta, clear 

merge 1:1 county_fips state year using controls_census.dta 

drop if _merge ==2
gen no_census_controls =(_merge==1)
drop _merge 

merge 1:1 county_fips state year using pos92-22_hospitals.dta

replace n_hospitals =0 if _merge==1 //pos hospital data may not be super reliable, try with or without this control to see if has any effect or not

drop if _merge==2
drop _merge 

gen pop_hth = persons_tot/100000
gen n_hosp_phth = n_hospitals/pop_hth

rename county_ssa countySSA

keep if inrange(year,1997,2019)

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance.dta", force //generally match is okay, can check again 

drop if _merge==1
drop _merge

bys countySSA: egen eligibles_2000=max(eligibles*(year==2000))
sum penetration, detail
sum penetration [aw = eligibles_2000], detail

drop if penetration >100 & !missing(penetration)

drop if missing(eligibles_2000)
drop if missing(penetration)

keep if inrange(year,2006,2019) //the previous years wouldn't have any effect because the policy was not enacted yet

gen distance50 = distance/50 

local controls per_capita_income percent_black percent_hispan pop_hth percent_65_74 percent_75_plus n_hosp_phth

reghdfe penetration distance50 `controls' [pweight= eligibles_2000], absorb(year countySSA) cluster(countySSA) 

import excel "/Users/bubbles/Desktop/hha_data/misc_duggan/ruralurbancodes2003.xls", sheet("beale03") firstrow clear










