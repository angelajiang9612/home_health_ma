//see if I can replicate some of the effect on MA enrollment 

/*
Replaced the weighting variable (density) with eligibles_aggregate for now. Not sure how their frequency weights are constructed and used. Frequency weights need to be whole numbers. 
*/


//Question: why was Medicare enrollment average so high in their estimate 


use "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/CostsEventStudies.dta", clear

//the years used here are 1999 and after, uncheck later.

gen MA_penetration = (enrollees_aggregate/eligibles_aggregate)*100 //percentage on MA

bys countyFIPS: egen eligibles_2000=max(eligibles_aggregate*(year==2000))
//creating weight by population in 2000

/*
////same as using aweights with just the population themselves 
su eligibles_2000 if year==2000, meanonly 
di "Total is " r(sum) 
gen wgt_2000 = eligibles_2000 / r(sum) 
*/ 

cap drop non_missing*

gen non_missing_contract = (contract_count != .)
gen non_missing_premium = (mean_premium~=.)
gen non_missing_weights = (eligibles_2000~=.) //difference 

gen non_missing = (non_missing_contract == 1)
replace non_missing = 0 if non_missing_premium == 0
replace non_missing = 0 if non_missing_weights == 0

*generate stats on sample restrictsion
sum enrollees_aggregate 
sum eligibles_aggregate

tab year non_missing
tab year non_missing [aw = eligibles_2000] //the ones with nonmissing at this point has bigger population

keep if non_missing ==1 //can uncheck this later



/*******************************************************
variables 
********************************************************/

ren base_ base

gen temp = base if year == 2000
bys countyFIPS : egen base2000 = mean(temp)
gen base2000sq = base2000^2
drop temp

gen year_minus_1996 = year - 1996



////////Regressions////////

local varlist MA_penetration 

*controls
cap drop floor98control
gen floor98control = Floor98 

cap drop blendControl
gen blendControl = blend2

*base groups
cap drop base2000_group
bys countyFIPS: gen byte firstObs = (_n==1)
cap drop temp
xtile temp = base2000 [aw = eligibles_2000] if firstObs==1, n(4)
bys countyFIPS: egen base2000_group = mean(temp)
drop temp firstObs


local controls_1 "i.year##c.floor98control i.year##c.blendControl"
local controls_2 "i.year##c.floor98control i.year##c.blendControl i.base2000_group#i.year_minus_1996"
local controls_3 "i.year##c.floor98control i.year##c.blendControl i.urbanMSA1999#i.year_minus_1996"


foreach y_var in `varlist' {
	preserve				
		replace floorDistance = floorDistance/50 //Scaled by 50, Not that this as not been adjusted by the AR in the original script.
						 
		su `y_var' [aw = eligibles_2000] if year <= 2000 
		local pre_mean = r(mean)
						
		forv x = 1/3 {	
			areg `y_var' b2000.year##c.floorDistance `controls_`x'' [aw = eligibles_2000], a(countyFIPS) cluster(countyFIPS)
			 di `pre_mean'
		}	
}



/* first attempt 

xtset countySSA year 

gen MA_penetration = (enrollees_aggregate/eligibles_aggregate)*100

reghdfe MA_penetration ib(2000).year#c.floorDistance[pweight= eligibles_aggregate], absorb(year countySSA) cluster(countySSA)




reghdfe `var'  hh_threenmore ib(last).agey_group#hh_threenmore ib(last).agey_group##treatedpost09  ///
	`demographics' c.year#i.hh_state [pweight= wt06] if female==1, absorb(year hh_state) cluster(hh_state)
