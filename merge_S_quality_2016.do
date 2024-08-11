
*merge the information from hha cost reports section S with quality star ratings information. 
*now just merge with the first time quality ratings, 2016 Jan. 

//convert the quality from CVS 

//Usually 4 times a year for quality data, 01,04, 07, 10. In 2015 missing 04, in 2018 missing 10 in the CVS form, but exists oin the original data form, 2019 has 03 rather than 04, 2020 has 01,04,10, 2021 has 01, 08, 10, 2021 only has 07 and 09, naming of folder started changing this year too. 

//note that there is a difference between quality of patient star ratings (introduced in 2015, includes outcomes and patient survey ratings) and Patient Survey Ratings Star Ratings (2016)

cd "/Users/bubbles/Desktop/HomeHealth/output/"

import delimited "/Users/bubbles/Desktop/hha_data/cms_quality/2016/hhs_revised_flatfiles_archive_01_2016/HHC_SOCRATA_PRVDR.csv", clear 

rename cmscertificationnumberccn prvdr_num

gen year=2016

save quality_201601.dta, replace

use S_all_final, clear

bys prvdr_num year:  gen dup = cond(_N==1,0,_n)

destring prvdr_num, replace 

drop if dup >0 //for now drop all observations if there are duplicates -----probably there is better way to do this should think about 

merge 1:1 prvdr_num year using quality_201601.dta //almost all of master is matched, but not for using 

//around 20% don't have quality star ratings

drop if _merge==2 //drop if only in using
//drop _merge 

//tab qualityofpatientcarestarrating

replace qualityofpatientcarestarrating = "." if qualityofpatientcarestarrating=="Not Available"
destring qualityofpatientcarestarrating, replace //now missings are okay 

//make ratings_2016 variable, that is constant across time 
gen ratings_2016 = qualityofpatientcarestarrating



















