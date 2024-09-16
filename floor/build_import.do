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



use "/Users/bubbles/Desktop/HomeHealth/temp/rate1997.dta", replace 

forvalues i = 1998(1)2011 {
	append using  "/Users/bubbles/Desktop/HomeHealth/temp/rate`i'.dta"
}

append using "/Users/bubbles/Desktop/HomeHealth/temp/rate2001a.dta" 

sort county_ssa year

rename county_ssa countySSA

bys countySSA: egen base_2001a = total(base*(year==20011))

rename base base_nominal 

drop if year==20011 //2001a

save "/Users/bubbles/Desktop/HomeHealth/temp/rate97-11.dta", replace 


use "/Users/bubbles/Desktop/HomeHealth/temp/rate97-11.dta", clear 


merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/Cabral et al replication/Data/PassThroughEventStudies.dta"

drop _merge 

save "/Users/bubbles/Desktop/HomeHealth/temp/data_97-11_working.dta", replace



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


////////

import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2010/risk2010.csv", clear 

*This year use the Pace 2010 rate in th eratebooks

gen row=_n
gen year =2010
rename v1 countySSA
rename v7 rate_09_unadj
rename v8 rate_09_adj
rename v10 ffs_10 //estimated 
rename v12 rate_10_v1_unadj
rename v13 rate_10_v1 
rename v14 rate_10_v2_unadj //pace 
rename v15 rate_10_v2
rename v16 rate_category_10 //100% M, FFS not used this year 

drop if inrange(row,1,15)

keep countySSA year rate_09_unadj rate_09_adj ffs_10 rate_10_v1_unadj rate_10_v1 rate_10_v2_unadj rate_10_v2 rate_category_10

destring, replace 
destring countySSA, replace force 

/*
gen diff= rate_2010_v2-rate_2010_v1 
sum diff, detail 
--difference is pretty small 
*/

save "/Users/bubbles/Desktop/HomeHealth/temp/10_calc.dta", replace

//2011 is just the same, no need to update 


////////

import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2010/risk2010.csv", clear 

*This year use the Pace 2010 rate in th eratebooks

gen row=_n
gen year =2010
rename v1 countySSA
rename v7 rate_09_unadj
rename v8 rate_09_adj
rename v10 ffs_10 //estimated 
rename v12 rate_10_v1_unadj
rename v13 rate_10_v1 
rename v14 rate_10_v2_unadj //pace 
rename v15 rate_10_v2
rename v16 rate_category_10 //100% M, FFS not used this year 

drop if inrange(row,1,15)

keep countySSA year rate_09_unadj rate_09_adj ffs_10 rate_10_v1_unadj rate_10_v1 rate_10_v2_unadj rate_10_v2 rate_category_10

destring, replace 
destring countySSA, replace force 

/*
gen diff= rate_2010_v2-rate_2010_v1 
sum diff, detail 
--difference is pretty small 
*/

save "/Users/bubbles/Desktop/HomeHealth/temp/10_calc.dta", replace

//2011 is the same as 2010, so omitted 

//use pace rates for these other years, this is one rate and between three stars rates and four stars rate. 

//from 2012, potentially because of all the adjustment, new rates are no longer last year*growth rate, some of the results don't match well. But FFS and minimum update rates are given each year, so can just use the given rates. 

//something about new risk score model for non-floor counties. 

import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2012/risk2012 PACE.csv", clear 

gen row=_n
gen year =2012
rename v1 countySSA
rename v8  rate_10_unadj //11 same as 10 
rename v9  rate_10_adj
rename v11 min_update_rate_12
rename v15 ffs_12
rename v16 rate_12 //pace rate1997
rename v17 rate_category_12

drop if inrange(row,1,21)
keep countySSA year rate_10_unadj rate_10_adj ffs_12 rate_12 rate_category_12 min_update_rate_12

destring, replace 
destring ffs_12, replace force //some of the smaller counties that will be removed from analysis had missing here. 

save "/Users/bubbles/Desktop/HomeHealth/temp/12_calc.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2013/risk2013PACE.csv", clear 

gen row=_n
gen year =2013
rename v1 countySSA
rename v8 min_update_rate_13
rename v12 ffs_13
rename v13 rate_13
rename v14 rate_category_13

drop if inrange(row,1,27)

keep countySSA year min_update_rate_13 ffs_13 rate_13 rate_category_13

destring, replace 
destring min_update_rate_13 ffs_13 rate_13, ignore(",") replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/13_calc.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2014/risk2014PACE.csv", clear 

gen row=_n
gen year =2014
rename v1 countySSA
rename v8 min_update_rate_14
rename v12 ffs_14
rename v13 rate_14
rename v14 rate_category_14

drop if inrange(row,1,23)

keep countySSA year min_update_rate_14 ffs_14 rate_14 rate_category_14

destring, replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/14_calc.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2015/csv/risk2015PACE.csv", clear 

gen row=_n
gen year =2015
rename v1 countySSA
rename v8 min_update_rate_15
rename v12 ffs_15
rename v14 rate_15
rename v15 rate_category_15

drop if inrange(row,1,22)

keep countySSA year min_update_rate_15 ffs_15 rate_15 rate_category_15

destring, replace 
destring min_update_rate_15, ignore(",") force replace //2NAs 
destring countySSA, force replace //1 missing value 

save "/Users/bubbles/Desktop/HomeHealth/temp/15_calc.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2016/csv/risk2016PACE.csv", clear 

gen row=_n
gen year =2016
rename v1 countySSA
rename v8 min_update_rate_16
rename v13 ffs_16
rename v16 rate_16
rename v17 rate_category_16
drop if inrange(row,1,25)

keep countySSA year min_update_rate_16 ffs_16 rate_16 rate_category_16

destring countySSA, replace force //5 lines with empty value but data for year
drop if missing(countySSA)
destring min_update_rate_16 ffs_16 rate_16, ignore(",") replace 


save "/Users/bubbles/Desktop/HomeHealth/temp/16_calc.dta", replace


import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2018/csv/risk2018PACE.csv", clear 

gen row=_n
gen year =2018
rename v1 countySSA
rename v8 min_update_rate_18
rename v14 ffs_18
rename v17 rate_18
rename v18 rate_category_18
drop if inrange(row,1,22)

keep countySSA year min_update_rate_18 ffs_18 rate_18 rate_category_18

destring countySSA, replace force //1 missing 
drop if missing(countySSA)
destring min_update_rate_18 ffs_18 rate_18, ignore(",") replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/18_calc.dta", replace



import delimited "/Users/bubbles/Desktop/hha_data/ratebook/ratebook calculations/calculationdata2019/csv/risk2019PACE.csv", clear 

gen row=_n
gen year =2019
rename v1 countySSA
rename v8 min_update_rate_19
rename v13 ffs_19
rename v16 rate_19
rename v17 rate_category_19
drop if inrange(row,1,23)

keep countySSA year min_update_rate_19 ffs_19 rate_19 rate_category_19

destring countySSA, replace force //1 missing 
drop if missing(countySSA)
destring min_update_rate_19 ffs_19 rate_19, ignore(",") replace 

save "/Users/bubbles/Desktop/HomeHealth/temp/19_calc.dta", replace





















