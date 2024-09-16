//see if I can replicate some of the effect on MA enrollment 


/*
Replaced the weighting variable (density) with eligibles_aggregate for now. Not sure how their frequency weights are constructed and used. Frequency weights need to be whole numbers. 
*/

*using weights increased MA penetration results, dropping those with missing observations for the other variables also increased weights 

*without doing the sample selection in original paper, or doi

//Question: why was Medicare enrollment average so high in their estimate 

use "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta", clear

//the years used here are 1999 and after, uncheck later.

gen MA_penetration = (enrollees_aggregate/eligibles_aggregate)*100 //percentage on MA
bys countyFIPS: egen eligibles_2000=max(eligibles_aggregate*(year==2000))
sum MA_penetration
sum MA_penetration [aw = eligibles_2000]

//creating weight by population in 2000

/*
////same as using aweights with just the population themselves 
su eligibles_2000 if year==2000, meanonly 
di "Total is " r(sum) 
gen wgt_2000 = eligibles_2000 / r(sum) 
*/ 

drop if missing(eligibles_2000)
drop if missing(MA_penetration)
drop if MA_penetration<=5 //No MA presence at all or less than 5 percent -doing this probably does similar stuff to sample selection as the original paper. Basically start with those with MA_presence. (can also frame as heterogeneity)

sum MA_penetration

sum MA_penetration [aw = eligibles_2000]

gen floorDistance50 = floorDistance/50

reghdfe MA_penetration b2000.year##c.floorDistance50 [pweight= eligibles_2000], absorb(countyFIPS) cluster(countyFIPS)



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

gen floorDistance50 = floorDistance/50 //Scaled by 50, Not that this as not been adjusted by the AR in the original script.

local controls_1 "i.year##c.floor98control i.year##c.blendControl"
local controls_2 "i.year##c.floor98control i.year##c.blendControl i.base2000_group#i.year_minus_1996" //now this control seems to lead to very different results
local controls_3 "i.year##c.floor98control i.year##c.blendControl i.urbanMSA1999#i.year_minus_1996"

forv x = 1/3 {
	reghdfe MA_penetration b2000.year##c.floorDistance50 `controls_`x''[pweight= eligibles_2000], absorb(countyFIPS) cluster(countyFIPS)
}


//looks like there might be some pre-trends. 

