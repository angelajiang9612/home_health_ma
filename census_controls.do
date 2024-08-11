//controls for the entry and exit questions, controls and interpolation methods following Huckfeldt 2013 
//downloaded from IPUMS nhgis very first subset. 

//expanding then interpolating https://www.statalist.org/forums/forum/general-stata-discussion/general/1612098-interpolate-between-two-year-dates-using-expanding

//census 2020 doesn't have age groups, use ACS. 
//cencus 2010 and 2020 don't have per_capita_income, use ACS. 
//goal is to get 1990 to 2022 yearly controls. For the ACS 5 years replace by midium year 

 //county name or countyfp not unique, many states have counties with the same name, or fp code, unique on countyfp state 
//some counties don't exist in all years, not a perfectly balanced panel. 


local tokeep gisjoin year state statefp county countyfp countynh name persons_tot persons_65_74 persons_75_plus persons_black persons_hispan per_capita_income   

local vars persons_tot persons_65_74 persons_75_plus persons_black persons_hispan per_capita_income prop_black prop_hispan prop_65_74 prop_75_plus


import delimited "/Users/bubbles/Downloads/nhgis0001_csv/nhgis0001_ts_nominal_county.csv", clear 

rename b78aa persons_tot							
rename b57ap persons_65_74 		
rename b57aq persons_75_84		
rename b57ar persons_85_plus			
rename b18ab persons_black //single race 								
rename a35aa persons_hispan //hispanice or latino 			
rename bd5aa  per_capita_income	

gen persons_75_plus = persons_75_84 + persons_85_plus

keep `tokeep' //keep relevant variables 

egen countyfp_state = group(countyfp state) //unique ids for counties 

//replace ACS 5-year estimates by middle year 

drop if year =="2020" | year =="2010" //don't use the dicennial census for these years
replace year = "2008" if year == "2006-2010"
replace year = "2009" if year == "2007-2011"
replace year = "2010" if year == "2008-2012"
replace year = "2011" if year == "2009-2013"
replace year = "2012" if year == "2010-2014"
replace year = "2013" if year == "2011-2015"
replace year = "2014" if year == "2012-2016"
replace year = "2015" if year == "2013-2017"
replace year = "2016" if year == "2014-2018"
replace year = "2017" if year == "2015-2019"
replace year = "2018" if year == "2016-2020"
replace year = "2019" if year == "2017-2021"
replace year = "2020" if year == "2018-2022"
destring year, replace

//generate proportions for race and age variables 

gen prop_black = persons_black/persons_tot
gen prop_hispan = persons_hispan/persons_tot
gen prop_65_74 = persons_65_74/persons_tot
gen prop_75_plus = persons_75_plus/persons_tot 

//interpolate 1991-1999, 2001-2007 
 
expand 10 if year == 1990, gen(extra) //create duplicates 
expand 8 if year == 2000, gen(extra2)
expand 3 if year == 2020, gen(extra3)
bysort countyfp_state (year extra) : replace year = year[_n-1] + 1 if extra
bysort countyfp_state (year extra2) : replace year = year[_n-1] + 1 if extra2
bysort countyfp_state (year extra3) : replace year = year[_n-1] + 1 if extra3

foreach v in `vars'{
	replace `v' = . if extra
	replace `v' = . if extra2
	replace `v' = . if extra3
}

//interpolate and expolate, checked that results look reasonable. 
foreach v in `vars'{
	ipolate `v' year, generate(`v'_int) epolate by(countyfp_state)
}

//replace by interpolated var and saving the initial values
foreach v in `vars'{
	gen `v'_original = `v'
	replace `v' = `v'_int 
	drop `v'_int 
}

keep if year >=1992
keep year state statefp county countyfp countynh name persons_tot  prop_black prop_hispan prop_65_74 prop_75_plus per_capita_income  

statastates, name(state) nogenerate //generate variables state abbreviation and state fips codes from state names 

replace state_abbrev = "PR" if state == "PUERTO RICO"

rename state state_name 
rename state_abbrev state 
rename countyfp county_fips
drop statefp
drop countynh 

drop name 

save "/Users/bubbles/Desktop/HomeHealth/output/controls_census", replace

