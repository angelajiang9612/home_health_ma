//try commuting zones or hospital regions as area instead of counties 

//try something that controls for the size of entrants on the left hand side, maybe HHI type? 

//think about the implication of having a lot of zeros for y 

//poisson regressions seem extremely slow 

//try poisson regression and ordered probit regressions 

cd /Users/bubbles/Desktop/HomeHealth/output/

//log using ma_reghdfe_any.log, replace 

use merged_pos_MA.dta, clear

xtset county_id year 

drop if year >=2019 //trim from top 
keep if year>=2008

keep if CON==1
keep if CON==0 

gen exit_any=(n_exits>0 & n_exits!=.)
replace exit_any = . if n_exits==.

gen entry_any=(n_entrants>0 & n_entrants!=.)
replace entry_any = . if n_entrants==.

gen pop_hth = persons_tot/100000
gen n_hosp_phth = n_hospitals/pop_hth


local controls per_capita_income percent_black percent_hispan pop_hth percent_65_74 percent_75_plus n_hosp_phth CON //same as Huckfeldt et al 2013 but no CON laws yet -used year fixed effects rather than linear time trends. 

//robust standard errors 
reghdfe n_firms penetration `controls', absorb(year county_id) vce (robust)

reghdfe n_entrants penetration `controls', absorb(year county_id) vce (robust)

reghdfe entry_any penetration `controls', absorb(year county_id) vce (robust)

reghdfe n_exits penetration `controls', absorb(year county_id) vce (robust)

reghdfe exit_any penetration `controls', absorb(year county_id) vce (robust)

//robust standard errors clustered at county level 

reghdfe n_firms penetration `controls', absorb(year county_id) vce (cluster county_id)

reghdfe n_entrants penetration `controls', absorb(year county_id) vce (cluster county_id)

reghdfe entry_any penetration `controls', absorb(year county_id) vce (cluster county_id)

reghdfe n_exits penetration `controls', absorb(year county_id) vce (cluster county_id)

reghdfe exit_any penetration `controls', absorb(year county_id) vce (cluster county_id)

//robust standard errors + weighted by county population

reghdfe n_firms penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (robust)

reghdfe n_entrants penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (robust)

reghdfe entry_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (robust)

reghdfe n_exits penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (robust)

reghdfe exit_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (robust)

//robust standard errors clustered at county level + weighted by county population

reghdfe n_firms penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe n_entrants penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe entry_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe n_exits penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe exit_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)



local controls per_capita_income percent_black percent_hispan pop_hth percent_65_74 percent_75_plus n_hosp_phth CON //same as Huckfeldt et al 2013 but no CON laws yet -used year fixed effects rather than linear time trends. 

//state clusters 


//robust standard errors clustered at state level + weighted by county population

reghdfe n_firms penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe n_entrants penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe entry_any penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe n_exits penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe exit_any penetration `controls', absorb(year county_id) vce (cluster state)



//robust standard errors clustered at state level + weighted by county population

reghdfe n_firms penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe n_entrants penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe entry_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe n_exits penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe exit_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)



log close 










