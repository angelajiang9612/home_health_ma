//this file combines 20-22 dta files 
//there are 20-21 form 1994 files, but very few observations so ignore for now 
//keep only section S for now
//2021 covid year, less observations and may be very noisy. 

*Note that by design rpt_rec_num will not have duplicates, but prvdr_num will have duplicates because a firm can make multiple submissions during one financial year, each covering section of the year 

*Need to check which record to keep when there are duplicates


clear all
set more off
set maxvar 32767
version 17.0
set seed 0102
macro drop _all

local data_output  "/Users/bubbles/Desktop/HomeHealth/output/"
local data_input "/Users/bubbles/Desktop/hha_data/cost_hha/data/"

forvalues i = 2020/2022 {  
	
	//alpha file 
	use  `data_input'hha_alpha1728_20_`i'_long.dta, replace 
	destring rpt_rec_num, replace 
	rename alphnmrc_itm_txt _ 
	keep if inlist(substr(wksht_cd, 1, 1),"S","F") //keep only those variables in S section 
	gen variable_code = wksht_cd + line_num + clmn_num //generates unique variable code 
	drop wksht_cd line_num clmn_num //need to drop these because they are not constant within rpt_rec_num
	gen testinga=strlen(variable_code)
	tab testinga
	reshape wide _ , i(rpt_rec_num) j(variable_code) string 
	tempfile alpha_`i'
	save `alpha_`i''

	//nmrc file 
	use `data_input'hha_nmrc1728_20_`i'_long.dta, replace 
	destring rpt_rec_num, replace 
	rename itm_val_num _ //string variable 
	keep if inlist(substr(wksht_cd, 1, 1),"S","F") //keep only those variables in S section 
	gen variable_code = wksht_cd + line_num + clmn_num 
	drop wksht_cd line_num clmn_num 
	gen testingb=strlen(variable_code)
	tab testingb
	reshape wide _ , i(rpt_rec_num) j(variable_code) string 
	tempfile nmrc_`i'
	save `nmrc_`i''

	//merge with rpt file 
	use `data_input'hha_rpt1728_20_`i'.dta, replace
	destring rpt_rec_num, replace 
	merge 1:1 rpt_rec_num using `alpha_`i'' //not everything in master is matched, check reason 
	drop _merge 
	merge 1:1 rpt_rec_num using `nmrc_`i''
	drop _merge 
	gen year = `i'
	save `data_output'`i'_SF, replace 
}

	
//converting to long form 

local data_output  "/Users/bubbles/Desktop/HomeHealth/output/"

use  "/Users/bubbles/Desktop/HomeHealth/output/2020_SF", clear 
local data_output  "/Users/bubbles/Desktop/HomeHealth/output/"

forvalues i = 2021/2022 { 
	append using `data_output'`i'_SF, force
	quietly describe 
	di r(k)
} 

save "/Users/bubbles/Desktop/HomeHealth/output/SF_all_20", replace





/*
sort prvdr_num year 

order prvdr_num year _*

order _all, alphabetic

preserve
describe, replace clear
list 
export excel using myfilenew.xlsx, replace first(var)
restore

//https://stackoverflow.com/questions/49850210/excel-formula-to-split-cell-text-based-on-char-count 

*/ 

use "/Users/bubbles/Desktop/HomeHealth/output/SF_all_20", clear 

rename _F1000000010000100 rev_xviii 
rename _F1000000010000200 rev_medicaid 
rename _F1000000010000300 rev_rest
rename _F1000000010000400 rev_total

rename _F1000000020000100 rless_xviii
rename _F1000000020000200 rless_medicaid 
rename _F1000000020000300 rless_rest
rename _F1000000020000400 rless_total

rename _F1000000030000100 rev_net_xviii
rename _F1000000030000200 rev_net_medicaid 
rename _F1000000030000300 rev_net_rest
rename _F1000000030000400 rev_net_total


rename 	_S0000010010000100	_S0000010010000100
rename 	_S0000010020000100	_S0000010020000100
rename 	_S0000010030000100	_S0000010030000100
rename 	_S0000010040000100	_S0000010040000100
rename 	_S0000010050000100	_S0000010050000100
rename 	_S0000010060000200	_S0000010060000200
rename 	_S0000010070000200	_S0000010070000200
rename 	_S0000010080000200	_S0000010080000200
rename 	_S0000010090000200	_S0000010090000200
rename 	_S0000010100000300	_S0000010100000300
rename 	_S0000010110000300	_S0000010110000300
rename 	_S0000010120000300	_S0000010120000300
rename 	_S0000020010000100	_S0000020010000100
rename 	_S0000020010000200	_S0000020010000200
rename 	_S0000020020000100	_S0000020020000100
rename 	_S0000020030000100	_S0000020030000100
rename 	_S0000020040000100	_S0000020040000100
rename 	_S0000030010000100	_S0000030010000100
rename 	_S2000010010000100	street
rename 	_S2000010010000200	po_box
rename 	_S2000010020000100	city
rename 	_S2000010020000200	state
rename 	_S2000010020000300	zip_code
rename 	_S2000010030000100	name
rename 	_S2000010030000200	ccn
rename 	_S2000010030000300	date_certified
rename 	_S2000010040000100	hospice_name
rename 	_S2000010040000200	hospice_ccn
rename 	_S2000010040000300	hospice_date_certified
rename 	_S2000010040100100	_S2000010040100100
rename 	_S2000010040100200	_S2000010040100200
rename 	_S2000010040100300	_S2000010040100300
rename 	_S2000010040200100	_S2000010040200100
rename 	_S2000010040200200	_S2000010040200200
rename 	_S2000010040200300	_S2000010040200300
rename 	_S2000010040300100	_S2000010040300100
rename 	_S2000010040300200	_S2000010040300200
rename 	_S2000010040300300	_S2000010040300300
rename 	_S2000010040400100	_S2000010040400100
rename 	_S2000010040400200	_S2000010040400200
rename 	_S2000010040400300	_S2000010040400300
rename 	_S2000010040500100	_S2000010040500100
rename 	_S2000010040500200	_S2000010040500200
rename 	_S2000010040500300	_S2000010040500300
rename 	_S2000010040600100	_S2000010040600100
rename 	_S2000010040600200	_S2000010040600200
rename 	_S2000010040600300	_S2000010040600300
rename 	_S2000010050000100	cost_reporting_period_from
rename 	_S2000010050000200	cost_reporting_period_to
rename 	_S2000010060000100	type_of_control
rename 	_S2000010070000100	nominal_charge_provider
rename 	_S2000010080000100	contract_pt
rename 	_S2000010090000100	contract_occupation_therapy
rename 	_S2000010100000100	contract_speech_therapy
rename 	_S2000010110000100	_S2000010110000100
rename 	_S2000010120000100	_S2000010120000100
rename 	_S2000010130000100	_S2000010130000100
rename 	_S2000010140000100	_S2000010140000100
rename 	_S2000010140000200	_S2000010140000200
rename 	_S2000010140000300	_S2000010140000300
rename 	_S2000010150000100	_S2000010150000100
rename 	_S2000010160000100	cost_receive_alloc
rename 	_S2000010160000200	cost_no_org
rename 	_S2000010170000100	home_office_name
rename 	_S2000010170000200	home_office_no
rename 	_S2000010170000300	home_office_contractor_no
rename 	_S2000010170000400	home_office_street
rename 	_S2000010170000500	home_office_city
rename 	_S2000010170000600	home_office_state
rename 	_S2000010170000700	home_office_zip_code
rename 	_S2000010170100100	_S2000010170100100
rename 	_S2000010170100200	_S2000010170100200
rename 	_S2000010170100300	_S2000010170100300
rename 	_S2000010170100400	_S2000010170100400
rename 	_S2000010170100500	_S2000010170100500
rename 	_S2000010170100600	_S2000010170100600
rename 	_S2000010170100700	_S2000010170100700
rename 	_S2000010170200100	_S2000010170200100
rename 	_S2000010170200200	_S2000010170200200
rename 	_S2000010170200300	_S2000010170200300
rename 	_S2000010170200400	_S2000010170200400
rename 	_S2000010170200500	_S2000010170200500
rename 	_S2000010170200600	_S2000010170200600
rename 	_S2000010170200700	_S2000010170200700
rename 	_S2000010170300100	_S2000010170300100
rename 	_S2000010170300200	_S2000010170300200
rename 	_S2000010170300300	_S2000010170300300
rename 	_S2000010170300400	_S2000010170300400
rename 	_S2000010170300500	_S2000010170300500
rename 	_S2000010170300600	_S2000010170300600
rename 	_S2000010170300700	_S2000010170300700
rename 	_S2000010170400100	_S2000010170400100
rename 	_S2000010170400200	_S2000010170400200
rename 	_S2000010170400300	_S2000010170400300
rename 	_S2000010170400400	_S2000010170400400
rename 	_S2000010170400500	_S2000010170400500
rename 	_S2000010170400600	_S2000010170400600
rename 	_S2000010170400700	_S2000010170400700
rename 	_S2000010170500100	_S2000010170500100
rename 	_S2000010170500200	_S2000010170500200
rename 	_S2000010170500300	_S2000010170500300
rename 	_S2000010170500400	_S2000010170500400
rename 	_S2000010170500500	_S2000010170500500
rename 	_S2000010170500600	_S2000010170500600
rename 	_S2000010170500700	_S2000010170500700
rename 	_S2000020010000100	_S2000020010000100
rename 	_S2000020010000200	_S2000020010000200
rename 	_S2000020020000100	_S2000020020000100
rename 	_S2000020020000200	_S2000020020000200
rename 	_S2000020020000300	_S2000020020000300
rename 	_S2000020030000100	_S2000020030000100
rename 	_S2000020040000100	_S2000020040000100
rename 	_S2000020040000200	_S2000020040000200
rename 	_S2000020040000300	_S2000020040000300
rename 	_S2000020050000100	_S2000020050000100
rename 	_S2000020060000100	_S2000020060000100
rename 	_S2000020070000100	_S2000020070000100
rename 	_S2000020080000100	_S2000020080000100
rename 	_S2000020090000100	_S2000020090000100
rename 	_S2000020090000200	_S2000020090000200
rename 	_S2000020100000100	_S2000020100000100
rename 	_S2000020100000200	_S2000020100000200
rename 	_S2000020110000100	_S2000020110000100
rename 	_S2000020120000100	_S2000020120000100
rename 	_S2000020130000000	_S2000020130000000
rename 	_S2000020130000100	_S2000020130000100
rename 	_S2000020140000100	_S2000020140000100
rename 	_S3000000010000100	sn_rn_visits_xviii
rename 	_S3000000010000200	sn_rn_patients_xviii
rename 	_S3000000010000300	sn_rn_visits_medicaid 
rename 	_S3000000010000400	sn_rn_patients_medicaid 
rename 	_S3000000010000500	sn_rn_visits_rest
rename 	_S3000000010000600	sn_rn_patients_rest
rename 	_S3000000010000700	sn_rn_visits_total
rename 	_S3000000010000800	sn_rn_patients_total
rename 	_S3000000020000100	sn_lpn_visits_xviii
rename 	_S3000000020000200	sn_lpn_patients_xviii
rename 	_S3000000020000300	sn_lpn_visits_medicaid 
rename 	_S3000000020000400	sn_lpn_patients_medicaid 
rename 	_S3000000020000500	sn_lpn_visits_rest
rename 	_S3000000020000600	sn_lpn_patients_rest
rename 	_S3000000020000700	sn_lpn_visits_total
rename 	_S3000000020000800	sn_lpn_patients_total
rename 	_S3000000030000100	ptm_visits_xviii
rename 	_S3000000030000200	ptm_patients_xviii
rename 	_S3000000030000300	ptm_visits_medicaid 
rename 	_S3000000030000400	ptm_patients_medicaid 
rename 	_S3000000030000500	ptm_visits_rest
rename 	_S3000000030000600	ptm_patients_rest
rename 	_S3000000030000700	ptm_visits_total
rename 	_S3000000030000800	ptm_patients_total
rename 	_S3000000040000100	pta_visits_xviii
rename 	_S3000000040000200	pta_patients_xviii
rename 	_S3000000040000300	pta_visits_medicaid 
rename 	_S3000000040000400	pta_patients_medicaid 
rename 	_S3000000040000500	pta_visits_rest
rename 	_S3000000040000600	pta_patients_rest
rename 	_S3000000040000700	pta_visits_total
rename 	_S3000000040000800	pta_patients_total
rename 	_S3000000050000100	otm_visits_xviii
rename 	_S3000000050000200	otm_patients_xviii
rename 	_S3000000050000300	otm_visits_medicaid 
rename 	_S3000000050000400	otm_patients_medicaid 
rename 	_S3000000050000500	otm_visits_rest
rename 	_S3000000050000600	otm_patients_rest
rename 	_S3000000050000700	otm_visits_total
rename 	_S3000000050000800	otm_patients_total
rename 	_S3000000060000100	ota_visits_xviii
rename 	_S3000000060000200	ota_patients_xviii
rename 	_S3000000060000300	ota_visits_medicaid 
rename 	_S3000000060000400	ota_patients_medicaid 
rename 	_S3000000060000500	ota_visits_rest
rename 	_S3000000060000600	ota_patients_rest
rename 	_S3000000060000700	ota_visits_total
rename 	_S3000000060000800	ota_patients_total
rename 	_S3000000070000100	sp_visits_xviii
rename 	_S3000000070000200	sp_patients_xviii
rename 	_S3000000070000300	sp_visits_medicaid 
rename 	_S3000000070000400	sp_patients_medicaid 
rename 	_S3000000070000500	sp_visits_rest
rename 	_S3000000070000600	sp_patients_rest
rename 	_S3000000070000700	sp_visits_total
rename 	_S3000000070000800	sp_patients_total
rename 	_S3000000080000100	ms_visits_xviii
rename 	_S3000000080000200	ms_patients_xviii
rename 	_S3000000080000300	ms_visits_medicaid 
rename 	_S3000000080000400	ms_patients_medicaid 
rename 	_S3000000080000500	ms_visits_rest
rename 	_S3000000080000600	ms_patients_rest
rename 	_S3000000080000700	ms_visits_total
rename 	_S3000000080000800	ms_patients_total
rename 	_S3000000090000100	hha_visits_xviii
rename 	_S3000000090000200	hha_patients_xviii
rename 	_S3000000090000300	hha_visits_medicaid 
rename 	_S3000000090000400	hha_patients_medicaid 
rename 	_S3000000090000500	hha_visits_rest
rename 	_S3000000090000600	hha_patients_rest
rename 	_S3000000090000700	hha_visits_total
rename 	_S3000000090000800	hha_patients_total
rename 	_S3000000100000500	all_otherservices_other_visits
rename 	_S3000000100000600	all_otherservices_other_patients
rename 	_S3000000100000700	all_otherservices_visits_total
rename 	_S3000000100000800	all_otherservices_patients_total
rename 	_S3000000110000100	total_visits_xviii
rename 	_S3000000110000300	total_visits_medicaid
rename 	_S3000000110000500	total_visits_rest
rename 	_S3000000110000700	total_visits
rename 	_S3000000120000100	hha_hours_xviii
rename 	_S3000000120000300	hha_hours_medicaid
rename 	_S3000000120000500	hha_hours_rest
rename 	_S3000000120000700	hha_hours
rename 	_S3000000130000200	census_unduplicated_xviii
rename 	_S3000000130000400	census_unduplicated_medicaid
rename 	_S3000000130000600	census_unduplicated_rest
rename 	_S3000000130000800	census_unduplicated_total
rename 	_S3000000140000000	hours_week
rename 	_S3000000150000100	admin_staff
rename 	_S3000000150000200	admin_contract
rename 	_S3000000150000300	admin_total
rename 	_S3000000160000100	director_staff
rename 	_S3000000160000200	director_contract
rename 	_S3000000160000300	director_total
rename 	_S3000000170000100	admin_others_staff
rename 	_S3000000170000200	admin_others_contract
rename 	_S3000000170000300	admin_others_total
rename 	_S3000000180000100	nursing_supervisor_staff
rename 	_S3000000180000200	nursing_supervisor_contract
rename 	_S3000000180000300	nursing_supervisor_total
rename 	_S3000000190000100	rn_staff
rename 	_S3000000190000200	rn_contract
rename 	_S3000000190000300	rn_total
rename 	_S3000000200000100	lpn_staff
rename 	_S3000000200000200	lpn_contract
rename 	_S3000000200000300	lpn_total
rename 	_S3000000210000100	pt_supervisor_staff
rename 	_S3000000210000200	pt_supervisor_contract
rename 	_S3000000210000300	pt_supervisor_total
rename 	_S3000000220000100	ptm_staff
rename 	_S3000000220000200	ptm_contract
rename 	_S3000000220000300	ptm_total
rename 	_S3000000230000100	pta_staff
rename 	_S3000000230000200	pta_contract
rename 	_S3000000230000300	pta_total
rename 	_S3000000240000100	ot_supervisor_staff
rename 	_S3000000240000200	ot_supervisor_contract
rename 	_S3000000240000300	ot_supervisor_total
rename 	_S3000000250000100	otm_staff
rename 	_S3000000250000200	otm_contract
rename 	_S3000000250000300	otm_total
rename 	_S3000000260000100	ota_staff
rename 	_S3000000260000200	ota_contract
rename 	_S3000000260000300	ota_total
rename 	_S3000000270000100	sp_supervisor_staff
rename 	_S3000000270000200	sp_supervisor_contract
rename 	_S3000000270000300	sp_supervisor_total
rename 	_S3000000280000100	sp_staff
rename 	_S3000000280000200	sp_contract
rename 	_S3000000280000300	sp_total
rename 	_S3000000290000100	ms_supervisor_staff
rename 	_S3000000290000200	ms_supervisor_contract
rename 	_S3000000290000300	ms_supervisor_total
rename 	_S3000000300000100	ms_staff
rename 	_S3000000300000200	ms_contract
rename 	_S3000000300000300	ms_total
rename 	_S3000000310000100	hha_supervisor_staff
rename 	_S3000000310000200	hha_supervisor_contract
rename 	_S3000000310000300	hha_supervisor_total
rename 	_S3000000320000100	hha_staff
rename 	_S3000000320000200	hha_contract
rename 	_S3000000320000300	hha_total
rename 	_S3000000330000000	_S3000000330000000
rename 	_S3000000330000100	_S3000000330000100
rename 	_S3000000330000200	_S3000000330000200
rename 	_S3000000330000300	_S3000000330000300
rename 	_S3000000330100000	_S3000000330100000
rename 	_S3000000330100100	_S3000000330100100
rename 	_S3000000330100200	_S3000000330100200
rename 	_S3000000330100300	_S3000000330100300
rename 	_S3000000330200000	_S3000000330200000
rename 	_S3000000330200100	_S3000000330200100
rename 	_S3000000330200200	_S3000000330200200
rename 	_S3000000330200300	_S3000000330200300
rename 	_S3000000330300000	_S3000000330300000
rename 	_S3000000330300100	_S3000000330300100
rename 	_S3000000330300200	_S3000000330300200
rename 	_S3000000330300300	_S3000000330300300
rename 	_S3000000330400000	_S3000000330400000
rename 	_S3000000330400100	_S3000000330400100
rename 	_S3000000330400300	_S3000000330400300
rename 	_S3000000330500000	_S3000000330500000
rename 	_S3000000330500100	_S3000000330500100
rename 	_S3000000330500300	_S3000000330500300
rename 	_S3000000330600000	_S3000000330600000
rename 	_S3000000330600100	_S3000000330600100
rename 	_S3000000330600300	_S3000000330600300
rename 	_S3000000330700000	_S3000000330700000
rename 	_S3000000330700100	_S3000000330700100
rename 	_S3000000330700300	_S3000000330700300
rename 	_S3000000330800000	_S3000000330800000
rename 	_S3000000330800100	_S3000000330800100
rename 	_S3000000330800300	_S3000000330800300
rename 	_S3000000330900000	_S3000000330900000
rename 	_S3000000330900100	_S3000000330900100
rename 	_S3000000330900300	_S3000000330900300
rename 	_S3000000331000000	_S3000000331000000
rename 	_S3000000331000100	_S3000000331000100
rename 	_S3000000331000300	_S3000000331000300
rename 	_S3000000331100000	_S3000000331100000
rename 	_S3000000331100200	_S3000000331100200
rename 	_S3000000331100300	_S3000000331100300
rename 	_S3000000340000100	total_cbsas_medicare
rename 	_S3000000350000100	_S3000000350000100
rename 	_S3000000350100100	_S3000000350100100
rename 	_S3000000350200100	_S3000000350200100
rename 	_S3000000350300100	_S3000000350300100
rename 	_S3000000350400100	_S3000000350400100
rename 	_S3000000350500100	_S3000000350500100
rename 	_S3000000350600100	_S3000000350600100
rename 	_S3000000350700100	_S3000000350700100
rename 	_S3000000350800100	_S3000000350800100
rename 	_S3000000350900100	_S3000000350900100
rename 	_S3000000351000100	_S3000000351000100
rename 	_S3000000351100100	_S3000000351100100
rename 	_S3000000351200100	_S3000000351200100
rename 	_S3000000351300100	_S3000000351300100
rename 	_S3000000351400100	_S3000000351400100
rename 	_S3000000351500100	_S3000000351500100
rename 	_S3000000351600100	_S3000000351600100
rename 	_S3000000351700100	_S3000000351700100
rename 	_S3000000351800100	_S3000000351800100
rename 	_S3000000351900100	_S3000000351900100
rename 	_S3000000352000100	_S3000000352000100
rename 	_S3000000352100100	_S3000000352100100
rename 	_S3000000352200100	_S3000000352200100
rename 	_S3000000352300100	_S3000000352300100
rename 	_S3000000352400100	_S3000000352400100
rename 	_S3000000352500100	_S3000000352500100
rename 	_S3000000352600100	_S3000000352600100
rename 	_S3000000352700100	_S3000000352700100
rename 	_S3000000352800100	_S3000000352800100
rename 	_S3000000352900100	_S3000000352900100
rename 	_S3000000353000100	_S3000000353000100
rename 	_S3000000353100100	_S3000000353100100
rename 	_S3000000353200100	_S3000000353200100
rename 	_S3000000353300100	_S3000000353300100
rename 	_S3000000353400100	_S3000000353400100
rename 	_S3000000353500100	_S3000000353500100
rename 	_S3000040010000100	sn_visits_full_episode
rename 	_S3000040010000200	sn_visits_full_episode_o
rename 	_S3000040010000300	sn_visits_lupa
rename 	_S3000040010000400	sn_visits_pep
rename 	_S3000040010000500	sn_visits_total_medicare
rename 	_S3000040020000100	sn_charges_full_episode
rename 	_S3000040020000200	sn_charges_full_episode_o
rename 	_S3000040020000300	sn_charges_lupa
rename 	_S3000040020000400	sn_charges_pep
rename 	_S3000040020000500	sn_charges_total
rename 	_S3000040030000100	pt_visits_full_episode
rename 	_S3000040030000200	pt_visits_full_episode_o
rename 	_S3000040030000300	pt_visits_lupa
rename 	_S3000040030000400	pt_visits_pep
rename 	_S3000040030000500	pt_visits_total_medicare
rename 	_S3000040040000100	pt_charges_full_episode
rename 	_S3000040040000200	pt_charges_full_episode_o
rename 	_S3000040040000300	pt_charges_lupa
rename 	_S3000040040000400	pt_charges_pep
rename 	_S3000040040000500	pt_charges_total
rename 	_S3000040050000100	ot_visits_full_episode
rename 	_S3000040050000200	ot_visits_full_episode_o
rename 	_S3000040050000300	ot_visits_lupa
rename 	_S3000040050000400	ot_visits_pep
rename 	_S3000040050000500	ot_visits_total_medicare
rename 	_S3000040060000100	ot_charges_full_episode
rename 	_S3000040060000200	ot_charges_full_episode_o
rename 	_S3000040060000300	ot_charges_lupa
rename 	_S3000040060000400	ot_charges_pep
rename 	_S3000040060000500	ot_charges_total
rename 	_S3000040070000100	sp_visits_full_episode
rename 	_S3000040070000200	sp_visits_full_episode_o
rename 	_S3000040070000300	sp_visits_lupa
rename 	_S3000040070000400	sp_visits_pep
rename 	_S3000040070000500	sp_visits_total_medicare
rename 	_S3000040080000100	sp_charges_full_episode
rename 	_S3000040080000200	sp_charges_full_episode_o
rename 	_S3000040080000300	sp_charges_lupa
rename 	_S3000040080000400	sp_charges_pep
rename 	_S3000040080000500	sp_charges_total
rename 	_S3000040090000100	ms_visits_full_episode
rename 	_S3000040090000200	ms_visits_full_episode_o
rename 	_S3000040090000300	ms_visits_lupa
rename 	_S3000040090000400	ms_visits_pep
rename 	_S3000040090000500	ms_visits_total_medicare
rename 	_S3000040100000100	ms_charges_full_episode
rename 	_S3000040100000200	ms_charges_full_episode_o
rename 	_S3000040100000300	ms_charges_lupa
rename 	_S3000040100000400	ms_charges_pep
rename 	_S3000040100000500	ms_charges_total
rename 	_S3000040110000100	hha_visits_full_episode
rename 	_S3000040110000200	hha_visits_full_episode_o
rename 	_S3000040110000300	hha_visits_lupa
rename 	_S3000040110000400	hha_visits_pep
rename 	_S3000040110000500	hha_visits_total_medicare
rename 	_S3000040120000100	hha_charges_full_episode
rename 	_S3000040120000200	hha_charges_full_episode_o
rename 	_S3000040120000300	hha_charges_lupa
rename 	_S3000040120000400	hha_charges_pep
rename 	_S3000040120000500	hha_charges_total
rename 	_S3000040130000100	total_visits_full_episode
rename 	_S3000040130000200	total_visits_full_episode_o
rename 	_S3000040130000300	total_visits_lupa
rename 	_S3000040130000400	total_visits_pep
rename 	_S3000040130000500	total_visits_pps
rename 	_S3000040140000100	other_charges_full_episode
rename 	_S3000040140000200	other_charges_full_episode_o
rename 	_S3000040140000300	other_charges_lupa
rename 	_S3000040140000400	other_charges_pep
rename 	_S3000040140000500	other_charges_pps
rename 	_S3000040150000100	total_charges_full_episode
rename 	_S3000040150000200	total_charges_full_episode_o
rename 	_S3000040150000300	total_charges_lupa
rename 	_S3000040150000400	total_charges_pep
rename 	_S3000040150000500	total_charges_pps
rename 	_S3000040160000100	total_episodes_full
rename 	_S3000040160000300	total_episodes_lupa
rename 	_S3000040160000400	total_episodes_pep
rename 	_S3000040160000500	total_episodes_pps
rename 	_S3000040170000200	total_outlier_outlier
rename 	_S3000040170000400	total_outlier_pep
rename 	_S3000040170000500	total_outlier_pps
rename 	_S3000040180000100	total_nrms_full
rename 	_S3000040180000200	total_nrms_outlier
rename 	_S3000040180000300	total_nrms_lupa
rename 	_S3000040180000400	total_nrms_pep
rename 	_S3000040180000500	total_nrms_pps
rename 	_S3000050010000100	_S3000050010000100
rename 	_S3000050010000200	_S3000050010000200
rename 	_S3000050010000300	_S3000050010000300
rename 	_S3000050010000400	_S3000050010000400
rename 	_S3000050010000500	_S3000050010000500
rename 	_S3000050020000100	_S3000050020000100
rename 	_S3000050020000200	_S3000050020000200
rename 	_S3000050020000300	_S3000050020000300
rename 	_S3000050020000400	_S3000050020000400
rename 	_S3000050020000500	_S3000050020000500
rename 	_S3000050030000100	_S3000050030000100
rename 	_S3000050030000200	_S3000050030000200
rename 	_S3000050030000300	_S3000050030000300
rename 	_S3000050030000400	_S3000050030000400
rename 	_S3000050030000500	_S3000050030000500
rename 	_S3000050040000100	_S3000050040000100
rename 	_S3000050040000200	_S3000050040000200
rename 	_S3000050040000300	_S3000050040000300
rename 	_S3000050040000400	_S3000050040000400
rename 	_S3000050040000500	_S3000050040000500
rename 	_S3000050050000100	_S3000050050000100
rename 	_S3000050050000200	_S3000050050000200
rename 	_S3000050050000300	_S3000050050000300
rename 	_S3000050050000400	_S3000050050000400
rename 	_S3000050050000500	_S3000050050000500
rename 	_S3000050060000100	_S3000050060000100
rename 	_S3000050060000200	_S3000050060000200
rename 	_S3000050060000300	_S3000050060000300
rename 	_S3000050060000400	_S3000050060000400
rename 	_S3000050060000500	_S3000050060000500
rename 	_S3000050070000100	_S3000050070000100
rename 	_S3000050070000200	_S3000050070000200
rename 	_S3000050070000300	_S3000050070000300
rename 	_S3000050070000400	_S3000050070000400
rename 	_S3000050070000500	_S3000050070000500
rename 	_S3000050080000100	_S3000050080000100
rename 	_S3000050080000200	_S3000050080000200
rename 	_S3000050080000300	_S3000050080000300
rename 	_S3000050080000400	_S3000050080000400
rename 	_S3000050080000500	_S3000050080000500
rename 	_S3000050090000100	_S3000050090000100
rename 	_S3000050090000200	_S3000050090000200
rename 	_S3000050090000300	_S3000050090000300
rename 	_S3000050090000400	_S3000050090000400
rename 	_S3000050090000500	_S3000050090000500
rename 	_S3000050100000100	_S3000050100000100
rename 	_S3000050100000200	_S3000050100000200
rename 	_S3000050100000300	_S3000050100000300
rename 	_S3000050100000400	_S3000050100000400
rename 	_S3000050100000500	_S3000050100000500
rename 	_S3000050110000100	_S3000050110000100
rename 	_S3000050110000200	_S3000050110000200
rename 	_S3000050110000300	_S3000050110000300
rename 	_S3000050110000400	_S3000050110000400
rename 	_S3000050110000500	_S3000050110000500
rename 	_S3000050120000100	_S3000050120000100
rename 	_S3000050120000200	_S3000050120000200
rename 	_S3000050120000300	_S3000050120000300
rename 	_S3000050120000400	_S3000050120000400
rename 	_S3000050120000500	_S3000050120000500
rename 	_S3000050130000100	_S3000050130000100
rename 	_S3000050130000200	_S3000050130000200
rename 	_S3000050130000300	_S3000050130000300
rename 	_S3000050130000400	_S3000050130000400
rename 	_S3000050130000500	_S3000050130000500
rename 	_S3000050140000100	_S3000050140000100
rename 	_S3000050140000300	_S3000050140000300
rename 	_S3000050140000400	_S3000050140000400
rename 	_S3000050140000500	_S3000050140000500
rename 	_S3000050150000100	_S3000050150000100
rename 	_S3000050150000300	_S3000050150000300
rename 	_S3000050150000400	_S3000050150000400
rename 	_S3000050150000500	_S3000050150000500
rename 	_S3000050160000100	_S3000050160000100
rename 	_S3000050160000300	_S3000050160000300
rename 	_S3000050160000400	_S3000050160000400
rename 	_S3000050160000500	_S3000050160000500
rename 	_S3000050170000100	_S3000050170000100
rename 	_S3000050170000300	_S3000050170000300
rename 	_S3000050170000400	_S3000050170000400
rename 	_S3000050170000500	_S3000050170000500
rename 	_S3000050180000100	_S3000050180000100
rename 	_S3000050180000300	_S3000050180000300
rename 	_S3000050180000400	_S3000050180000400
rename 	_S3000050180000500	_S3000050180000500
rename 	_S3000050190000100	_S3000050190000100
rename 	_S3000050190000300	_S3000050190000300
rename 	_S3000050190000400	_S3000050190000400
rename 	_S3000050190000500	_S3000050190000500
rename 	_S3000050200000100	_S3000050200000100
rename 	_S3000050200000300	_S3000050200000300
rename 	_S3000050200000400	_S3000050200000400
rename 	_S3000050200000500	_S3000050200000500
rename 	_S3000050210000100	_S3000050210000100
rename 	_S3000050210000300	_S3000050210000300
rename 	_S3000050210000400	_S3000050210000400
rename 	_S3000050210000500	_S3000050210000500
rename 	_S3000050220000100	_S3000050220000100
rename 	_S3000050220000300	_S3000050220000300
rename 	_S3000050220000400	_S3000050220000400
rename 	_S3000050220000500	_S3000050220000500
rename 	_S3000050230000100	_S3000050230000100
rename 	_S3000050230000300	_S3000050230000300
rename 	_S3000050230000400	_S3000050230000400
rename 	_S3000050230000500	_S3000050230000500
rename 	_S3000050240000100	_S3000050240000100
rename 	_S3000050240000300	_S3000050240000300
rename 	_S3000050240000400	_S3000050240000400
rename 	_S3000050240000500	_S3000050240000500
rename 	_S3000050250000100	_S3000050250000100
rename 	_S3000050250000300	_S3000050250000300
rename 	_S3000050250000400	_S3000050250000400
rename 	_S3000050250000500	_S3000050250000500
rename 	_S3000050260000100	_S3000050260000100
rename 	_S3000050260000300	_S3000050260000300
rename 	_S3000050260000400	_S3000050260000400
rename 	_S3000050260000500	_S3000050260000500
rename 	_S4100000010000100	_S4100000010000100
rename 	_S4100000010000200	_S4100000010000200
rename 	_S4100000010000300	_S4100000010000300
rename 	_S4100000010000400	_S4100000010000400
rename 	_S4100000020000100	_S4100000020000100
rename 	_S4100000020000200	_S4100000020000200
rename 	_S4100000020000300	_S4100000020000300
rename 	_S4100000020000400	_S4100000020000400
rename 	_S4100000030000100	_S4100000030000100
rename 	_S4100000030000200	_S4100000030000200
rename 	_S4100000030000300	_S4100000030000300
rename 	_S4100000030000400	_S4100000030000400
rename 	_S4100000040000100	_S4100000040000100
rename 	_S4100000040000200	_S4100000040000200
rename 	_S4100000040000300	_S4100000040000300
rename 	_S4100000040000400	_S4100000040000400
rename 	_S4100000050000100	_S4100000050000100
rename 	_S4100000050000200	_S4100000050000200
rename 	_S4100000050000300	_S4100000050000300
rename 	_S4100000050000400	_S4100000050000400
rename 	_S4100000060000100	_S4100000060000100
rename 	_S4100000060000200	_S4100000060000200
rename 	_S4100000060000300	_S4100000060000300
rename 	_S4100000060000400	_S4100000060000400
rename 	_S4100000070000100	_S4100000070000100
rename 	_S4100000070000200	_S4100000070000200
rename 	_S4100000070000300	_S4100000070000300
rename 	_S4100000070000400	_S4100000070000400
rename 	_S4200000010000100	_S4200000010000100
rename 	_S4200000010000300	_S4200000010000300
rename 	_S4200000010000400	_S4200000010000400
rename 	_S4200000020000100	_S4200000020000100
rename 	_S4200000020000200	_S4200000020000200
rename 	_S4200000020000300	_S4200000020000300
rename 	_S4200000020000400	_S4200000020000400
rename 	_S4200000030000100	_S4200000030000100
rename 	_S4200000030000200	_S4200000030000200
rename 	_S4200000030000300	_S4200000030000300
rename 	_S4200000030000400	_S4200000030000400
rename 	_S4200000040000100	_S4200000040000100
rename 	_S4200000040000200	_S4200000040000200
rename 	_S4200000040000300	_S4200000040000300
rename 	_S4200000040000400	_S4200000040000400
rename 	_S4200000050000100	_S4200000050000100
rename 	_S4200000050000200	_S4200000050000200
rename 	_S4200000050000300	_S4200000050000300
rename 	_S4200000050000400	_S4200000050000400
rename 	_S4200000060000100	_S4200000060000100
rename 	_S4200000060000400	_S4200000060000400
rename 	_S4200000070000100	_S4200000070000100
rename 	_S4200000070000300	_S4200000070000300
rename 	_S4200000070000400	_S4200000070000400
rename 	_S4300000020000100	_S4300000020000100
rename 	_S4300000020000200	_S4300000020000200
rename 	_S4300000020000300	_S4300000020000300
rename 	_S4300000020000400	_S4300000020000400
rename 	_S4300000030000100	_S4300000030000100
rename 	_S4300000030000200	_S4300000030000200
rename 	_S4300000030000300	_S4300000030000300
rename 	_S4300000030000400	_S4300000030000400
rename 	_S4300000040000100	_S4300000040000100
rename 	_S4300000040000400	_S4300000040000400
rename 	_S4300000050000100	_S4300000050000100
rename 	_S4300000050000200	_S4300000050000200
rename 	_S4300000050000300	_S4300000050000300
rename 	_S4300000050000400	_S4300000050000400
rename 	_S4300000060000100	_S4300000060000100
rename 	_S4300000060000300	_S4300000060000300
rename 	_S4300000060000400	_S4300000060000400
rename 	_S4300000070000100	_S4300000070000100
rename 	_S4300000070000400	_S4300000070000400
rename 	_S4400000020000100	_S4400000020000100
rename 	_S4400000020000200	_S4400000020000200
rename 	_S4400000020000300	_S4400000020000300
rename 	_S4400000020000400	_S4400000020000400
rename 	_S4400000030000100	_S4400000030000100
rename 	_S4400000030000300	_S4400000030000300
rename 	_S4400000030000400	_S4400000030000400
rename 	_S4400000050000100	_S4400000050000100
rename 	_S4400000050000200	_S4400000050000200
rename 	_S4400000050000300	_S4400000050000300
rename 	_S4400000050000400	_S4400000050000400
rename 	_S4400000060000100	_S4400000060000100
rename 	_S4400000060000400	_S4400000060000400

drop _S* //for now just ignore the ones I am not currently using 

//create equivalents for the variables in the 94 form, problematic for the reasons explained in the sn section. 

gen sn_visits_rest = sn_rn_visits_rest + sn_lpn_visits_rest
gen pt_visits_rest = ptm_visits_rest + pta_visits_rest 
gen ot_visits_rest = otm_visits_rest + ota_visits_rest 


gen	sn_visits_xviii	= sn_rn_visits_xviii + sn_lpn_visits_xviii //need to do something with zeros and stuff 
gen	sn_patients_xviii	= sn_rn_patients_xviii + sn_lpn_patients_xviii 
gen	sn_visits_others	= sn_rn_visits_medicaid + sn_rn_visits_rest + sn_lpn_visits_medicaid + sn_lpn_visits_rest //includes both medicaid and the rest section 
gen	sn_patient_others	= sn_rn_patients_medicaid  + sn_rn_patients_rest + sn_lpn_patients_medicaid + sn_lpn_patients_rest
gen	sn_visits_total	= sn_rn_visits_total + sn_lpn_visits_total //this could be wrong, lpn and rn can do visits together 
gen	sn_patients_total	= sn_rn_patients_total + sn_lpn_patients_total //this probably is problematic, same patient can need both
gen	pt_visits_xviii	= ptm_visits_xviii + pta_visits_xviii
gen	pt_patients_xviii	= ptm_patients_xviii + pta_patients_xviii
gen	pt_visits_others	= ptm_visits_medicaid  + ptm_visits_rest + pta_visits_medicaid  + pta_visits_rest 
gen	pt_patient_others	= ptm_patients_medicaid  + ptm_patients_rest + pta_patients_medicaid  + pta_patients_rest 
gen	pt_visits_total	= ptm_visits_total + pta_visits_total
gen	pt_patients_total	= ptm_patients_total + pta_patients_total
gen	ot_visits_xviii	= otm_visits_xviii + ota_visits_xviii
gen	ot_patients_xviii	= otm_patients_xviii + ota_patients_xviii
gen	ot_visits_others	= otm_visits_medicaid  + otm_visits_rest + ota_visits_medicaid  + ota_visits_rest 
gen	ot_patient_others	= otm_patients_medicaid  + otm_patients_rest + ota_patients_medicaid  + ota_patients_rest 
gen	ot_visits_total	= otm_visits_total + ota_visits_total
gen	ot_patients_total	= otm_patients_total + ota_patients_total
// gen	sp_visits_xviii //this is the same as in 1994 form, wording went from speech to speech-language 
// gen	sp_patients_xviii // this is same as 1994 form wording went from speech to speech-language 
gen	sp_visits_others	= sp_visits_medicaid + sp_visits_rest
gen	sp_patient_others	= sp_patients_medicaid + sp_patients_rest 
//gen	sp_visits_total	// this is same as 1994 form
// gen	sp_patients_total // this is same as 1994 form
// gen	ms_visits_xviii	
// gen	ms_patients_xviii	=
gen	ms_visits_others	= ms_visits_medicaid  + ms_visits_rest 
gen	ms_patient_others	= ms_patients_medicaid  + ms_patients_rest 
// gen	ms_visits_total	=
// gen	ms_patients_total	
//gen	hha_visits_xviii	
//gen	hha_patients_xviii	
gen	hha_visits_others	= hha_visits_medicaid + hha_visits_rest
gen	hha_patient_others	= hha_patients_medicaid + hha_patients_rest //note a s missing here 
//gen	hha_visits_total	
//gen	hha_visits_patients	

//per person 

local types sn_rn sn_lpn ptm pta otm ota sp ms hha 

foreach var in `types' {
	gen  `var'_visits_pi_xviii = `var'_visits_xviii/`var'_patients_xviii 
	replace `var'_visits_pi_xviii=round(`var'_visits_pi_xviii)
	gen  `var'_visits_pi_medicaid = `var'_visits_medicaid/`var'_patients_medicaid 
	replace `var'_visits_pi_xviii=round(`var'_visits_pi_xviii)
	gen  `var'_visits_pi_rest = `var'_visits_rest/`var'_patients_rest
	replace `var'_visits_pi_rest=round(`var'_visits_pi_rest)
}

//creating a new variable called var_in that excludes extreme top values (98%) to adjust for misreporting 
//could reduce this even further, these values often are not very plausible and lead to very large changes in mean 
 
foreach var in `types' {
	_pctile `var'_visits_pi_xviii, p(0.0001 98)
	gen `var'_visits_pi_xviii_in = `var'_visits_pi_xviii if inrange(`var'_visits_pi_xviii, r(r1), r(r2))
	_pctile `var'_visits_pi_medicaid, p(0.0001 98) 
	gen `var'_visits_pi_medicaid_in = `var'_visits_pi_medicaid if inrange(`var'_visits_pi_medicaid, r(r1), r(r2))
	_pctile `var'_visits_pi_rest, p(0.0001 98) 
	gen `var'_visits_pi_rest_in = `var'_visits_pi_rest if inrange(`var'_visits_pi_rest, r(r1), r(r2))
}


gen visits_per_person_xviii =total_visits_xviii/census_unduplicated_xviii 
gen visits_per_person_medicaid =total_visits_medicaid/census_unduplicated_medicaid 
gen visits_per_person_rest =total_visits_rest/census_unduplicated_rest

local categories xviii medicaid rest 

foreach var in `categories' {
	_pctile visits_per_person_`var', p(0.0001 98)
	gen visits_per_person_`var'_in = visits_per_person_`var' if inrange(visits_per_person_`var', r(r1), r(r2))
}

//generat revenue per person and revenue per visit for the three types 


//revenue missing sometimes means zero other times means just missing, but might not make a difference because the missings are just ignored for now. 

//revnue per person

gen rev_pa_xviii = rev_net_xviii/census_unduplicated_xviii
gen rev_pa_medicaid = rev_net_medicaid/census_unduplicated_medicaid
gen rev_pa_rest = rev_net_rest/census_unduplicated_rest

//revenue per visit --with medicare the results are correct.  

gen rev_pv_xviii = rev_net_xviii/total_visits_xviii
gen rev_pv_medicaid = rev_net_medicaid/total_visits_medicaid 
gen rev_pv_rest = rev_net_rest/total_visits_rest


local categories xviii medicaid rest

//winsorize top and bottom 1%
foreach var in `categories' {
	_pctile rev_pa_`var', p(1,99)
	gen rev_pa_`var'_in = rev_pa_`var' if inrange(rev_pa_`var', r(r1), r(r2))
	
	_pctile rev_pv_`var', p(1,99)
	gen rev_pv_`var'_in = rev_pv_`var' if inrange(rev_pv_`var', r(r1), r(r2))	
}

save "/Users/bubbles/Desktop/HomeHealth/output/SF_all_20_final", replace






















