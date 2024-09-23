

//for each county each year compute floor and payment absence of floor. For the ones where floor binds, floor is the observed rates, and payment absence floor needs to be calculated. For the ones where floor does not bind, floor needs to be calculated and payment absent of floor is just what is observed. The relevant variables are base_nominal (observed base), floor and base_ffs

//policy details see Cabral et al construction in onenote 

//remove some GUAM and Puerto Rico and VI counties from analysis, they have different systems 

//can update urban rural status more often. Currently 2004 is the lastest because that is the latest in the MA ratebook data. - don't need to add in 2013 urban status definition because the policy was not updated again since 2004. Only the 2004 ones carried through. 

 

local cpi 160.5 163.0 166.6 172.2 177.1 179.9 184.0 188.9 195.3 201.6 207.3 215.303 214.537 218.056 224.939 229.594 232.957 236.736 237.017 240.007	245.120 251.107 255.657	258.811 270.970	292.655	304.702 // cpi from 1997-2023, use 2000 year as based year, Source: USDA ERS 

use "/Users/bubbles/Desktop/HomeHealth/temp/data_97-11_working.dta", clear //this is already combined with Cabral's original dataset, which has the distance term but not the floor and the base_FFS terms. 
*base_nominal came from ratebook date, checked after base_nominal adjusted for CPI is the base information in Cabral data

//binding2001 is a variable that is found in Cabral et al. It can be found in 2001 ratebook calculation data, which states what type of calculation is used for a county's final rates. 

//need to create a base_ffs which is payment without the floor, and a floor variable for all years, for both the binding states and the not binding states

//////////////////////////////////////////
// 1997-2003 follow the paper's method  //
//////////////////////////////////////////

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



///////////////////////////////////////
//                2004               //
///////////////////////////////////////


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

///
recast float rate_04, force
gen binding =1 if rate_04==float(613.89) & year ==2004 //get same result as if used caetgory==F, which is available this year
replace binding =1 if rate_04==float(555.42) & year ==2004
replace binding =0 if missing(binding) & year ==2004

*****for binding ones

replace floor=base_nominal if binding==1 & year==2004 
gen base_2004_1 = ffs_04 //2004 fee for service 
bys countySSA: egen base_ffs_2003 = total(base_ffs*(year==2003)) 
gen base_2004_2 = 1.063*base_ffs_2003 if year ==2004 //6.3% increase from last year --! this is sometimes missing should check
gen base_2004_3 = 0.5*577.98 + 0.5*ffs_04  //blend 
replace base_ffs = max(base_2004_1,base_2004_2,base_2004_3) if binding==1 & year==2004 //one of the other categories


****for the non-binding ones 

replace base_ffs = base_nominal if binding==0 & year==2004
replace floor = floor_04 if binding==0 & year==2004 //this is just the column of floor values from data 

//gen base_test = max(floor_04,base_2004_1,base_2004_2,base_2004_3) //generally identical or very close. 

//check if urban or rural --it seems that some rural ones became urban in 2004

bys countySSA: egen floor_2004 = max(floor_04)
recast float floor_2004, force 

gen urban_04 =1 if floor_2004==float(613.89)
replace urban_04 =0 if floor_2004==float(555.42)

drop small_floor max_small base_2004* rate_category_04 _merge base_ffs_2003 rate_04 



///////////////////////////////////////
//                2005               //
///////////////////////////////////////

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
replace binding =1 if inlist(rate_05,654.22,591.91) & year ==2005 
replace binding =0 if missing(binding) & year ==2005

*****for binding ones

replace floor=base_nominal if binding==1 & year==2005 
replace base_ffs = ffs_05 if binding ==1 & year==2005 //in the absence of law will just be ffs

*in the absence of the law last year*1.066 doesn't make sense because last year is using urban floor too. 

***for not binding ones 

replace base_ffs = base_nominal if year==2005 & binding ==0 
replace floor = 654.22 if year==2005 & binding ==0 & urban_04==1
replace floor = 591.91 if year==2005 & binding ==0 & urban_04==0



///////////////////////////////////////
//                2006               //
///////////////////////////////////////

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

***categorize as binding or not

recast float rate_06, force
replace binding =1 if rate_06==float(685.62) & year ==2006
replace binding =1 if rate_06==float(620.32) & year ==2006
replace binding =0 if missing(binding) & year ==2006
 

*****for binding ones

replace floor=base_nominal if binding==1 & year==2006
bys countySSA: egen base_ffs05 = total(base_ffs*(year==2005))

replace base_ffs = base_ffs05*1.048 if binding ==1 & year==2006 //in the absence of law will be last year's ffs*1.048

***for not binding ones 

replace base_ffs = base_nominal if year==2006 & binding ==0 
replace floor = 685.62 if year==2006 & binding ==0 & urban_04==1
replace floor = 620.32 if year==2006 & binding ==0 & urban_04==0


///////////////////////////////////////
//                2007               //
///////////////////////////////////////


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

drop ffs_07 rate_07 rate_07_unadj 


///////////////////////////////////////
//                2008               //
///////////////////////////////////////

*FFS not rebased (new FFS info not collected), this means only the category M is possible, S is not. 
*growth rate is 5.71 
*budget neutrality 1.0169 
*urban floor 791.62, rural 716.25

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/08_calc.dta", force
drop if _merge==2
drop _merge 

/*
////formula (note that need to use the 07 before budget neutrality as the base for growth rate)
*unadjusted previous year*growth rate*budget neutrality
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


///////////////////////////////////////
//                2009               //
///////////////////////////////////////

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

drop rate_09_unadj



///////////////////////////////////////
//                2010               //
///////////////////////////////////////

**adjusted growth rate 0.81%, this seems to be one used in calculation, it seems like the rule is no longer the higher of 2% and growth rate.  
*Urban floor 818.86 (pace rates), rural floor 740.90
*budget neutrality 1.001 
**floor not as obvious this year, seems like there may be multiple similar values for one floor? In the calculations data there is pace_rate thing where floors are the same for the correct ones, and similar to the one in main rates. 
 
**seems like an all M year -so the new floor counties should be the same as the old floor counties. 

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/10_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_10_v2 if year==2010 //this year used pace so it is different. 

/*
//formulae (correct)
gen rate_10_test =rate_09_unadj*1.0081*1.001
*/ 

recast float rate_10_v1 rate_10_v2, force

replace binding =1 if rate_10_v2==float(818.86) & year ==2010
replace binding =1 if rate_10_v2==float(740.90) & year ==2010
replace binding =0 if missing(binding) & year ==2010

*****for binding ones

replace floor=base_nominal if binding==1 & year==2010
replace base_ffs = ffs_10*1.001 if binding==1 & year==2010

***for not binding ones 

replace base_ffs = base_nominal if year==2010 & binding ==0 
replace floor = 818.86 if year==2010 & binding ==0 & urban_04==1
replace floor = 740.90 if year==2010 & binding ==0 & urban_04==0

drop rate_09_unadj rate_09_adj ffs_10 rate_10_v1_unadj rate_10_v1 rate_10_v2_unadj rate_10_v2 rate_category_10



///////////////////////////////////////
//                2011               //
///////////////////////////////////////


*this year the rates are exactly the same as the 2010 rates. So everything else should also be the same. 

bys countySSA: egen binding_10 = total(binding*(year==2010)) 
bys countySSA: egen floor_10 = total(floor*(year==2010)) 
bys countySSA: egen base_ffs_10 = total(base_ffs*(year==2010)) 

//binding 
replace binding = binding_10 if year==2011

*****binding ones*******

replace base_ffs = base_ffs_10 if year==2011
replace floor = floor_10 if year==2011

drop binding_10 floor_10 base_ffs_10

//drop other uncessary stuff 

drop floor_04 ffs_04 floor_2004 rate_05 rate_category_05 ffs_05 rate_06 rate_category_06 base_ffs05 rate_adjusted_06 rate_category_07 ffs_07 rate_07_unadj rate_08 rate_category_08 rate_08_unadj rate_08_adj ffs_09 rate_09 rate_category_09

replace binding = binding2001 if missing(binding)

save "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance_97-11.dta", replace 


//////////expanding to create space for years 2012-2019

use "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance_97-11.dta", clear

drop base_ contract_count mean_premium med_premium zero_premium min_premium max_premium eligibles_aggregate enrollees_aggregate


foreach v in binding2001 countyFIPS urbanMSA1999 Floor98  {
	sort countySSA year 
	by countySSA: replace `v' = `v'[_n-1] if missing(`v')
}

expand 2, gen(expandob)
sort countySSA expandob year

ds year countySSA  state county_name base_2001a binding2001 countyFIPS urbanMSA1999 Floor98  base_2001_nominal urban_04 expandob, not 

local toempty `r(varlist)' //storing all the variables that you want to be empty in a local
foreach var of local toempty{ 
    replace `var' = . if expandob == 1 //making these variables empty
}

bysort countySSA: replace year = year[_n-1]+1 if expandob == 1 

drop if year>2024
drop expandob
save "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance_97-24_draft.dta", replace




////////////////////////////////////////
//                2012               //
///////////////////////////////////////
 
*used pace rates 
*growth rate -0.16%
*urban 816.73, rural 738.98 
use "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance_97-24_draft.dta", clear 

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/12_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_12 if year==2012 

/*
//formulae
gen rate_12_test = max(min_update_rate_12,ffs_12) //min date already included 
gen diff= rate_12_test - rate_12
sum diff, detail
*/

recast float rate_12, force

replace binding =1 if rate_12==float(816.73) & year ==2012
replace binding =1 if rate_12==float(738.98) & year ==2012
replace binding =0 if missing(binding) & year ==2012

*****for binding ones

replace floor=base_nominal if binding==1 & year==2012
replace base_ffs = ffs_12 if binding==1 & year==2012

***for not binding ones 

replace base_ffs = base_nominal if year==2012 & binding ==0 
replace floor = 816.73 if year==2012 & binding ==0 & urban_04==1
replace floor = 738.98 if year==2012 & binding ==0 & urban_04==0

drop rate_10_unadj rate_10_adj ffs_12 rate_12 rate_category_12 min_update_rate_12

//tab binding if year==2012 //binding declined 4 percentage points.



////////////////////////////////////////
//                2013               //
///////////////////////////////////////
 
*used pace rates 
*growth rate 2.8%
*urban 839.6, rural 759.67

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/13_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_13 if year==2013

/*
//formulae
gen rate_13_test = max(min_update_rate_13,ffs_13) //min date already included 
gen diff= rate_13_test - rate_13
sum diff, detail
*/ 

recast float rate_13, force

replace binding =1 if rate_13==float(839.6) & year ==2013
replace binding =1 if rate_13==float(759.67) & year ==2013
replace binding =0 if missing(binding) & year ==2013

*****for binding ones

replace floor=base_nominal if binding==1 & year==2013
replace base_ffs = ffs_13 if binding==1 & year==2013

***for not binding ones 

replace base_ffs = base_nominal if year==2013 & binding ==0 
replace floor = 839.6 if year==2013 & binding ==0 & urban_04==1
replace floor = 759.67 if year==2013 & binding ==0 & urban_04==0

drop  min_update_rate_13 ffs_13 rate_13 rate_category_13

//tab binding if year==2013 


////////////////////////////////////////
//                2014              //
///////////////////////////////////////
 
*used pace rates 
*growth rates 2.96%
*urban 864.45, rural 782.16

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/14_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_14 if year==2014

/*
//formulae
gen rate_14_test = max(min_update_rate_14,ffs_14) //min date already included 
gen diff= rate_14_test - rate_14
sum diff, detail
*/ 

recast float rate_14, force

replace binding =1 if rate_14==float(864.45) & year ==2014
replace binding =1 if rate_14==float(782.16) & year ==2014
replace binding =0 if missing(binding) & year ==2014

*****for binding ones

replace floor=base_nominal if binding==1 & year==2014
replace base_ffs = ffs_14 if binding==1 & year==2014

***for not binding ones 

replace base_ffs = base_nominal if year==2014 & binding ==0 
replace floor = 864.45 if year==2014 & binding ==0 & urban_04==1
replace floor = 782.16 if year==2014 & binding ==0 & urban_04==0

drop  min_update_rate_14 ffs_14 rate_14 rate_category_14

// tab binding if year==2014 2 more % dropped. 




////////////////////////////////////////
//                2015              //
///////////////////////////////////////
 
*used pace rates 
*growth rates -4.07%
*urban 829.27, rural 750.33

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/15_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_15 if year==2015

/*
//formulae
gen rate_15_test = max(min_update_rate_15,ffs_15) //min date already included 
gen diff= rate_15_test - rate_15
sum diff, detail
*/ 

recast float rate_15, force

replace binding =1 if rate_15==float(829.27) & year ==2015
replace binding =1 if rate_15==float(750.33) & year ==2015
replace binding =0 if missing(binding) & year ==2015

*****for binding ones

replace floor=base_nominal if binding==1 & year==2015
replace base_ffs = ffs_15 if binding==1 & year==2015

***for not binding ones 

replace base_ffs = base_nominal if year==2015 & binding ==0 
replace floor = 829.27 if year==2015 & binding ==0 & urban_04==1
replace floor = 750.33 if year==2015 & binding ==0 & urban_04==0

drop  min_update_rate_15 ffs_15 rate_15 rate_category_15

//tab binding if year==2015 



///////////////////////////////////////
//                2016              //
///////////////////////////////////////
 
*used pace rates 
*growth rates 5.04%
*urban 871.07, rural 788.15

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/16_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_16 if year==2016

/*
//formulae
gen rate_16_test = max(min_update_rate_16,ffs_16) //min date already included 
gen diff= rate_16_test - rate_16
sum diff, detail
*/

recast float rate_16, force

replace binding =1 if rate_16==float(871.07) & year ==2016
replace binding =1 if rate_16==float(788.15) & year ==2016
replace binding =0 if missing(binding) & year ==2016

*****for binding ones

replace floor=base_nominal if binding==1 & year==2016
replace base_ffs = ffs_16 if binding==1 & year==2016

***for not binding ones 

replace base_ffs = base_nominal if year==2016 & binding ==0 
replace floor = 871.07 if year==2016 & binding ==0 & urban_04==1
replace floor = 788.15 if year==2016 & binding ==0 & urban_04==0

drop  min_update_rate_16 ffs_16 rate_16 rate_category_16

//tab binding if year==2016 //51.33 percent floor 


///////////////////////////////////////
//                2017              //
///////////////////////////////////////

*used pace rates 
*growth rates 3.08%
*urban 897.90, rural 812.43

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/17_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_17 if year==2017

/*
//formulae
gen rate_17_test = max(min_update_rate_17,ffs_17) //min date already included 
gen diff= rate_17_test - rate_17
sum diff, detail
*/ 

recast float rate_17, force

replace binding =1 if rate_17==float(897.90) & year ==2017
replace binding =1 if rate_17==float(812.43) & year ==2017
replace binding =0 if missing(binding) & year ==2017

*****for binding ones

replace floor=base_nominal if binding==1 & year==2017
replace base_ffs = ffs_17 if binding==1 & year==2017

***for not binding ones 

replace base_ffs = base_nominal if year==2017 & binding ==0 
replace floor = 897.90 if year==2017 & binding ==0 & urban_04==1
replace floor = 812.43 if year==2017 & binding ==0 & urban_04==0

drop  min_update_rate_17 ffs_17 rate_17 rate_category_17

tab binding if year==2017 //48.95%




///////////////////////////////////////
//                2018              //
///////////////////////////////////////

*used pace rates 
*growth rates 2.53%%
*urban 920.62, rural 832.98

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/18_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_18 if year==2018

/*
//formulae
gen rate_18_test = max(min_update_rate_18,ffs_18) //min date already included 
gen diff= rate_18_test - rate_18
sum diff, detail
*/

recast float rate_18, force

replace binding =1 if rate_18==float(920.62) & year ==2018
replace binding =1 if rate_18==float(832.98) & year ==2018
replace binding =0 if missing(binding) & year ==2018

*****for binding ones

replace floor=base_nominal if binding==1 & year==2018
replace base_ffs = ffs_18 if binding==1 & year==2018

***for not binding ones 

replace base_ffs = base_nominal if year==2018 & binding ==0 
replace floor = 920.62 if year==2018 & binding ==0 & urban_04==1
replace floor = 832.98 if year==2018 & binding ==0 & urban_04==0

drop  min_update_rate_18 ffs_18 rate_18 rate_category_18

//tab binding if year==2018 //47.42 


///////////////////////////////////////
//                2019              //
///////////////////////////////////////

*used pace rates 
*growth rates 5.93%%
*urban 975.21, rural 882.38

merge 1:1 countySSA year using "/Users/bubbles/Desktop/HomeHealth/temp/19_calc.dta", force
drop if _merge==2
drop _merge 

replace base_nominal = rate_19 if year==2019

/*
//formulae
gen rate_19_test = max(min_update_rate_19,ffs_19) //min date already included 
gen diff= rate_19_test - rate_19
sum diff, detail
*/

recast float rate_19, force

replace binding =1 if rate_19==float(975.21) & year ==2019
replace binding =1 if rate_19==float(882.38) & year ==2019
replace binding =0 if missing(binding) & year ==2019

*****for binding ones

replace floor=base_nominal if binding==1 & year==2019
replace base_ffs = ffs_19 if binding==1 & year==2019

***for not binding ones 

replace base_ffs = base_nominal if year==2019 & binding ==0 
replace floor = 975.21 if year==2019 & binding ==0 & urban_04==1
replace floor = 882.38 if year==2019 & binding ==0 & urban_04==0

drop  min_update_rate_19 ffs_19 rate_19 rate_category_19

tab binding if year==2019 //46.17 


//gen distance = binding==1*(floor - base_ffs) //this is the actual formula used in the variable description -so this variable is only defined for the binding ones

/* In earlier years sometimes for nonbinding ones base is smaller than floor, can check what is going on. Later years shouldn't matter because this doesn't happen anymore

gen distance = max(floor - base_ffs,0)
gen distance2 = floor - base_ffs if binding==1
replace distance2 =0 if  binding==0

gen diff = distance-distance2 if year<=2003 

br distance floor base_ffs year if binding ==0 & year<=2003

*/ 

gen distance = floor - base_ffs if binding==1
replace distance =0 if  binding==0

//normalizing distance to get in 2000 real dollars 

replace distance = distance*172.2/160.5 if year==1997
replace distance = distance*172.2/163.0 if year==1998
replace distance = distance*172.2/166.6 if year==1999
replace distance = distance*172.2/177.1 if year==2001
replace distance = distance*172.2/179.9 if year==2002
replace distance = distance*172.2/184.0  if year==2003
replace distance = distance*172.2/188.9  if year==2004
replace distance = distance*172.2/195.3  if year==2005
replace distance = distance*172.2/201.6  if year==2006
replace distance = distance*172.2/207.3  if year==2007
replace distance = distance*172.2/215.303  if year==2008
replace distance = distance*172.2/214.537  if year==2009
replace distance = distance*172.2/218.056  if year==2010
replace distance = distance*172.2/224.939  if year==2011

replace distance = distance*172.2/229.594  if year==2012
replace distance = distance*172.2/232.957  if year==2013
replace distance = distance*172.2/236.736  if year==2014
replace distance = distance*172.2/237.017  if year==2015
replace distance = distance*172.2/240.007  if year==2016
replace distance = distance*172.2/245.120 if year==2017
replace distance = distance*172.2/251.107  if year==2018
replace distance = distance*172.2/255.657 if year==2019

local cpi 160.5 163.0 166.6 172.2 177.1 179.9 184.0 188.9 195.3 201.6 207.3 215.303 214.537 218.056 224.939 229.594 232.957 236.736 237.017 240.007	245.120 251.107 255.657	258.811 270.970	292.655	304.702

drop if year>2019 //stop at 2019 for now 

save "/Users/bubbles/Desktop/HomeHealth/temp/MA_distance.dta", replace 

 
 
/* 
 


forvalues v = 1997 (1) 2019 {
	di `v'
	sum binding if year==`v'
}


forvalues v = 1997 (1) 2019 {
	di `v'
	sum distance if year==`v', detail
}

 


/////distance looks okay/////



//2011 wrong, 2004 looks a bit weird (probably because of so many other ways to get high rates)

//

/*
gen diff = floorDistance- distance if year<=2003
sum diff, detail //sort of okay...
*/ 








/*

br countySSA year floorDistance distance





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


gen distance =0 if binding2001==0
replace distance = floor - base_no_floor if binding2001==1



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



