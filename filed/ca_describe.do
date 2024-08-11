
cd /Users/bubbles/Desktop/hha_data/ca_hha/output/
//a quick look at medicare vs medicare advantage 

use hhah22.dta, clear 

keep if ENTITY_TYPE == "Home Health Agency Only"
keep if FAC_OPERATED_THS_YR == "Yes"
destring HHAH_UNDUPLICATED_PERS, replace

bys FAC_NO: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, deleted two observations 
drop dup

replace HHAH_UNDUPLICATED_PERS=0 if missing(HHAH_UNDUPLICATED_PERS)

destring HHAH_HMO_PPO_VISITS, replace 
destring HHAH_MEDICARE_VISITS, replace 
hist HHAH_HMO_PPO_VISITS if HHAH_HMO_PPO_VISITS<=500
count if missing(HHAH_HMO_PPO_VISITS) & !missing(HHAH_TOT_VISITS_BY_SOURCE_OF_PAY) //not sure if missing means 0 or just not recorded, 800 of the agencies are in this section. 
count if missing(HHAH_HMO_PPO_VISITS)
count if HHAH_HMO_PPO_VISITS==0
count if HHAH_MEDICARE_VISITS==0
count if missing(HHAH_MEDICARE_VISITS) //seems like almost everyone accepts medicare but half of the agencies accepts medicare advantage. 

use hhah02.dta, clear 

destring HHA_VISITS_HMO_PPO_PAYER, replace 
destring HHA_VISITS_MCARE_PAYER, replace 

count if HHA_VISITS_HMO_PPO_PAYER==0
count if missing(HHA_VISITS_HMO_PPO_PAYER) 
count if HHA_VISITS_MCARE_PAYER==0


















