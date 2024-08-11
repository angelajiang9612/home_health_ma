//compared to the first version use original nominal numbers rather than adjust to cpi 2000

//build dataset close to the Cabral et al dta//
//rate data from https://www.cms.gov/medicare/payment/medicare-advantage-rates-statistics/ratebooks-supporting-data
//https://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/. (CPS U)

//www.ers.usda.gov/data-products/rural-urban-continuum-codes/ --only once in 10 years, county level //rural urban code data 

//https://seer.cancer.gov/seerstat/variables/countyattribs/ruralurban.html //description of code



cd "/Users/bubbles/Desktop/hha_data/ratebook/clean"


//get nominal base values and value for 2001a from original base rates data 

local cpi 160.5 163.0 166.6 172.2 177.1 179.9 184.0  // cpi from 1997-2003, use 2000 year as based year 

import delimited "rate1997.csv", clear 
rename partaagedrate part_a_aged 
rename partbagedrate part_b_aged
rename ssastatecountycode county_ssa
gen year = 1997
gen base = part_a_aged + part_b_aged
keep state county_ssa base year
order county_ssa year base state 
save "/Users/bubbles/Desktop/HomeHealth/temp/rate1997.dta", replace 


import delimited "rate1998.csv", clear 
rename partaagedrate part_a_aged 
rename partbagedrate part_b_aged
rename ssastatecountycode county_ssa
gen year = 1998
gen base = part_a_aged + part_b_aged
keep state county_ssa base year
order county_ssa year base state 
save "/Users/bubbles/Desktop/HomeHealth/temp/rate1998.dta", replace 


import delimited "rate1999.csv", clear 
rename partaagedrate part_a_aged 
rename partbagedrate part_b_aged
rename ssastatecountycode county_ssa
gen year = 1999
gen base = part_a_aged + part_b_aged
keep state county_ssa base year
order county_ssa year base state 
save "/Users/bubbles/Desktop/HomeHealth/temp/rate1999.dta", replace 


import delimited "rate2000.csv", clear //Cabral et al did not use the other adjustments noted in the csv form 

gen row=_n
drop if inrange(row,1,10)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2000
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2000.dta", replace 

import delimited "rate2001.csv", clear //Cabral et al did not use the other adjustments noted in the csv form, not sure why this is the correct thing to do. 

gen row=_n
drop if inrange(row,1,9)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2001
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2001.dta", replace 


import delimited "rate2001A.csv", clear //Cabral et al did not use the other adjustments noted in the csv form, not sure why this is the correct thing to do. 

gen row=_n
drop if inrange(row,1,10)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =20011 //2001a
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2001a.dta", replace 


import delimited "rate2002.csv", clear //Cabral et al did not use the other adjustments noted in the csv form 
gen row=_n
drop if inrange(row,1,10)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2002
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2002.dta", replace 

import delimited "rate2003.csv", clear //Cabral et al did not use the other adjustments noted in the csv form 
gen row=_n
drop if inrange(row,1,16)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
gen base = part_a_aged + part_b_aged
gen year =2003
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2003.dta", replace 

//

use "/Users/bubbles/Desktop/HomeHealth/temp/rate1997.dta", replace 

forvalues i = 1998(1)2003 {
	append using  "/Users/bubbles/Desktop/HomeHealth/temp/rate`i'.dta"
}


append using "/Users/bubbles/Desktop/HomeHealth/temp/rate2001a.dta"

sort county_ssa year

rename county_ssa countySSA

bys countySSA: egen base_2001a = total(base*(year==20011))

rename base base_nominal 

drop if year==20011

save "/Users/bubbles/Desktop/HomeHealth/temp/rate97-03.dta", replace 



//merging with Cabral data set 

use "/Users/bubbles/Desktop/HomeHealth/temp/rate97-03.dta", clear


merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta"

drop _merge 

save "/Users/bubbles/Desktop/HomeHealth/output/data_97-03.dta", replace


////////////////

use "/Users/bubbles/Desktop/HomeHealth/output/data_97-03.dta", clear

//for the binding ones 

bys countySSA: egen base_2001_nominal = total(base_nominal*(year==2001))

gen floor = base_nominal if binding2001 ==1 & year>=2001. //the observed result is the new floor
replace floor =  base_2001_nominal/1.02 if binding2001 ==1 & year ==2000 
replace floor =  base_2001_nominal/(1.02)^2 if binding2001 ==1 & year ==1999
replace floor =  base_2001_nominal/(1.02)^3 if binding2001 ==1 & year ==1998
replace floor =  base_2001_nominal/(1.02)^4 if binding2001 ==1 & year ==1997

replace base_2001a = base_2001a*1.01  //the 1 percent increase in 2001 is factored in
gen base_ffs = base_nominal if binding2001==1 & year <=2000
replace base_ffs = base_2001a if binding2001==1 & year ==2001
replace base_ffs = base_2001a*(1.02) if binding2001==1 & year ==2002
replace base_ffs = base_2001a*(1.02^2) if binding2001==1 & year ==2003

/////////////////////////
//for the none binding ones 
*two ways this distance (floor - ffs) may be positive:
*before 2001 there are years where ffs is less than deflated floor, though by 2001 ffs increased to higher than floor
*after 2001 ffs increased really slowly (less than increase in floor) so that it became smaller than floor even though it was higher in 2001 
////////////////////////

replace floor = 525 if binding2001 ==0 & year==2001 &urbanMSA1999==1 //need to create floor manually 
replace floor =  525/1.02 if binding2001 ==0 & year == 2000 & urbanMSA1999==1
replace floor =  525/(1.02)^2 if binding2001 ==0 & year == 1999 & urbanMSA1999==1
replace floor =  525/(1.02)^3 if binding2001 ==0 & year == 1998 & urbanMSA1999==1
replace floor =  525/(1.02)^4 if binding2001 ==0 & year == 1997 & urbanMSA1999==1

//forward assume just 2% increase (even though some couties has more than 2% in some years)
replace floor = 525*1.02 if binding2001==0 & year==2002 & urbanMSA1999==1
replace floor = 525*(1.02^2) if binding2001==0 & year==2003 & urbanMSA1999==1

replace floor = 475 if binding2001 ==0 & year==2001 & urbanMSA1999==0 
replace floor = 475/1.02 if binding2001 ==0 & year == 2000 & urbanMSA1999==0
replace floor = 475/(1.02)^2 if binding2001 ==0 & year == 1999 & urbanMSA1999==0
replace floor = 475/(1.02)^3 if binding2001 ==0 & year == 1998 & urbanMSA1999==0
replace floor = 475/(1.02)^4 if binding2001 ==0 & year == 1997 & urbanMSA1999==0

replace floor = 475*1.02 if binding2001==0 & year==2002 & urbanMSA1999==0
replace floor = 475*(1.02^2) if binding2001==0 & year==2003 & urbanMSA1999==0


replace base_ffs = base_nominal if binding2001==0 //738 due to missing urban status

gen distance_test = max(floor - base_ffs,0) 

//normalizing distance to get in 2000 real dollars 


replace distance_test = distance_test*172.2/160.5 if year==1997

replace distance_test = distance_test*172.2/163.0 if year==1998

replace distance_test = distance_test*172.2/166.6 if year==1999

replace distance_test = distance_test*172.2/177.1 if year==2001

replace distance_test = distance_test*172.2/179.9 if year==2002

replace distance_test = distance_test*172.2/184.0  if year==2003

br countySSA year floorDistance distance_test

//the distance variable is identical in <=2000 periods, and almost identical for the after periods. 


//for the nonbinding ones, got almost the same distance for before 2001 but I was not able to have any positive distance for after 2001, they had 487. Whether there should be positive distance is something I should figure out. Appendix A.1 has more details. So it is possible for floors to be updated by more than 2% --is this the cause of these positive numbers? 


///////////////







/*

scrap///

///////testing using my own urban or rural definition///

import excel "/Users/bubbles/Desktop/hha_data/misc_duggan/ruralurbancodes2003.xls", sheet("beale03") firstrow clear

destring, replace

rename RuralurbanContinuumCode code_93
rename E code_03

gen urban_93 =inlist(code_93,0,1,2) 
gen urban_03 =inlist(code_03,1,2) //what is urban does change over time. 
gen urban_99 = urban_93 //93 seems like a good match for the 1999 data Cabral used.
replace urban_99=1 if inlist(code_93,3) & Population >= 250000 //if already metro area in 1993 but population not large enough at the time.  
//but 2003 might be a better match for 2001 than 1999...so probably can just use 2003 one. 

rename FIPSCode countyFIPS
keep countyFIPS CountyName urban_93 urban_99 urban_03

merge 1:n countyFIPS using "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta"

drop merge 

assert urbanMSA1999 == urban_99 if year==1999 //some not the same, not sure if enough to affect results, use Cabral's for now. 

 
use "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta", clear

//for enrollment information they used the last quarter/last month of the year, can get exact results if used that information. 
 
//generate the nominal value of base 

gen base_nominal = base_ if year==2000 
replace base_nominal = base_*160.5/172.2 if year ==1997
replace base_nominal = base_*163.0/172.2 if year ==1998
replace base_nominal = base_*166.6/172.2 if year ==1999
replace base_nominal = base_*177.1/172.2 if year ==2001
replace base_nominal = base_*179.9/172.2 if year ==2002
replace base_nominal = base_*184.0/172.2 if year ==2003

bys countySSA: egen base_2001_nominal = total(base_nominal*(year==2001))

gen binding2001_test =1 if urbanMSA1999==1 & base_2001_nominal==525 //they used the nominal value change to check binding or not
replace binding2001_test =1 if urbanMSA1999==0 & base_2001_nominal==475
replace binding2001_test =0 if missing(binding2001_test)

assert binding2001_test==binding2001 //assertion true --binding for 70% of counties



//generating the distance variable 

/////generate floor and payment in the absence of floor variables for all periods. 

//try nominal first.

//is it possible for the speed the floors increase faster than the speed FFS naturally grow so that some of the non-floor become floors later on?


gen floor = base_nominal if binding2001 ==1 & year>=2001
replace floor =  base_2001_nominal/1.02 if binding2001 ==1 & year ==2000 
replace floor =  base_2001_nominal/(1.02)^2 if binding2001 ==1 & year ==1999
replace floor =  base_2001_nominal/(1.02)^3 if binding2001 ==1 & year ==1998
replace floor =  base_2001_nominal/(1.02)^4 if binding2001 ==1 & year ==1997

bys countySSA: egen base_2000_nominal = total(base_nominal*(year==2000))

gen base_ffs = base_nominal if binding2001==1 & year <=2000
replace base_ffs = base_2000_nominal*1.02 if binding2001==1 & year ==2001
replace base_ffs = base_2000_nominal*(1.02^2) if binding2001==1 & year ==2002
replace base_ffs = base_2000_nominal*(1.02^3) if binding2001==1 & year ==2003


gen distance_test =0 if binding2001==0
replace distance_test = floor - base_no_floor if binding2001==1



/*
forvalues i = 1997(1)1997 {
	import delimited "rate`i'.csv", clear 
	rename partaagedrate part_a_aged 
	rename partbagedrate part_b_aged
	rename ssastatecountycode county_ssa
	gen year = `i'
	gen base = part_a_aged + part_b_aged
	replace base = base*172.2/160.5
	keep state county_ssa base year
	order county_ssa year base state 
	save "/Users/bubbles/Desktop/HomeHealth/temp/rate`i'.dta", replace 
}



bys countySSA: egen base_2001_real = total(base_*(year==2001))
bys countySSA: egen base_2000_real = total(base_*(year==2000))

gen floor_real = base_ if binding2001 ==1 & year>=2001
replace floor_real =  base_2001_real/1.02 if binding2001 ==1 & year ==2000 
replace floor_real =  base_2001_real/(1.02)^2 if binding2001 ==1 & year ==1999
replace floor_real =  base_2001_real/(1.02)^3 if binding2001 ==1 & year ==1998
replace floor_real =  base_2001_real/(1.02)^4 if binding2001 ==1 & year ==1997

gen base_ffs_real = base_ if binding2001==1 & year <=2000
replace base_ffs_real = base_2000_real*1.02 if binding2001==1 & year ==2001
replace base_ffs_real = base_2000_real*(1.02^2) if binding2001==1 & year ==2002
replace base_ffs_real = base_2000_real*(1.02^3) if binding2001==1 & year ==2003

//////////

gen distance_real = floor_real - base_ffs_real



