//for each county each year compute floor and payment absence of floor. For the ones where floor binds, floor is the observed rates, and payment absence floor needs to be calculated. For the ones where floor does not bind, floor needs to be calculated and payment absent of floor is just what is observed. The relevant variables are base_nominal (observed base), floor and base_ffs

//policy details see Cabral et al construction in onenote 

//remove some GUAM and Puerto Rico and VI counties from analysis, they have different systems 

//can update urban rural status more often. Currently 2004 is the lastest because that is the latest in the MA ratebook data. 

local cpi 160.5 163.0 166.6 172.2 177.1 179.9 184.0 188.9 195.3 201.6 207.3 215.303 214.537 218.056 224.939 229.594 232.957 236.736 237.017 240.007	245.120 251.107 255.657	258.811 270.970	292.655	304.702 // cpi from 1997-2023, use 2000 year as based year 

use "/Users/bubbles/Desktop/HomeHealth/temp/data_97-24_working.dta", clear //this is already combined with Cabral's original dataset, which has the distance term but not the floor and the base_FFS terms. 
*base_nominal came from ratebook date, checked after base_nominal adjusted for CPI is the base information in Cabral data

//binding2001 is a variable that is found in Cabral et al. It can be found in 2001 ratebook calculation data, which states what type of calculation is used for a county's final rates. 

//need to create a base_ffs which is payment without the floor, and a floor variable for all years, for both the binding states and the not binding states

/////////////////////////////////////
**1997-2003 follow the paper's method
/////////////////////////////////////

*****for binding ones

**do nominal first, adjust everything by CPI in the end 

bys countySSA: egen base_2001_nominal = total(base_nominal*(year==2001))

gen floor = base_nominal if binding2001 ==1 & inrange(year,2001,2003) //the observed result is the new floor
replace floor =  base_2001_nominal/1.02 if binding2001 ==1 & year ==2000 
replace floor =  base_2001_nominal/(1.02)^2 if binding2001 ==1 & year ==1999
replace floor =  base_2001_nominal/(1.02)^3 if binding2001 ==1 & year ==1998
replace floor =  base_2001_nominal/(1.02)^4 if binding2001 ==1 & year ==1997

replace base_2001a = base_2001a*1.01  //the 1 percent increase in 2001 is factored in

gen base_ffs = base_nominal if binding2001==1 & year <=2000 //previous years base_ffs is just what is observed. 

replace base_ffs = base_2001a if binding2001==1 & year ==2001

local i = 1 

//this needs to be changed later to incorporate how rules actually work
forvalues y = 2002/2003 { 
	replace base_ffs = base_2001a*(1.02^`i') if binding2001==1 & year ==`y'
	local i = `i' + 1 
}


/////////////////////////
//for the none binding ones 
///////////////////////////

*FFS is just what is observed. Floor-ffs is what is constructed, but should generally be 0 anyway. Not sure why we need to do this. (for control group?)

*two ways this distance (floor - ffs) may be positive:
*before 2001 there are years where ffs is less than deflated floor, though by 2001 ffs increased to higher than floor
*after 2001 ffs increased really slowly (less than increase in floor) so that it became smaller than floor even though it was higher in 2001 

//has previous years so can show there's no trend

////////////////////////

replace floor = 525 if binding2001 ==0 & year==2001 &urbanMSA1999==1 //need to create floor manually 
replace floor =  525/1.02 if binding2001 ==0 & year == 2000 & urbanMSA1999==1
replace floor =  525/(1.02)^2 if binding2001 ==0 & year == 1999 & urbanMSA1999==1
replace floor =  525/(1.02)^3 if binding2001 ==0 & year == 1998 & urbanMSA1999==1
replace floor =  525/(1.02)^4 if binding2001 ==0 & year == 1997 & urbanMSA1999==1

//forward assume just 2% increase (even though some couties has more than 2% in some years)
//this part probably less important but need to factor in other changes in the floor. 

replace floor = 525*1.02 if binding2001==0 & year==2002 & urbanMSA1999==1
replace floor = 525*(1.02^2) if binding2001==0 & year==2003 & urbanMSA1999==1

replace floor = 475 if binding2001 ==0 & year==2001 & urbanMSA1999==0 
replace floor = 475/1.02 if binding2001 ==0 & year == 2000 & urbanMSA1999==0
replace floor = 475/(1.02)^2 if binding2001 ==0 & year == 1999 & urbanMSA1999==0
replace floor = 475/(1.02)^3 if binding2001 ==0 & year == 1998 & urbanMSA1999==0
replace floor = 475/(1.02)^4 if binding2001 ==0 & year == 1997 & urbanMSA1999==0

replace floor = 475*1.02 if binding2001==0 & year==2002 & urbanMSA1999==0
replace floor = 475*(1.02^2) if binding2001==0 & year==2003 & urbanMSA1999==0 //can check the urbanMSA thing

replace base_ffs = base_nominal if binding2001==0 & inrange(year,1997,2003)

//738 due to missing urban status

//for these years just use the distance in cabral et al. 


//////////////2004///////////////////

//-use the b (after MMA version)

//generally method seems to work well, blend rate calculation might have some problems. some counties missing FFS_2003 information need to recheck 

//policy reference-MEDICARE ADVANTAGE 2004 PAYMENT INCREASES RESULTING FROM THE MEDICARE MODERNIZATION ACT (MedAvpayrates_2004)

/*
//2004 national average of local rates : $319.88(Part A)   $258.10(Part B)   $577.98(total) 

//urban floor 613.89, rural floor 555.42

--from 2004 rate calculations book

*base nominal (A+B in rates) and rate_04 (take from rate calculation) are the same thing.
*/

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/04_calc.dta"

//get rid of some counties with different system (VI islands, PR and Guam)
gen small_floor = (floor_04 <555)
bys countySSA: egen max_small = max(small_floor)
drop if max_small ==1 //method doesn't work for these anyway 

replace base_nominal = rate_04 if year==2004


*****for binding ones

replace floor=base_nominal if rate_category_04 == "F" & year==2004 
gen base_2004_1 = ffs_04 //2004 fee for service 
bys countySSA: egen base_ffs_2003 = total(base_ffs*(year==2003)) 
gen base_2004_2 = 1.063*base_ffs_2003 if year ==2004 //6.3% increase from last year --! this is sometimes missing should check
gen base_2004_3 = 0.5*577.98 + 0.5*ffs_04  //blend 
replace base_ffs = max(base_2004_1,base_2004_2,base_2004_3) if rate_category_04 == "F" //one of the other categories

****for the non-binding ones 

replace base_ffs = base_nominal if year==2004 & rate_category_04 != "F" 
replace floor = floor_04 if year==2004 & rate_category_04 != "F" //this is just the column of floor values from data 

gen base_test = max(floor_04,base_2004_1,base_2004_2,base_2004_3) //generally identical or very close. 

//check if urban or rural --it seems that some rural ones became urban in 2004

bys countySSA: egen floor_2004 = max(floor_04)
gen urban_04 =1 if inrange(floor_2004,613.89,613.90)
replace urban_04 =0 if inrange(floor_2004,555.41,555.42)

drop small_floor max_small base_2004* base_test rate_category_04 _merge base_ffs_2003 rate_04 


//////////////2005///////////////////

//This year the urban floor was 654.22 and the rural floor was 591.91. 

//This year urban and rural floors are no longer explicitly stated, new urban and rural floors are just 2004 levels * (1+growth rate) (6.6 percentage points)

//80% of counties will receive the minimum update, 20% will get 100% FFS payment 

//check if A+ B is just equal to the results in the caculation data (rate after budget neutral adjustment). 

//blend rate not explicitly stated in documents, just use growth vs FFS and check if results look basically correct. 

//method: max(ffs,1.066*2004 value)

//for now assume urban rural status didn't change from 1999 --check this later 

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/05_calc.dta", force
drop if _merge==2
drop _merge

/*
//test if simple formula works (yes)

bys countySSA: egen base_nominal_2004 = total(base_nominal*(year==2004)) 
gen base_2005_1 = base_nominal_2004*1.066 if year==2005
gen base_2005_2 = ffs_05 if year==2005
gen base_2005_test = max(base_2005_1,base_2005_2) if year==2005
assert base_2005_test == rate_05 if year==2005

*/ 
replace base_nominal = rate_05 if year==2005

//categorize as binding or not 
gen binding =1 if inlist(rate_05,654.22,591.91) & year ==2005 
replace binding =0 if missing(binding) & year ==2005
gen urban=1 if rate_05==654.22 //urban floor binds 
gen rural =1 if rate_05 ==591.91

*****for binding ones

replace floor=base_nominal if binding==1 & year==2005 
replace base_ffs = ffs_05 if binding ==1 & year==2005 //in the absence of law will just be ffs

*in the absence of the law last year*1.066 doesn't make sense because last year is using urban floor too. 

***for not binding ones 

replace base_ffs = base_nominal if year==2005 & binding ==0 
replace floor = 654.22 if year==2005 & binding ==0 & urban_04==1
replace floor = 591.91 if year==2005 & binding ==0 & urban_04==0


///////2006///////////////

//doesn't seem to have FFS information anymore 
//two categories, same as 05
//part D introduced this year 
//bidding also introduced this year
//this year all M 
//floor 620.32 685.62 

//The 2006 national per capita Medicare Advantage growth rate is 4.8 percent (adjusted growth rate).

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/06_calc.dta", force
drop if _merge==2
drop _merge 

/*
////test if simple formula works (yes)
bys countySSA: egen base_nominal_2005 = total(base_nominal*(year==2005)) 
gen base_2006_test = 1.048*base_nominal_2005 if year==2006
*/ 

//////

//categorize as binding or not 
replace base_nominal = rate_06 if year==2006 //identical, don't need this
//categorize as binding or not 
replace binding =1 if inrange(rate_06,685.61,685.63) & year ==2006
replace binding =1 if inrange(rate_06,620.32,620.33) & year ==2006

replace binding =0 if missing(binding) & year ==2006
replace urban=1 if rate_06==685.62 & year==2006 //urban floor binds 
replace rural =1 if inrange(rate_06,620.32,620.33) & year==2006

*****for binding ones

replace floor=base_nominal if binding==1 & year==2006
bys countySSA: egen base_ffs05 = total(base_ffs*(year==2005))

replace base_ffs = base_ffs05*1.048 if binding ==1 & year==2006 //in the absence of law will be last year's ffs*1.048

***for not binding ones 

replace base_ffs = base_nominal if year==2006 & binding ==0 
replace floor = 685.62 if year==2006 & binding ==0 & urban_04==1
replace floor = 620.32 if year==2006 & binding ==0 & urban_04==0

/////////////2007///////////

//use risk version-not sure what the difference is but easy to compute. 
//use the risk2007 data in the calculations file. It contains a 2006 rate before budget neutrality adj. Use this rather than the actual 2006 rates reported (pretty similar but not exactly)
//growth rate is 0.0713
//further times by 1.039 for budget neutrality to get final result 
//urban floor is 765.13, rural floor 692.29
//in this year FFS was recalculated (rebased) to match most recent data

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/07_calc.dta", force
drop if _merge==2
drop _merge 

/*
////test if formula works (yes)  -! check if unadjusted work better here 
gen b_2007_v1 = rate_adjusted_06*1.0713
gen b_2007_v2 = ffs_07
gen base_2007_test = 1.039*max(b_2007_v1,b_2007_v2)
gen diff = base_2007_test - rate_07
*/ 
recast float rate_07, force
replace binding =1 if rate_07==float(765.13) & year ==2007
replace binding =1 if rate_07==float(692.29) & year ==2007
replace binding =0 if missing(binding) & year ==2007
 
*****for binding ones

replace floor=base_nominal if binding==1 & year==2007
replace base_ffs = ffs_07*1.039 if binding==1 & year==2007

***for not binding ones 

replace base_ffs = base_nominal if year==2007 & binding ==0 
replace floor = 765.13 if year==2007 & binding ==0 & urban_04==1
replace floor = 692.29 if year==2007 & binding ==0 & urban_04==0


/////////////2008///////////

*FFS not rebased (new FFS info not collected), this means only the category M is possible, S is not. 
*growth rate is 5.71 
*budget neutrality 1.0169 
*urban floor 791.62, rural 716.25

drop ffs_07 rate_07 rate_07_unadj 

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/08_calc.dta", force
drop if _merge==2
drop _merge 

/*
////formula (note that need to use the 07 before budget neutrality as the base for growth rate)
gen rate_08_test = rate_07_unadj*1.0571*1.0169 if year ==2008
*/ 
 
recast float rate_08, force
replace binding =1 if rate_08==float(791.62) & year ==2008
replace binding =1 if rate_08==float(716.25) & year ==2008
replace binding =0 if missing(binding) & year ==2008

*****for binding ones
replace floor=base_nominal if binding==1 & year==2008
replace base_ffs = ffs_07*1.0571*1.0169 if binding==1 & year==2008 //use the undjusted for budget neutrality version for consistency

***for not binding ones 
replace base_ffs = base_nominal if year==2008 & binding ==0 
replace floor = 791.62 if year==2008 & binding ==0 & urban_04==1
replace floor = 716.25 if year==2008 & binding ==0 & urban_04==0

////////////////////
////2009//////

//4.24 percent 
//rebasement took place, new FFS calculated
//budget neutrality 1.009
//in the calculations data, category information is wrong, F and M not correct

drop rate_08_unadj 

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/09_calc.dta", force
drop if _merge==2
drop _merge 

/*
////formula (mean zero,but difference larger than usual, but probably still small enough to be okay) 
gen b_2009_v1 = rate_08_unadj*1.0424 if year==2009
gen b_2009_v2 = ffs_09 if year==2009
gen base_2009_test = 1.009*max(b_2009_v1,b_2009_v2)
gen diff = base_2009_test - rate_09 
sum diff, detail 
*/ 

recast float rate_09, force
replace binding =1 if rate_09==float(818.77) & year ==2009
replace binding =1 if rate_09==float(740.82) & year ==2009
replace binding =0 if missing(binding) & year ==2009

*****for binding ones

replace floor=base_nominal if binding==1 & year==2009
replace base_ffs = ffs_09*1.009 if binding==1 & year==2009

***for not binding ones 

replace base_ffs = base_nominal if year==2009 & binding ==0 
replace floor = 818.77 if year==2009 & binding ==0 & urban_04==1
replace floor = 740.82 if year==2009 & binding ==0 & urban_04==0

//2010///
**floor not as obvious this year, seems like there may be multiple similar values for one floor? In the calculations data there is pace_rate thing where floors are the same for the correct ones, and similar to the one in main rates, so just use this is probably fine. Should summarize the difference between the pace rate and the main rate reported in ratebook though. 
 
**seems like an all M year -so the new floor counties should be the same as the old floor counties. 






//2011///








































/* 


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



