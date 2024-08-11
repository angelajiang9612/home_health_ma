//get the data to be in the form we need for regressions

use 2015.dta, clear 

keep varlist 
destring, replace
keep if state_cd=="CA"
sample 5

keep firms_ma //firms that has any MA

//can do subsample analysis by size or proportion of patients that are MA or home health agencies that has the variable occ defined for more periods. --many are small with few patients so occ is probably not well-defined 

//try one year first 

//main thing is need to construct the occ% variable using the various dates in the data. 

//for each id need to construct admission date and discharge date. If no discharge date in that year then assume still there. key variables: M0090_ASMT_CPLT_DT M0100_ASSMT_REASON

//try combinding Medicaid managed care with Medicare Managed Care, or combinding all others in a category with Medicare FFS in a separate category, and just using Medicaid. 

//discharge in general 

//Another dimension to look at is community discharge vs post-acute discharge (source of admission). One would expect a positive relation probably. M1000* variables 

//Another dimension -informal care, living arrangements of patients. e.g. M1100_PTNT_LVG_STUTN

//Other dimensions (e.g. race)

//Quality of Medicare Advantage Plan?

//non-profits for forprofits? chain or non chain. 



//Other reasons why a patient is more profitable? What health conditions matter? 


//could be better to construct facity date occupancy level data first and then merge with resident id level data with admission date. 




//Need to come up with preliminary health controls, can use Gandi's for now. 





