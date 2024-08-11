
//to do calculation of number of HHAs to compare with in medicare cost reports 

//for now look at responding operating HHA only


//total across two sheets --but with non responding hard to tell hospice vs home health accurately, have to do basically by name -but has id so can check across to other data sets like POS and medicare cost reports. 
//total across two sheets - not operating 

cd /Users/bubbles/Desktop/hha_data/ca_hha/output/

use hhah02.dta, clear 

gen obs_resp = _N
append using hhah02_nonresp.dta 

gen obs_all = _N 
gen obs_rate = obs_resp/obs_all 

rename HOME_HLTH_ENTITY_TYPE ENTITY_TYPE //renamed to 2022 version 
rename FAC_OPER_CURR_YR      FAC_OPERATED_THS_YR
tab ENTITY_TYPE
tab FAC_OPERATED_THS_YR

keep if ENTITY_TYPE == "HHA Only"
keep if FAC_OPERATED_THS_YR == "YES"

gen obs=_N
gen year = 2002
count


foreach var in 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 {
	
	use hhah`var'.dta, clear 
	gen obs_resp = _N
	append using hhah`var'_nonresp.dta 
	gen obs_all = _N 
	gen obs_rate = obs_resp/obs_all 
	gen year = `var'
	tab year
	tab obs_rate
	rename HOME_HLTH_ENTITY_TYPE ENTITY_TYPE //renamed to 2022 version 
	rename FAC_OPER_CURR_YR      FAC_OPERATED_THS_YR
	//tab ENTITY_TYPE
	//tab FAC_OPERATED_THS_YR
	keep if ENTITY_TYPE == "HHA Only"
	keep if FAC_OPERATED_THS_YR == "Yes"
	count
	save hhah`var'_des_N.dta, replace
}


foreach var in 18 19 20 21 22 {
	use hhah`var'.dta, clear 
	gen obs_resp = _N
	append using hhah`var'_nonresp.dta 
	gen obs_all = _N 
	gen obs_rate = obs_resp/obs_all 
	gen year = `var'
	tab year
	tab obs_rate
	//tab ENTITY_TYPE
	//tab FAC_OPERATED_THS_YR
	keep if ENTITY_TYPE == "Home Health Agency Only"
	keep if FAC_OPERATED_THS_YR == "Yes"
	count 
	save hhah`var'_des_N.dta, replace
}


**still looks like a more than three fold increase in the number of HHAs, seem to match with the Medicare cost reports but N is larger. 

**calculating some market level facts 
**2022 snap shot 

use hhah22.dta, clear 

keep if ENTITY_TYPE == "Home Health Agency Only"
keep if FAC_OPERATED_THS_YR == "Yes"

bys FAC_NO: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, deleted two observations 
drop dup


bysort COUNTY: gen N_firms=_N

bys COUNTY: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, deleted two observations 


insobs 8
replace COUNTY = "NA" if missing(COUNTY) //incorporate those with no HHAs, N=(58-49=9)
replace N_firms =0 if COUNTY == "NA"

sum N_firms, detail
sum N_firms if N_firms>0, detail






///
//2002 snapshot 


use hhah02.dta, clear 

rename HOME_HLTH_ENTITY_TYPE ENTITY_TYPE //renamed to 2022 version 
rename FAC_OPER_CURR_YR      FAC_OPERATED_THS_YR
tab ENTITY_TYPE
tab FAC_OPERATED_THS_YR
keep if ENTITY_TYPE == "HHA Only"
keep if FAC_OPERATED_THS_YR == "YES"

destring HHA_PATIENTS_HHA_UNDUPL, replace

bys OSHPD_ID: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, deleted two observations 
drop dup

replace HHA_PATIENTS_HHA_UNDUPL=0 if missing(HHA_PATIENTS_HHA_UNDUPL)

bys COUNTY: egen total_persons_county = total(HHA_PATIENTS_HHA_UNDUPL)

gen market_share = HHA_PATIENTS_HHA_UNDUPL/total_persons_county

sum HHA_PATIENTS_HHA_UNDUPL if HHA_PATIENTS_HHA_UNDUPL>0, detail 
sum market_share if market_share>0, detail

//excluding LA 

sum HHA_PATIENTS_HHA_UNDUPL if HHA_PATIENTS_HHA_UNDUPL>0 & COUNTY != "Los Angeles", detail 
sum market_share if market_share>0 & COUNTY != "Los Angeles", detail


bys COUNTY: gen N_firms = _N


tab HHAH_REFERRALS
/*
bys COUNTY: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year

insobs 6 
replace COUNTY = "NA" if missing(COUNTY) //incorporate those with no HHAs, N=(58-49=9)
replace N_firms =0 if COUNTY == "NA"

sum N_firms, detail
sum N_firms if N_firms>0, detail

*/ 

////number of patients and market share 


use hhah22.dta, clear 

keep if ENTITY_TYPE == "Home Health Agency Only"
keep if FAC_OPERATED_THS_YR == "Yes"
destring HHAH_UNDUPLICATED_PERS, replace

bys FAC_NO: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, deleted two observations 
drop dup

replace HHAH_UNDUPLICATED_PERS=0 if missing(HHAH_UNDUPLICATED_PERS)

bys COUNTY: egen total_persons_county = total(HHAH_UNDUPLICATED_PERS)

gen market_share = HHAH_UNDUPLICATED_PERS/total_persons_county

sum HHAH_UNDUPLICATED_PERS if HHAH_UNDUPLICATED_PERS>0, detail 
sum market_share if market_share>0, detail

sum HHAH_UNDUPLICATED_PERS if HHAH_UNDUPLICATED_PERS>0 & COUNTY != "Los Angeles", detail 
sum market_share if market_share>0 & COUNTY != "Los Angeles", detail









///////


bys COUNTY: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, deleted two observations 


insobs 8
replace COUNTY = "NA" if missing(COUNTY) //incorporate those with no HHAs, N=(58-49=9)
replace N_firms =0 if COUNTY == "NA"

sum N_firms, detail
sum N_firms if N_firms>0, detail


///look down at the breakdown of visits per episode by type


foreach var in HHAH_REFERRALS_FROM_ANOTHER_HHA HHAH_REFERRALS_FROM_CLINIC HHAH_REFERRALS_FROM_FAMILY_FRIEN HHAH_REFERRALS_FROM_HOSPICE HHAH_REFERRALS_FROM_HSP HHAH_REFERRALS_FROM_LOCAL_HEALTH HHAH_REFERRALS_FROM_LTC HHAH_REFERRALS_FROM_MSSP HHAH_REFERRALS_FROM_PAYER HHAH_REFERRALS_FROM_PHYSICIAN HHAH_REFERRALS_FROM_SELF HHAH_REFERRALS_FROM_SOCIAL_SERVI HHAH_REFERRALS_FROM_OTHER {
	sum `var'
}





















