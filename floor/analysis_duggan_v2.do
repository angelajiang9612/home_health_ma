
//this version use the dataset with all time varying controls and base values 
//sep 24 changed controls, added the ones used in the original POS entry exits 

//only the number of firms work for 2007-2019

//controling for time changing populatio

//cluster at cbsa reduced standard errors compared to cluster at county_ssa, but similar after removing 2019

//first data used duggan_pos.dta 

//adding the time varying controls reduced errors. 

use "/Users/bubbles/Desktop/HomeHealth/temp/duggan092624.dta", clear

xtset county_ssa year 
//try to imitate the Duggan et al analysis 


//try the entry exit thing

bys county_ssa: egen ffs_2007 = total(base_ffs*(year==2007)) //not sure why 2004 didn't work for first stage 
gen group =1 if ffs_2007 <576 //affected group (urban indicator)
replace group =2 if inrange(ffs_2007,576,636) //partially affected group
replace group =3 if ffs_2007 >636 //no effect group 

bys county_ssa: egen pop_metro_2007 = total(pop_metro*(year==2007))
bys county_ssa: egen pop_cty_2007 = total(pop_cty*(year==2007))
bys county_ssa: egen ncty_metro_2007 = total(ncty_metro*(year==2007))

keep if inrange(year,2007,2018)
keep if inrange(pop_metro_2007,100000,600000) //important to keep a subset of counties using initial category

//five year FFS verage 
//bys county_ssa: egen ffs_average = mean(base_ffs)

//population 
replace pop_metro= pop_metro/100000
replace pop_cty = pop_cty/100000
gen pop_metro_sq= pop_metro^2
gen pop_cty_sq=pop_cty^2

replace pop_metro_2007= pop_metro_2007/100000
replace pop_cty_2007 = pop_cty_2007/100000
gen pop_metro_2007_sq= pop_metro_2007^2
gen pop_cty_2007_sq=pop_cty_2007^2

gen ncty_inverse = 1/ncty_metro
drop urban_99

//table 3 first stage, roughly similar. The population controls generally don't seem to do much. 

reghdfe base urban pop_metro_2007 pop_metro_2007_sq pop_cty_2007 pop_cty_2007_sq base_ffs [pweight= ncty_inverse] if group==1, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group

reghdfe base urban pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs [pweight= ncty_inverse] if group==2, absorb(year) cluster(cbsa) 

reghdfe base urban pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs [pweight= ncty_inverse] if group==3, absorb(year) cluster(cbsa) 


//penetration

reghdfe penetration urban pop_metro_2007 pop_metro_2007_sq pop_cty_2007 pop_cty_2007_sq base_ffs [pweight= ncty_inverse] if group==1, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group


reghdfe penetration urban pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs [pweight= ncty_inverse] if group==2, absorb(year) cluster(cbsa) 

reghdfe penetration urban pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs [pweight= ncty_inverse] if group==3, absorb(year) cluster(cbsa) 


/////////////////////////////////////////
//IV estimates for entry and exit 

gen exit_any=(n_exits>0 & n_exits!=.)
replace exit_any = . if n_exits==.

gen entry_any=(n_entrants>0 & n_entrants!=.)
replace entry_any = . if n_entrants==.

gen pop_hth = persons_tot/100000
gen n_hosp_phth = n_hospitals/pop_hth

local outcomes n_firms n_entrants entry_any n_exits exit_any 
local controls per_capita_income percent_black percent_hispan percent_65_74 percent_75_plus n_hosp_phth 

foreach var in `outcomes' {
	ivreghdfe `var' pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs `controls' (penetration=urban) if group==1 [aweight= pop_hth], absorb(year) cluster(county_ssa)
	
}

foreach var in `outcomes' {
	ivreghdfe `var' pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs `controls' (penetration=urban) if group==1 & CON==0 [aweight= pop_hth], absorb(year) cluster(county_ssa)
	
}

foreach var in `outcomes' {
	ivreghdfe `var' pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs `controls' (penetration=urban) if group==1 & CON==1 [aweight= pop_hth] , absorb(year) cluster(county_ssa)

}


foreach var in `outcomes' {
	ivreghdfe `var' pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs `controls' (penetration=urban) if group==1 | group==2 [aweight= pop_hth] , absorb(year) cluster(county_ssa)
	
}

foreach var in `outcomes' {
	ivreghdfe `var' pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs `controls' (penetration=urban) if (group==1 | group==2) & CON==0 [aweight= pop_hth], absorb(year) cluster(county_ssa)
	
}

foreach var in `outcomes' {
	ivreghdfe `var' pop_metro pop_metro_sq pop_cty pop_cty_sq base_ffs `controls' (penetration=urban) if (group==1 | group==2) & CON==1 [aweight= pop_hth], absorb(year) cluster(county_ssa)

}




	