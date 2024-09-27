use "/Users/bubbles/Desktop/HomeHealth/temp/cabral092624.dta", clear

xtset county_ssa year 
bys county_ssa: egen eligibles_2006= total(eligibles*(year==2006))

gen distance50=distance/50

drop if missing(eligibles_2006)
drop if missing(penetration)
//drop if penetration<=5 

keep if inrange(year,2006,2018)

/*
sum penetration [aw = eligibles_2007], detail

reghdfe penetration b2000.year##c.distance50 [aweight= eligibles_2006], absorb(county_ssa) cluster(county_ssa) 

//first stage 

reghdfe penetration b2000.year#c.distance50 [aweight= eligibles_2006], absorb(county_ssa year) cluster(county_ssa) 

// local controls per_capita_income percent_black percent_hispan percent_65_74 percent_75_plus n_hosp_phth pop_hth 

reghdfe penetration distance50 `controls' [aweight= eligibles_2006], absorb(year county_ssa) cluster(county_ssa) //adding controls weakens the IV

*/


//entry and exit outcomes 

gen exit_any=(n_exits>0 & n_exits!=.)
replace exit_any = . if n_exits==.

gen entry_any=(n_entrants>0 & n_entrants!=.)
replace entry_any = . if n_entrants==.

local outcomes n_firms n_entrants entry_any n_exits exit_any 
local controls per_capita_income percent_black percent_hispan percent_65_74 percent_75_plus n_hosp_phth  pop_hth

foreach var in `outcomes' {
	sum `var' [aweight= eligibles_2006]
	ivreghdfe `var'  `controls' (penetration=distance) [aweight= eligibles_2006], absorb(year county_ssa) cluster(county_ssa)
}

/*

foreach var in `outcomes' {
	ivreghdfe `var'  `controls' (penetration=distance50)  if CON==0 [aweight= pop_hth], absorb(year county_ssa) cluster(county_ssa)
}

foreach var in `outcomes' {
	ivreghdfe `var'  `controls' (penetration=distance50)  if CON==1 [aweight= pop_hth], absorb(year county_ssa) cluster(county_ssa)
}



/*
reghdfe penetration b2000.year#c.distance50 distance [pweight= eligibles_2000], absorb(county_ssa year) cluster(county_ssa) 
*/ 





