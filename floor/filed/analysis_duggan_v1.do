use "/Users/bubbles/Desktop/HomeHealth/temp/duggan_pos.dta", clear

//try to imitate the Duggan et al analysis 

keep if inrange(year, 2007,2019)
keep if inrange(pop2007_metro,100000,600000) //543 rather than 576 like in their sample
gen above= (pop2007_metro>=250000) 

*compare some summary statistics 
unique county_ssa if above==1 //240 rather than 272 --the above tend to more missing
unique county_ssa if above==0 //303 vs 304
unique cbsa //257 rather than 280, looks like this might be due to population estimates been different to the ones they use in their data. 

//number of counties in metropolitican areas and FFS 2007 spending looks fine
*used the floors I saw the files myself make the groups perform better. 
gen group =1 if ffs_2007 <692.29 //affected group (urban indicator)
replace group =2 if inrange(ffs_2007,692.29,765.13) //partially affected group
replace group =3 if ffs_2007 >765.13 //no effect group 

//nominalize to 2007 levels 
gen base_real = base_nominal if year==2007
replace base_real = base_nominal*207.3/215.303 if year ==2008
replace base_real = base_nominal*207.3/214.537 if year ==2009
replace base_real = base_nominal*207.3/218.056 if year ==2010
replace base_real = base_nominal*207.3/224.939 if year ==2011
replace base_real = base_nominal*207.3/229.594 if year ==2012
replace base_real = base_nominal*207.3/232.957 if year ==2013
replace base_real = base_nominal*207.3/236.736  if year ==2014
replace base_real = base_nominal*207.3/237.017  if year ==2015
replace base_real = base_nominal*207.3/240.007 if year ==2016
replace base_real = base_nominal*207.3/245.120 if year ==2017
replace base_real = base_nominal*207.3/251.107 if year ==2018
replace base_real = base_nominal*207.3/255.657 if year ==2019

replace base_ffs = base_ffs*207.3/215.303 if year ==2008
replace base_ffs = base_ffs*207.3/214.537 if year ==2009
replace base_ffs = base_ffs*207.3/218.056  if year ==2010
replace base_ffs = base_ffs*207.3/224.939 if year ==2011
replace base_ffs = base_ffs*207.3/229.594 if year ==2012
replace base_ffs = base_ffs*207.3/232.957 if year ==2013
replace base_ffs = base_ffs*207.3/236.736  if year ==2014
replace base_ffs = base_ffs*207.3/237.017  if year ==2015
replace base_ffs = base_ffs*207.3/240.007 if year ==2016
replace base_ffs = base_ffs*207.3/245.120 if year ==2017
replace base_ffs = base_ffs*207.3/251.107 if year ==2018
replace base_ffs = base_ffs*207.3/255.657 if year ==2019

//five year FFS verage 
bys county_ssa: egen ffs_average = mean(base_ffs)

//population 
replace pop2007_metro= pop2007_metro/100000
replace pop2007_cty = pop2007_cty/100000
gen pop2007_metro_sq= pop2007_metro^2
gen pop2007_cty_sq=pop2007_cty^2

//
gen ncty_inverse = 1/ncty2007_metro

//table 3 first stage, roughly similar. The population controls generally don't seem to do much. 

reghdfe base_real urban pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average [pweight= ncty_inverse] if group==1, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group

reghdfe base_real urban pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average [pweight= ncty_inverse] if group==2, absorb(year) cluster(cbsa) 

reghdfe base_real urban pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average [pweight= ncty_inverse] if group==3, absorb(year) cluster(cbsa) 

//MA penetration

reghdfe penetration urban pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average [pweight= ncty_inverse] if group==1, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group

reghdfe penetration urban pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average [pweight= ncty_inverse] if group==2, absorb(year) cluster(cbsa) 

reghdfe penetration urban pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average [pweight= ncty_inverse] if group==3, absorb(year) cluster(cbsa) 


//IV estimates for entry and exit 

gen exit_any=(n_exits>0 & n_exits!=.)
replace exit_any = . if n_exits==.

gen entry_any=(n_entrants>0 & n_entrants!=.)
replace entry_any = . if n_entrants==.

local outcomes n_firms n_entrants entry_any n_exits exit_any

//borderline significant for n_firms and magitude okay, not sure if should change weights
foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group 

}

foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1 | group==2, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group -
	
	//estimated effect on n_firms became bigger but less precise

}


foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group 

}

foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1 | group==2, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group -
	
	//estimated effect on n_firms became bigger but less precise

}

local outcomes n_firms n_entrants entry_any n_exits exit_any

foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1 & CON==0, absorb(year) cluster(cbsa) //actual ffs spending is not correlated with base for this group  //estimates got bigger but less precise. 
}

foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if inlist(group,1,2) & CON==0, absorb(year) cluster(cbsa) //actual ffs spending is not 
}



//cluster standard errors at county level, smaller error 

local outcomes n_firms n_entrants entry_any n_exits exit_any

//borderline significant for n_firms and magitude okay, not sure if should change weights
foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1, absorb(year) cluster(county_ssa) //actual ffs spending is not correlated with base for this group 

}

foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1 | group==2, absorb(year) cluster(county_ssa) //actual ffs spending is not correlated with base for this group -

}

local outcomes n_firms n_entrants entry_any n_exits exit_any

foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if group==1 & CON==0, absorb(year) cluster(county_ssa) //actual ffs spending is not correlated with base for this group  //estimates got bigger but less precise. 
}

foreach var in `outcomes' {
	ivreghdfe `var' pop2007_metro pop2007_metro_sq pop2007_cty pop2007_cty_sq ffs_average (penetration=urban) [pweight= ncty_inverse] if inlist(group,1,2) & CON==0, absorb(year) cluster(county_ssa) //actual ffs spending is not 
}



//cluster by county is better, at least doesn't look like all noise 


/*








