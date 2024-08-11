//try commuting zones or hospital regions as area instead of counties 

//try something that controls for the size of entrants on the left hand side, maybe HHI type? 

//think about the implication of having a lot of zeros for y 

//poisson regressions seem extremely slow 

//try poisson regression and ordered probit regressions 

cd /Users/bubbles/Desktop/HomeHealth/output/

//log using ma_reghdfe_any.log, replace 

use merged_pos_MA.dta, clear

xtset county_id year 

//drop if year >=2019 //trim from top 
keep if year>=2003

//keep if CON==1
//keep if CON==0 

gen exit_any=(n_exits>0 & n_exits!=.)
replace exit_any = . if n_exits==.

gen entry_any=(n_entrants>0 & n_entrants!=.)
replace entry_any = . if n_entrants==.

gen pop_hth = persons_tot/100000
gen n_hosp_phth = n_hospitals/pop_hth


local controls per_capita_income percent_black percent_hispan pop_hth percent_65_74 percent_75_plus n_hosp_phth //same as Huckfeldt et al 2013 but no CON laws yet -used year fixed effects rather than linear time trends. 

local outcomes n_firms n_entrants entry_any n_exits exit_any

//robust standard errors clustered at state level + weighted by county population

putexcel set entry_results.xlsx, modify sheet(2003_summary,replace) 
putexcel A1=("Outcomes ") B1=("2003-2018") C1=("2003-2018(con)") D1=("2003-2018(no con)") ///
E1=("2003-2022") F1=("2003-2022(con)") G1=("2003-2022(no con)") I1=("mean value (03-18)") J1=("mean value (03-22)")

putexcel A3 = ("n_firms") A4 = ("n_entrants") A5 = ("entry_any") A6 = ("n_exits") A7 = ("exit_any") A9 = ("N Cty") A10 = ("N Obs")
 
local i = 2

//2003-2018 
foreach var in `outcomes' {
	local i =`i'+1
	reghdfe `var' penetration `controls' [aweight=pop_hth] if year <=2018, absorb(year county_id) vce (cluster state)
	matrix b = e(b)
	local b=_b[penetration]
	local se_b= _se[penetration]
	local n = e(N)
	local n_c = e(df_a_redundant)

	if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.000000000,0.001) local starb = "***"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.0010000001,0.01) local starb = "**"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.010000001,0.05) local starb = "*"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.050000001,0.10) local starb = "^"
	else local starb = ""
	local b_f : di %9.4f `b'
	putexcel B`i' =("`b_f'`starb'") 	
}
//observations and counties
local i =`i'+2
putexcel B`i'=("`n_c'")
local i =`i'+1
putexcel B`i'=("`n'")

local i = 2

//2003-2018 CON==1 only 
foreach var in `outcomes' {
	local i =`i'+1
	reghdfe `var' penetration `controls' [aweight=pop_hth] if year <=2018 & CON==1, absorb(year county_id) vce (cluster state)
	matrix b = e(b)
	local b=_b[penetration]
	local se_b= _se[penetration]
	local n = e(N)
	local n_c = e(df_a_redundant)

	if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.000000000,0.001) local starb = "***"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.0010000001,0.01) local starb = "**"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.010000001,0.05) local starb = "*"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.050000001,0.10) local starb = "^"
	else local starb = ""
	local b_f : di %9.4f `b'
	putexcel C`i' =("`b_f'`starb'") 	
}
//observations and counties
local i =`i'+2
putexcel C`i'=("`n_c'")
local i =`i'+1
putexcel C`i'=("`n'")


//2003-2018 CON==0 only 

local i = 2

foreach var in `outcomes' {
	local i =`i'+1
	reghdfe `var' penetration `controls' [aweight=pop_hth] if year <=2018 & CON==1, absorb(year county_id) vce (cluster state)
	matrix b = e(b)
	local b=_b[penetration]
	local se_b= _se[penetration]
	local n = e(N)
	local n_c = e(df_a_redundant)

	if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.000000000,0.001) local starb = "***"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.0010000001,0.01) local starb = "**"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.010000001,0.05) local starb = "*"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.050000001,0.10) local starb = "^"
	else local starb = ""
	local b_f : di %9.4f `b'
	putexcel D`i' =("`b_f'`starb'") 	
}
//observations and counties
local i =`i'+2
putexcel D`i'=("`n_c'")
local i =`i'+1
putexcel D`i'=("`n'")

//2003-2022 

local i = 2

foreach var in `outcomes' {
	local i =`i'+1
	reghdfe `var' penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)
	matrix b = e(b)
	local b=_b[penetration]
	local se_b= _se[penetration]
	local n = e(N)
	local n_c = e(df_a_redundant)

	if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.000000000,0.001) local starb = "***"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.0010000001,0.01) local starb = "**"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.010000001,0.05) local starb = "*"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.050000001,0.10) local starb = "^"
	else local starb = ""
	local b_f : di %9.4f `b'
	putexcel E`i' =("`b_f'`starb'") 	
}
//observations and counties
local i =`i'+2
putexcel E`i'=("`n_c'")
local i =`i'+1
putexcel E`i'=("`n'")



//2003-2022 CON==1

local i = 2

foreach var in `outcomes' {
	local i =`i'+1
	reghdfe `var' penetration `controls' [aweight=pop_hth] if CON==1, absorb(year county_id) vce (cluster state)
	matrix b = e(b)
	local b=_b[penetration]
	local se_b= _se[penetration]
	local n = e(N)
	local n_c = e(df_a_redundant)

	if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.000000000,0.001) local starb = "***"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.0010000001,0.01) local starb = "**"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.010000001,0.05) local starb = "*"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.050000001,0.10) local starb = "^"
	else local starb = ""
	local b_f : di %9.4f `b'
	putexcel F`i' =("`b_f'`starb'") 	
}
//observations and counties
local i =`i'+2
putexcel F`i'=("`n_c'")
local i =`i'+1
putexcel F`i'=("`n'")


//2003-2022 CON==0

local i = 2

foreach var in `outcomes' {
	local i =`i'+1
	reghdfe `var' penetration `controls' [aweight=pop_hth] if CON==1, absorb(year county_id) vce (cluster state)
	matrix b = e(b)
	local b=_b[penetration]
	local se_b= _se[penetration]
	local n = e(N)
	local n_c = e(df_a_redundant)

	if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.000000000,0.001) local starb = "***"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.0010000001,0.01) local starb = "**"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.010000001,0.05) local starb = "*"
	else if inrange(2 * ttail(e(df_r), abs(`b'/`se_b')),0.050000001,0.10) local starb = "^"
	else local starb = ""
	local b_f : di %9.4f `b'
	putexcel F`i' =("`b_f'`starb'") 	
}
//observations and counties
local i =`i'+2
putexcel F`i'=("`n_c'")
local i =`i'+1
putexcel F`i'=("`n'")







reghdfe n_firms penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe n_entrants penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe entry_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe n_exits penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe exit_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)



reghdfe n_firms c.penetration##i.CON `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe n_entrants c.penetration##i.CON `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe entry_any c.penetration##i.CON `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe n_exits c.penetration##i.CON `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)

reghdfe exit_any c.penetration##i.CON `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster state)




//preferred--robust standard errors clustered at county level + weighted by county population

reghdfe n_firms penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe n_entrants penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe entry_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe n_exits penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)

reghdfe exit_any penetration `controls' [aweight=pop_hth], absorb(year county_id) vce (cluster county_id)






////////////////all combinations 


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


//robust standard errors clustered at state level 

reghdfe n_firms penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe n_entrants penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe entry_any penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe n_exits penetration `controls', absorb(year county_id) vce (cluster state)

reghdfe exit_any penetration `controls', absorb(year county_id) vce (cluster state)


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






/*

local controls per_capita_income percent_black percent_hispan pop_hth percent_65_74 percent_75_plus n_hosp_phth CON //same as Huckfeldt et al 2013 but no CON laws yet -used year fixed effects rather than linear time trends. 

//state clusters 

*/









