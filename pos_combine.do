//combining pos and census and pos_hospitals to get final dataset for regression

//census information missing for PR before 2008 

cd /Users/bubbles/Desktop/HomeHealth/output/
 
use pos92-22.dta, clear
bys prvdr_num year: gen dup = cond(_N==1,0,_n)
drop if dup>1 //no duplicates 

egen n_firms = count(prvdr_num), by (year fips_cnty_cd state_cd) //number of home health agencies in county year
egen int entryYr = min(year), by(prvdr_num)
egen int exitYr = max(year), by(prvdr_num)

gen byte entry = (year==entryYr)
gen byte exit = (year==exitYr)

bys year fips_cnty_cd state_cd: egen  n_entrants = total(entry) //number of entries in county year
replace n_entrants =. if year==1992 //entrants undefined for first year
bys year fips_cnty_cd state_cd : egen n_exits = total(exit) // number of exits in county year 
replace n_exits=. if year==2022 //exits undefined for last year 

keep year fips_cnty_cd state_cd n_firms n_entrants n_exits 

rename fips_cnty_cd county_fips 
rename state_cd state

drop if missing(county_fips) //some missing values for this 

duplicates drop

save county_entry_92-22.dta, replace 

merge 1:1 county_fips state year using pos92-22_hospitals.dta

//replace n_hospital =0 if _merge==1//missing becauses there are no hospitals in the county that year 
drop if _merge==2 //drop if only hospitals and no home health
rename _merge _merge_hospital 


merge 1:1 county_fips state year using controls_census.dta //census data. Can check again the counties that are unmatched from master dataset (home health entry and exits) for the individual cases to see what is going on. 

//not sure what to do with the cases unmatched from the census, probably this means those counties had no home health agencies and also 0 entry and exits, but not sure if this will lead to too many zeros.

//looking at the merge==1 
//at some point probably should just drop those with populations less than 10000 or something---
//some cleaning for the unmatched ones 
drop if state =="MP" // state is Northern Mariana Islands, doesn't have any counties, that's why county codes are 0s
drop if state =="GU" //Guam only has one county and no census information 
drop if state =="VI" //no census data for VI, which only has three counties 
drop if state =="AK" & county_fips==1 //just one random observation
drop if state =="CT" & inrange(county_fips,1100,1900) //weird regions 
drop if inlist(state,"CN","MX","CM") // no such state 
//in the rest _merge ==1 only a hundred and something, generally the county code seems wrong/outdated, probably just ignore in analysis 

//looking at the merge==2
//seems like all small places can probably just replace the number of firms, entry and exits by 0, do versions with or without those

replace n_firms =0 if _merge==2
replace n_entrants =0 if _merge==2 & year != 1992 
replace n_exits =0 if _merge==2 & year !=2022 
replace n_hospitals =0 if _merge==2
drop _merge


save temp_merged.dta, replace

use temp_merged.dta, clear

drop if year==1992 //no MA data for this

merge 1:1 county_fips state year using MA_merged_93-22.dta

drop _merge 

//in main but not in using because missing 2006 and 2007 MA data, can interpolate later

gen n_hosp_pc = n_hospitals/persons_tot

egen county_id = group(state county_fips)

//merge with CON laws 

merge m:1 state year using con_laws.dta

drop _merge 

save merged_pos_MA.dta, replace



//missing data for y variables 
count if missing(n_firms) //missing when a county year is not in census but is in the MA data --usually this county is in PR
count if missing(n_exits) //missing when a county year is not in census and when year is 2022, so exits are not defined. 

count if missing(n_entrants) //because 1992 was excluded due to no MA information, this is only missing when a county year is not in census but is in the MA data --usually this county is in PR


