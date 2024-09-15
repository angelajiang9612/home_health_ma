//need to figure out whether or not floor counties switched or not


//compared to the first version use original nominal numbers rather than adjust to cpi 2000

//build dataset close to the Cabral et al dta//
//rate data from https://www.cms.gov/medicare/payment/medicare-advantage-rates-statistics/ratebooks-supporting-data
//https://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/. (CPS U)

//www.ers.usda.gov/data-products/rural-urban-continuum-codes/ --only once in 10 years, county level //rural urban code data 

//https://seer.cancer.gov/seerstat/variables/countyattribs/ruralurban.html //description of code

cd "/Users/bubbles/Desktop/hha_data/ratebook/clean"

//get nominal base values and value for 2001a from original base rates data 

//There are also regional rates from 2006ish onwards, should check what it means. 

local cpi 160.5 163.0 166.6 172.2 177.1 179.9 184.0 188.9 195.3 201.6 207.3 215.303 214.537 218.056 224.939 229.594 232.957 236.736 237.017 240.007	245.120 251.107 255.657	258.811 270.970	292.655	304.702 // cpi from 1997-2023, use 2000 year as based year 

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

//why is there a 2001A thing? Before and after the implementation of the policy
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


import delimited "rate2004.csv", clear  //use the March-December version

gen row=_n
drop if inrange(row,1,10)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
destring county_ssa, replace force 
drop if missing(county_ssa)
gen base = part_a_aged + part_b_aged
gen year =2004
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2004.dta", replace 

import delimited "rate2005.csv", clear 
gen row=_n
drop if inrange(row,1,12)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
destring county_ssa, replace force 
drop if missing(county_ssa)
gen base = part_a_aged + part_b_aged
gen year =2005
keep state county_ssa base year county_name
order county_ssa year base state county_name

save "/Users/bubbles/Desktop/HomeHealth/temp/rate2005.dta", replace 

import delimited "rate2006.csv", clear 
gen row=_n
drop if inrange(row,1,12)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v4 part_a_aged 
rename v5 part_b_aged
destring, replace
destring county_ssa, replace force 
drop if missing(county_ssa)
gen base = part_a_aged + part_b_aged
gen year =2006
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2006.dta", replace 

//-----------------------------------------------------------------------------------------------------

//The 2007 rates reflect an adjustment of 1.039 for budget neutrality.use the after adjusted category (risk)

import delimited "rate2007.csv", clear 
gen row=_n
//drop if inrange(row,1,9)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v9 base 
destring county_ssa, replace force 
drop if missing(county_ssa)
destring, replace
gen year =2007
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2007.dta", replace 

import delimited "rate2008.csv", clear 
gen row=_n
drop if inrange(row,1,10)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v9 base 
destring county_ssa, replace force 
drop if missing(county_ssa)
destring, replace
gen year =2008
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2008.dta", replace 

import delimited "rate2009.csv", clear 
gen row=_n
drop if inrange(row,1,7)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v9 base 
destring county_ssa, replace force 
drop if missing(county_ssa)
destring, replace
gen year =2009
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2009.dta", replace 

import delimited "rate2010.csv", clear 
gen row=_n
drop if inrange(row,1,5)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v9 base 
destring county_ssa, replace force 
drop if missing(county_ssa)
destring, replace
gen year =2010
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2010.dta", replace 

import delimited "rate2011.csv", clear 
gen row=_n
drop if inrange(row,1,7)
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v9 base 
destring county_ssa, replace force 
drop if missing(county_ssa)
destring, replace
gen year =2011
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2011.dta", replace 

//!!!
//from 2012 year onwards big changes
///different MA star ratings get different rates 
//for current purpose use the rates for four star MA plans, these are the median quality. 
//this is the `risk' version  

import delimited "rate2012.csv", clear  
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v6 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace force ignore(",")
gen year =2012
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2012.dta", replace 

import delimited "rate2013.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v6 base //four star base rates 
drop if inrange(row,1,4)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2013
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2013.dta", replace 

import delimited "rate2014.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v6 base //four star base rates 
drop if inrange(row,1,2)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2014
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2014.dta", replace 

//!!!
//change 
//from this year onwards bonus form, plans with 3.5 stars or less has no bonus, higher ratings plans have bonuses 
//for now use the 3.5% bonus one 
//why is there a substantial decline from previous year?? -----
//--------------something is wrong here, need to work it out ------------------

import delimited "rate2015.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,3)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2015
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2015.dta", replace 


import delimited "rate2016.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2016
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2016.dta", replace 

import delimited "rate2017.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2017
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2017.dta", replace 

import delimited "rate2018.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,4)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2018
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2018.dta", replace 


import delimited "rate2019.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,4)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2019
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2019.dta", replace 

import delimited "rate2020.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2020
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2020.dta", replace 

import delimited "rate2021.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2021
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2021.dta", replace 

import delimited "rate2022.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2022
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2022.dta", replace 


import delimited "rate2023.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2023
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2023.dta", replace 

import delimited "rate2024.csv", clear 
gen row=_n
rename v1 county_ssa 
rename v2 state 
rename v3 county_name 
rename v5 base //four star base rates 
drop if inrange(row,1,5)
destring county_ssa, replace force 
drop if missing(county_ssa)
destring base, replace ignore(",")
gen year =2024
keep state county_ssa base year county_name
order county_ssa year base state county_name
save "/Users/bubbles/Desktop/HomeHealth/temp/rate2024.dta", replace 



//

use "/Users/bubbles/Desktop/HomeHealth/temp/rate1997.dta", replace 

forvalues i = 1998(1)2024 {
	append using  "/Users/bubbles/Desktop/HomeHealth/temp/rate`i'.dta"
}

append using "/Users/bubbles/Desktop/HomeHealth/temp/rate2001a.dta" 

sort county_ssa year

rename county_ssa countySSA

bys countySSA: egen base_2001a = total(base*(year==20011))

rename base base_nominal 

drop if year==20011 //2001a

save "/Users/bubbles/Desktop/HomeHealth/temp/rate97-24.dta", replace 


use "/Users/bubbles/Desktop/HomeHealth/temp/rate97-24.dta", clear 


merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta"

drop _merge 

save "/Users/bubbles/Desktop/HomeHealth/temp/data_97-24_working.dta", replace



/////rate calculations file 


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2004b/aged2004_revised.csv", clear 

gen row=_n

assert v21==v23
gen year =2004
rename v1 countySSA
rename v22 rate_04 
rename v23 rate_category_04
rename v24 floor_04
rename v25 ffs_04
drop if inrange(row,1,13)

keep countySSA year rate_04 rate_category_04 floor_04 ffs_04 

destring, replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/04_calc.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2005/aged2005.csv", clear 

gen row=_n

gen year =2005
rename v1 countySSA
rename v22 rate_05
rename v23 rate_category_05
rename v24 ffs_05
drop if inrange(row,1,7)

keep countySSA year rate_05 rate_category_05 ffs_05 

destring, replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/05_calc.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2006/aged2006.csv", clear 

gen row=_n

gen year =2006
rename v1 countySSA
rename v20 rate_06
rename v21 rate_category_06
drop if inrange(row,1,12)

keep countySSA year rate_06 rate_category_06 

destring, replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/06_calc.dta", replace



import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2007/risk2007.csv", clear 

gen row=_n

gen year =2007
rename v1 countySSA
rename v5 rate_adjusted_06
rename v6 ffs_07
rename v7 rate_07_unadj
rename v8 rate_07
rename v9 rate_category_07

drop if inrange(row,1,15)

keep countySSA year rate_adjusted_06 ffs_07 rate_07_unadj rate_07 rate_category_07

destring, replace 
destring countySSA, replace force 

save "/Users/bubbles/Desktop/HomeHealth/temp/07_calc.dta", replace



import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2008/risk2008.csv", clear 

gen row=_n

gen year =2008
rename v1 countySSA
rename v5 ffs_07
rename v6 rate_07_unadj
rename v9 rate_08_unadj
rename v10 rate_08
rename v11 rate_category_08
drop if inrange(row,1,20)

keep countySSA year ffs_07 rate_07_unadj rate_08_unadj rate_08 rate_category_08 

destring, replace 
destring countySSA, replace force 

save "/Users/bubbles/Desktop/HomeHealth/temp/08_calc.dta", replace

//////////////////

import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2009/risk2009.csv", clear 

gen row=_n

gen year =2009
rename v1 countySSA
rename v5 rate_08_unadj
rename v6 rate_08_adj
rename v8 ffs_09 
rename v9 rate_09_unadj
rename v10 rate_09
rename v11 rate_category_09 //this looks wrong 
drop if inrange(row,1,21)

keep countySSA year rate_08_unadj rate_08_adj ffs_09 rate_09_unadj rate_09 rate_category_09

destring, replace 
destring countySSA, replace force 

save "/Users/bubbles/Desktop/HomeHealth/temp/09_calc.dta", replace







