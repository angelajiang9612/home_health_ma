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


set rmsg on

forvalues i = 1994/2019 { //stop at 2019 for now, 2020 onwards new data format 
	
	//alpha file 
	use `data_input'hha_alpha1728_94_`i'_long.dta, replace 
	destring rpt_rec_num, replace 
	rename alphnmrc_itm_txt _ 
	keep if inlist(substr(wksht_cd, 1, 1),"S") //keep only those variables in S section 
	gen variable_code = wksht_cd + line_num + clmn_num //generates unique variable code 
	drop wksht_cd line_num clmn_num //need to drop these because they are not constant within rpt_rec_num
	reshape wide _ , i(rpt_rec_num) j(variable_code) string 
	tempfile alpha_`i'
	save `alpha_`i''

	//nmrc file 
	use `data_input'hha_nmrc1728_94_`i'_long.dta, replace 
	destring rpt_rec_num, replace 
	rename itm_val_num _ //string variable 
	keep if inlist(substr(wksht_cd, 1, 1),"S") //keep only those variables in S section 
	gen variable_code = wksht_cd + line_num + clmn_num 
	drop wksht_cd line_num clmn_num 
	reshape wide _ , i(rpt_rec_num) j(variable_code) string 
	tempfile nmrc_`i'
	save `nmrc_`i''

	//merge with rpt file 
	use `data_input'hha_rpt1728_94_`i'.dta, replace
	destring rpt_rec_num, replace 
	merge 1:1 rpt_rec_num using `alpha_`i'' //not everything in master is matched, check reason 
	drop _merge 
	merge 1:1 rpt_rec_num using `nmrc_`i''
	drop _merge 
	gen year = `i'
	save `data_output'`i'_SA, replace 
}



//converting to long form 

use  "/Users/bubbles/Desktop/HomeHealth/output/1994_S", clear 

************************************************

local data_output  "/Users/bubbles/Desktop/HomeHealth/output/"

forvalues i = 1995/2019 { 
	append using `data_output'`i'_S
	quietly describe 
	di r(k)
} //it seems like the number of variables in section S increased from 167 to 764 over the years 


/*

sort prvdr_num year 

order prvdr_num year _*

order _all, alphabetic

drop _S4* _S5* _S6*  //only 319 variables left 


npresent, min(`=ceil(_N/5)') // dropped variables missing more than 80% of the time, 146 left //can edit these and have a look 
keep `r(varlist)'

        
//basically s4 s5 s6 do not apply to most HHAs


preserve
describe, replace clear
list 
export excel using myfile.xlsx, replace first(var)
restore

*/
//https://stackoverflow.com/questions/49850210/excel-formula-to-split-cell-text-based-on-char-count 

**the excel file with the conversion is in code_variable_convert_all_S.xlsx

rename 	_S000000001000200	date_cost_report_received
rename 	_S000002001000100	_s000002001000100
rename 	_S000002001000200	_s000002001000200
rename 	_S000002002000200	_s000002002000200
rename 	_S000002003000200	_s000002003000200
rename 	_S000002003010200	_s000002003010200
rename 	_S000002003500000	_s000002003500000
rename 	_S000002003500200	_s000002003500200
rename 	_S000002003510000	_s000002003510000
rename 	_S000002003510200	_s000002003510200
rename 	_S000002003520000	_s000002003520000
rename 	_S000002003520200	_s000002003520200
rename 	_S000002003550000	_s000002003550000
rename 	_S000002003550200	_s000002003550200
rename 	_S000002003560000	_s000002003560000
rename 	_S000002003560200	_s000002003560200
rename 	_S000002003570000	_s000002003570000
rename 	_S000002003570200	_s000002003570200
rename 	_S000002003580000	_s000002003580000
rename 	_S000002003580200	_s000002003580200
rename 	_S000002003590000	_s000002003590000
rename 	_S000002003590200	_s000002003590200
rename 	_S000002003600000	_s000002003600000
rename 	_S000002003600200	_s000002003600200
rename 	_S000002003610000	_s000002003610000
rename 	_S000002003610200	_s000002003610200
rename 	_S000002003620000	_s000002003620000
rename 	_S000002003620200	_s000002003620200
rename 	_S000002003630000	_s000002003630000
rename 	_S000002003630200	_s000002003630200
rename 	_S000002003640000	_s000002003640000
rename 	_S000002003640200	_s000002003640200
rename 	_S000002003650000	_s000002003650000
rename 	_S000002003650200	_s000002003650200
rename 	_S000002003660000	_s000002003660000
rename 	_S000002003660200	_s000002003660200
rename 	_S000002004000100	_s000002004000100
rename 	_S000002004000200	_s000002004000200
rename 	_S200000001000100	street
rename 	_S200000001000200	po_box
rename 	_S200000001000300	_s200000001000300
rename 	_S200000001010100	city
rename 	_S200000001010200	state
rename 	_S200000001010300	zip_code
rename 	_S200000002000100	name
rename 	_S200000002000200	ccn
rename 	_S200000002000300	date_certified
rename 	_S200000003000100	corf_name
rename 	_S200000003000200	corf_ccn
rename 	_S200000003000300	corf_date_certified
rename 	_S200000003500100	hospice_name
rename 	_S200000003500200	hospice_ccn
rename 	_S200000003500300	hospice_date_certified
rename 	_S200000003510100	_s200000003510100
rename 	_S200000003510200	_s200000003510200
rename 	_S200000003510300	_s200000003510300
rename 	_S200000003520100	_s200000003520100
rename 	_S200000003520200	_s200000003520200
rename 	_S200000003520300	_s200000003520300
rename 	_S200000003530100	_s200000003530100
rename 	_S200000003530200	_s200000003530200
rename 	_S200000003530300	_s200000003530300
rename 	_S200000003540100	_s200000003540100
rename 	_S200000003540200	_s200000003540200
rename 	_S200000003540300	_s200000003540300
rename 	_S200000003550100	_s200000003550100
rename 	_S200000003550200	_s200000003550200
rename 	_S200000003550300	_s200000003550300
rename 	_S200000003560100	_s200000003560100
rename 	_S200000003560200	_s200000003560200
rename 	_S200000003560300	_s200000003560300
rename 	_S200000003570100	_s200000003570100
rename 	_S200000003570200	_s200000003570200
rename 	_S200000003570300	_s200000003570300
rename 	_S200000003580100	_s200000003580100
rename 	_S200000003580200	_s200000003580200
rename 	_S200000003580300	_s200000003580300
rename 	_S200000004000100	cmhc_name
rename 	_S200000004000200	cmhc_ccn
rename 	_S200000004000300	cmhc_date_certified
rename 	_S200000004010100	_s200000004010100
rename 	_S200000004010200	_s200000004010200
rename 	_S200000004010300	_s200000004010300
rename 	_S200000004020100	_s200000004020100
rename 	_S200000004020200	_s200000004020200
rename 	_S200000004020300	_s200000004020300
rename 	_S200000004030100	_s200000004030100
rename 	_S200000004030200	_s200000004030200
rename 	_S200000004030300	_s200000004030300
rename 	_S200000004040100	_s200000004040100
rename 	_S200000004040200	_s200000004040200
rename 	_S200000004040300	_s200000004040300
rename 	_S200000004050100	_s200000004050100
rename 	_S200000004050200	_s200000004050200
rename 	_S200000004050300	_s200000004050300
rename 	_S200000004060100	_s200000004060100
rename 	_S200000004060200	_s200000004060200
rename 	_S200000004060300	_s200000004060300
rename 	_S200000004070100	_s200000004070100
rename 	_S200000004070200	_s200000004070200
rename 	_S200000004070300	_s200000004070300
rename 	_S200000004080100	_s200000004080100
rename 	_S200000004080200	_s200000004080200
rename 	_S200000004080300	_s200000004080300
rename 	_S200000005000100	rhc_name
rename 	_S200000005000200	rhc_ccn
rename 	_S200000005000300	rhc_date_certified
rename 	_S200000005010100	_s200000005010100
rename 	_S200000005010200	_s200000005010200
rename 	_S200000005010300	_s200000005010300
rename 	_S200000005020100	_s200000005020100
rename 	_S200000005020200	_s200000005020200
rename 	_S200000005020300	_s200000005020300
rename 	_S200000005030100	_s200000005030100
rename 	_S200000005030200	_s200000005030200
rename 	_S200000005030300	_s200000005030300
rename 	_S200000005040100	_s200000005040100
rename 	_S200000005040200	_s200000005040200
rename 	_S200000005040300	_s200000005040300
rename 	_S200000005050100	_s200000005050100
rename 	_S200000005050200	_s200000005050200
rename 	_S200000005050300	_s200000005050300
rename 	_S200000006000100	fqhc_name
rename 	_S200000006000200	fqhc_ccn
rename 	_S200000006000300	fqhc_date_certified
rename 	_S200000006010100	_s200000006010100
rename 	_S200000006010200	_s200000006010200
rename 	_S200000006010300	_s200000006010300
rename 	_S200000006020100	_s200000006020100
rename 	_S200000006020200	_s200000006020200
rename 	_S200000006020300	_s200000006020300
rename 	_S200000006030100	_s200000006030100
rename 	_S200000006030200	_s200000006030200
rename 	_S200000006030300	_s200000006030300
rename 	_S200000006040100	_s200000006040100
rename 	_S200000006040200	_s200000006040200
rename 	_S200000006040300	_s200000006040300
rename 	_S200000006050100	_s200000006050100
rename 	_S200000006050200	_s200000006050200
rename 	_S200000006050300	_s200000006050300
rename 	_S200000006060100	_s200000006060100
rename 	_S200000006060200	_s200000006060200
rename 	_S200000006060300	_s200000006060300
rename 	_S200000006070100	_s200000006070100
rename 	_S200000006070200	_s200000006070200
rename 	_S200000006070300	_s200000006070300
rename 	_S200000006080100	_s200000006080100
rename 	_S200000006080200	_s200000006080200
rename 	_S200000006080300	_s200000006080300
rename 	_S200000007000100	cost_reporting_period_from
rename 	_S200000007000200	cost_reporting_period_to
rename 	_S200000008000100	type_of_control
rename 	_S200000009000100	ln_medicare_use
rename 	_S200000010000100	dep_straight_line
rename 	_S200000011000100	dep_declining_balance
rename 	_S200000012000100	dep_sum_of_the_years
rename 	_S200000013000100	dep_sum
rename 	_S200000014000100	dispose_asset
rename 	_S200000015000100	dep_asset_prior
rename 	_S200000016000100	dep_asset_any
rename 	_S200000017000100	dep_balance
rename 	_S200000018000100	cease_medicare
rename 	_S200000019000100	decrease_health_insurance
rename 	_S200000020000100	small_hha
rename 	_S200000021000100	nominal_charge_provider
rename 	_S200000022000100	contract_pt
rename 	_S200000022010100	contract_occupation_therapy
rename 	_S200000022020100	contract_speech_therapy
rename 	_S200000023000100	_s200000023000100
rename 	_S200000023000200	_s200000023000200
rename 	_S200000024000200	_s200000024000200
rename 	_S200000024010200	_s200000024010200
rename 	_S200000024020200	_s200000024020200
rename 	_S200000024030200	_s200000024030200
rename 	_S200000024040200	_s200000024040200
rename 	_S200000024050200	_s200000024050200
rename 	_S200000024060200	_s200000024060200
rename 	_S200000024070200	_s200000024070200
rename 	_S200000024080200	_s200000024080200
rename 	_S200000025000200	_s200000025000200
rename 	_S200000025010200	_s200000025010200
rename 	_S200000025020200	_s200000025020200
rename 	_S200000025030200	_s200000025030200
rename 	_S200000025040200	_s200000025040200
rename 	_S200000025050200	_s200000025050200
rename 	_S200000025060200	_s200000025060200
rename 	_S200000025070200	_s200000025070200
rename 	_S200000025080200	_s200000025080200
rename 	_S200000026000100	_s200000026000100
rename 	_S200000027000100	_s200000027000100
rename 	_S200000027010100	_s200000027010100
rename 	_S200000027020100	_s200000027020100
rename 	_S200000027030100	_s200000027030100
rename 	_S200000028000100	_s200000028000100
rename 	_S200000029000100	chain
rename 	_S200000029010100	home_office_name
rename 	_S200000029010200	home_office_no
rename 	_S200000029010300	home_office_contractor_no
rename 	_S200000029020100	home_office_street
rename 	_S200000029020200	home_office_po_box
rename 	_S200000029020300	home_office_contractor_name
rename 	_S200000029030100	home_office_city
rename 	_S200000029030200	home_office_state
rename 	_S200000029030300	home_office_zip_code
rename 	_S210001001000100	changed_ownership
rename 	_S210001001000200	date_changed_ownership
rename 	_S210001002000100	terminated_medicare
rename 	_S210001002000200	terminated_date
rename 	_S210001002000300	terminated_voluntary
rename 	_S210001003000100	_s210001003000100
rename 	_S210001004000100	_s210001004000100
rename 	_S210001004000200	_s210001004000200
rename 	_S210001004000300	_s210001004000300
rename 	_S210001005000100	_s210001005000100
rename 	_S210001006000100	_s210001006000100
rename 	_S210001007000100	_s210001007000100
rename 	_S210001008000100	_s210001008000100
rename 	_S210001009000100	_s210001009000100
rename 	_S210001009000200	_s210001009000200
rename 	_S210001010000100	_s210001010000100
rename 	_S210001010000200	_s210001010000200
rename 	_S210001011000100	_s210001011000100
rename 	_S210001012000100	_s210001012000100
rename 	_S210001013000000	_s210001013000000
rename 	_S210001013000100	_s210001013000100
rename 	_S210001014000100	_s210001014000100
rename 	_S210001015000100	_s210001015000100
rename 	_S210001015000200	_s210001015000200
rename 	_S210001015000300	_s210001015000300
rename 	_S210001016000100	_s210001016000100
rename 	_S210001017000100	_s210001017000100
rename 	_S210001017000200	_s210001017000200
rename 	_S300000001000000	county
rename 	_S300000001000100	sn_visits_xviii
rename 	_S300000001000200	sn_patients_xviii
rename 	_S300000001000300	sn_visits_others
rename 	_S300000001000400	sn_patient_others
rename 	_S300000001000500	sn_visits_total
rename 	_S300000001000600	sn_patients_total
rename 	_S300000002000100	pt_visits_xviii
rename 	_S300000002000200	pt_patients_xviii
rename 	_S300000002000300	pt_visits_others
rename 	_S300000002000400	pt_patient_others
rename 	_S300000002000500	pt_visits_total
rename 	_S300000002000600	pt_patients_total
rename 	_S300000003000100	ot_visits_xviii
rename 	_S300000003000200	ot_patients_xviii
rename 	_S300000003000300	ot_visits_others
rename 	_S300000003000400	ot_patient_others
rename 	_S300000003000500	ot_visits_total
rename 	_S300000003000600	ot_patients_total
rename 	_S300000004000100	sp_visits_xviii
rename 	_S300000004000200	sp_patients_xviii
rename 	_S300000004000300	sp_visits_others
rename 	_S300000004000400	sp_patient_others
rename 	_S300000004000500	sp_visits_total
rename 	_S300000004000600	sp_patients_total
rename 	_S300000005000100	ms_visits_xviii
rename 	_S300000005000200	ms_patients_xviii
rename 	_S300000005000300	ms_visits_others
rename 	_S300000005000400	ms_patient_others
rename 	_S300000005000500	ms_visits_total
rename 	_S300000005000600	ms_patients_total
rename 	_S300000006000100	hha_visits_xviii
rename 	_S300000006000200	hha_patients_xviii
rename 	_S300000006000300	hha_visits_others
rename 	_S300000006000400	hha_patient_others
rename 	_S300000006000500	hha_visits_total
rename 	_S300000006000600	hha_visits_patients
rename 	_S300000006010100	_s300000006010100
rename 	_S300000006010200	_s300000006010200
rename 	_S300000006010300	_s300000006010300
rename 	_S300000006010400	_s300000006010400
rename 	_S300000006010500	_s300000006010500
rename 	_S300000006010600	_s300000006010600
rename 	_S300000007000300	all_otherservices_other_visits
rename 	_S300000007000400	all_otherservices_other_patients
rename 	_S300000007000500	all_otherservices_visits_total
rename 	_S300000007000600	all_otherservices_patients_total
rename 	_S300000007010300	_s300000007010300
rename 	_S300000008000100	total_visits_xviii
rename 	_S300000008000300	total_visits_other
rename 	_S300000008000500	total_visits
rename 	_S300000009000100	hha_hours_xviii
rename 	_S300000009000300	hha_hours_others
rename 	_S300000009000500	hha_hours
rename 	_S300000010000000	_s300000010000000
rename 	_S300000010000100	_s300000010000100
rename 	_S300000010000200	census_unduplicated_xviii
rename 	_S300000010000400	census_unduplicated_others
rename 	_S300000010000600	census_unduplicated_total
rename 	_S300000010010200	_s300000010010200
rename 	_S300000010010400	_s300000010010400
rename 	_S300000010010600	_s300000010010600
rename 	_S300000010020200	_s300000010020200
rename 	_S300000010020400	_s300000010020400
rename 	_S300000010020600	_s300000010020600
rename 	_S300000011000000	hours_week
rename 	_S300000011000100	admin_staff
rename 	_S300000011000200	admin_contract
rename 	_S300000011000300	admin_total
rename 	_S300000012000000	_s300000012000000
rename 	_S300000012000100	director_staff
rename 	_S300000012000200	director_contract
rename 	_S300000012000300	director_total
rename 	_S300000013000100	admin_others_staff
rename 	_S300000013000200	admin_others_contract
rename 	_S300000013000300	admin_others_total
rename 	_S300000014000100	direct_nursing_staff
rename 	_S300000014000200	direct_nursing_contract
rename 	_S300000014000300	direct_nursing_total
rename 	_S300000015000100	nursing_supervisor_staff
rename 	_S300000015000200	nursing_supervisor_contract
rename 	_S300000015000300	nursing_supervisor_total
rename 	_S300000016000100	pt_staff
rename 	_S300000016000200	pt_contract
rename 	_S300000016000300	pt_total
rename 	_S300000017000100	pt_supervisor_staff
rename 	_S300000017000200	pt_supervisor_contract
rename 	_S300000017000300	pt_supervisor_total
rename 	_S300000018000100	ot_staff
rename 	_S300000018000200	ot_contract
rename 	_S300000018000300	ot_total
rename 	_S300000019000100	ot_supervisor_staff
rename 	_S300000019000200	ot_supervisor_contract
rename 	_S300000019000300	ot_supervisor_total
rename 	_S300000020000100	sp_staff
rename 	_S300000020000200	sp_contract
rename 	_S300000020000300	sp_total
rename 	_S300000020000400	_s300000020000400
rename 	_S300000021000100	sp_supervisor_staff
rename 	_S300000021000200	sp_supervisor_contract
rename 	_S300000021000300	sp_supervisor_total
rename 	_S300000022000100	ms_staff
rename 	_S300000022000200	ms_contract
rename 	_S300000022000300	ms_total
rename 	_S300000023000100	ms_supervisor_staff
rename 	_S300000023000200	ms_supervisor_contract
rename 	_S300000023000300	ms_supervisor_total
rename 	_S300000024000100	hha_staff
rename 	_S300000024000200	hha_contract
rename 	_S300000024000300	hha_total
rename 	_S300000025000100	hha_supervisor_staff
rename 	_S300000025000200	hha_supervisor_contract
rename 	_S300000025000300	hha_supervisor_total
rename 	_S300000026000000	_s300000026000000
rename 	_S300000026000100	_s300000026000100
rename 	_S300000026000200	_s300000026000200
rename 	_S300000026000300	_s300000026000300
rename 	_S300000027000000	_s300000027000000
rename 	_S300000027000100	_s300000027000100
rename 	_S300000027000200	_s300000027000200
rename 	_S300000027000300	_s300000027000300
rename 	_S300000027010000	_s300000027010000
rename 	_S300000027010100	_s300000027010100
rename 	_S300000027010200	_s300000027010200
rename 	_S300000028000100	total_msas_medicare
rename 	_S300000028000101	total_cbsas_medicare
rename 	_S300000029000100	_s300000029000100
rename 	_S300000029000101	_s300000029000101
rename 	_S300000029010100	_s300000029010100
rename 	_S300000029010101	_s300000029010101
rename 	_S300000029020100	_s300000029020100
rename 	_S300000029020101	_s300000029020101
rename 	_S300000029030100	_s300000029030100
rename 	_S300000029030101	_s300000029030101
rename 	_S300000029040100	_s300000029040100
rename 	_S300000029040101	_s300000029040101
rename 	_S300000029050100	_s300000029050100
rename 	_S300000029050101	_s300000029050101
rename 	_S300000029060100	_s300000029060100
rename 	_S300000029060101	_s300000029060101
rename 	_S300000029070100	_s300000029070100
rename 	_S300000029070101	_s300000029070101
rename 	_S300000029080100	_s300000029080100
rename 	_S300000029080101	_s300000029080101
rename 	_S300000029090100	_s300000029090100
rename 	_S300000029090101	_s300000029090101
rename 	_S300000029100100	_s300000029100100
rename 	_S300000029100101	_s300000029100101
rename 	_S300000029110100	_s300000029110100
rename 	_S300000029110101	_s300000029110101
rename 	_S300000029120100	_s300000029120100
rename 	_S300000029120101	_s300000029120101
rename 	_S300000029130100	_s300000029130100
rename 	_S300000029130101	_s300000029130101
rename 	_S300000029140100	_s300000029140100
rename 	_S300000029140101	_s300000029140101
rename 	_S300000029150100	_s300000029150100
rename 	_S300000029150101	_s300000029150101
rename 	_S300000029160100	_s300000029160100
rename 	_S300000029160101	_s300000029160101
rename 	_S300000029170100	_s300000029170100
rename 	_S300000029170101	_s300000029170101
rename 	_S300000029180100	_s300000029180100
rename 	_S300000029180101	_s300000029180101
rename 	_S300000029190101	_s300000029190101
rename 	_S300000029200101	_s300000029200101
rename 	_S300000029210101	_s300000029210101
rename 	_S300000029220101	_s300000029220101
rename 	_S300000029230101	_s300000029230101
rename 	_S300000029240101	_s300000029240101
rename 	_S300000029250101	_s300000029250101
rename 	_S300000029260101	_s300000029260101
rename 	_S300000030000100	sn_visits_full_episode
rename 	_S300000030000200	sn_visits_full_episode_o
rename 	_S300000030000300	sn_visits_lupa
rename 	_S300000030000400	sn_visits_pep
rename 	_S300000030000500	sn_visits_scic_pep
rename 	_S300000030000600	sn_visits_scic
rename 	_S300000030000700	sn_visits_total_medicare
rename 	_S300000031000100	sn_charges_full_episode
rename 	_S300000031000200	sn_charges_full_episode_o
rename 	_S300000031000300	sn_charges_lupa
rename 	_S300000031000400	sn_charges_pep
rename 	_S300000031000500	sn_charges_scic_pep
rename 	_S300000031000600	sn_charges_scic
rename 	_S300000031000700	sn_charges_total
rename 	_S300000032000100	pt_visits_full_episode
rename 	_S300000032000200	pt_visits_full_episode_o
rename 	_S300000032000300	pt_visits_lupa
rename 	_S300000032000400	pt_visits_pep
rename 	_S300000032000500	pt_visits_scic_pep
rename 	_S300000032000600	pt_visits_scic
rename 	_S300000032000700	pt_visits_total_medicare
rename 	_S300000033000100	pt_charges_full_episode
rename 	_S300000033000200	pt_charges_full_episode_o
rename 	_S300000033000300	pt_charges_lupa
rename 	_S300000033000400	pt_charges_pep
rename 	_S300000033000500	pt_charges_scic_pep
rename 	_S300000033000600	pt_charges_scic
rename 	_S300000033000700	pt_charges_total
rename 	_S300000034000100	ot_visits_full_episode
rename 	_S300000034000200	ot_visits_full_episode_o
rename 	_S300000034000300	ot_visits_lupa
rename 	_S300000034000400	ot_visits_pep
rename 	_S300000034000500	ot_visits_scic_pep
rename 	_S300000034000600	ot_visits_scic
rename 	_S300000034000700	ot_visits_total_medicare
rename 	_S300000035000100	ot_charges_full_episode
rename 	_S300000035000200	ot_charges_full_episode_o
rename 	_S300000035000300	ot_charges_lupa
rename 	_S300000035000400	ot_charges_pep
rename 	_S300000035000500	ot_charges_scic_pep
rename 	_S300000035000600	ot_charges_scic
rename 	_S300000035000700	ot_charges_total
rename 	_S300000036000100	sp_visits_full_episode
rename 	_S300000036000200	sp_visits_full_episode_o
rename 	_S300000036000300	sp_visits_lupa
rename 	_S300000036000400	sp_visits_pep
rename 	_S300000036000500	sp_visits_scic_pep
rename 	_S300000036000600	sp_visits_scic
rename 	_S300000036000700	sp_visits_total_medicare
rename 	_S300000037000100	sp_charges_full_episode
rename 	_S300000037000200	sp_charges_full_episode_o
rename 	_S300000037000300	sp_charges_lupa
rename 	_S300000037000400	sp_charges_pep
rename 	_S300000037000500	sp_charges_scic_pep
rename 	_S300000037000600	sp_charges_scic
rename 	_S300000037000700	sp_charges_total
rename 	_S300000038000100	ms_visits_full_episode
rename 	_S300000038000200	ms_visits_full_episode_o
rename 	_S300000038000300	ms_visits_lupa
rename 	_S300000038000400	ms_visits_pep
rename 	_S300000038000500	ms_visits_scic_pep
rename 	_S300000038000600	ms_visits_scic
rename 	_S300000038000700	ms_visits_total_medicare
rename 	_S300000039000100	ms_charges_full_episode
rename 	_S300000039000200	ms_charges_full_episode_o
rename 	_S300000039000300	ms_charges_lupa
rename 	_S300000039000400	ms_charges_pep
rename 	_S300000039000500	ms_charges_scic_pep
rename 	_S300000039000600	ms_charges_scic
rename 	_S300000039000700	ms_charges_total
rename 	_S300000040000100	hha_visits_full_episode
rename 	_S300000040000200	hha_visits_full_episode_o
rename 	_S300000040000300	hha_visits_lupa
rename 	_S300000040000400	hha_visits_pep
rename 	_S300000040000500	hha_visits_scic_pep
rename 	_S300000040000600	hha_visits_scic
rename 	_S300000040000700	hha_visits_total_medicare
rename 	_S300000041000100	hha_charges_full_episode
rename 	_S300000041000200	hha_charges_full_episode_o
rename 	_S300000041000300	hha_charges_lupa
rename 	_S300000041000400	hha_charges_pep
rename 	_S300000041000500	hha_charges_scic_pep
rename 	_S300000041000600	hha_charges_scic
rename 	_S300000041000700	hha_charges_total
rename 	_S300000042000100	total_visits_full_episode
rename 	_S300000042000200	total_visits_full_episode_o
rename 	_S300000042000300	total_visits_lupa
rename 	_S300000042000400	total_visits_pep
rename 	_S300000042000500	total_visits_scic_pep
rename 	_S300000042000600	total_visits_scic
rename 	_S300000042000700	total_visits_pps
rename 	_S300000043000100	other_charges_full_episode
rename 	_S300000043000200	other_charges_full_episode_o
rename 	_S300000043000300	other_charges_lupa
rename 	_S300000043000400	other_charges_pep
rename 	_S300000043000500	other_charges_scic_pep
rename 	_S300000043000600	other_charges_scic
rename 	_S300000043000700	other_charges_pps
rename 	_S300000044000100	total_charges_full_episode
rename 	_S300000044000200	total_charges_full_episode_o
rename 	_S300000044000300	total_charges_lupa
rename 	_S300000044000400	total_charges_pep
rename 	_S300000044000500	total_charges_scic_pep
rename 	_S300000044000600	total_charges_scic
rename 	_S300000044000700	total_charges_pps
rename 	_S300000045000100	total_episodes_full
rename 	_S300000045000200	total_episodes_full_o
rename 	_S300000045000300	total_episodes_lupa
rename 	_S300000045000400	total_episodes_pep
rename 	_S300000045000500	total_episodes_scic_pep
rename 	_S300000045000600	total_episodes_scic
rename 	_S300000045000700	total_episodes_pps
rename 	_S300000046000100	total_outlier_full
rename 	_S300000046000200	total_outlier_outlier
rename 	_S300000046000400	total_outlier_pep
rename 	_S300000046000500	total_outlier_scic_pep
rename 	_S300000046000600	total_outlier_scic
rename 	_S300000046000700	total_outlier_pps
rename 	_S300000047000100	total_nrms_full
rename 	_S300000047000200	total_nrms_outlier
rename 	_S300000047000300	total_nrms_lupa
rename 	_S300000047000400	total_nrms_pep
rename 	_S300000047000500	total_nrms_scic_pep
rename 	_S300000047000600	total_nrms_scic
rename 	_S300000047000700	total_nrms_pps
rename 	_S300000050000400	_s300000050000400
rename 	_S300000051000200	_s300000051000200
rename 	_S300000060000200	_s300000060000200
rename 	_S300000090000400	_s300000090000400

drop _s* 
drop _S*

order prvdr_num year

save "/Users/bubbles/Desktop/HomeHealth/output/S_all", replace



//some missing information stuff 
use "/Users/bubbles/Desktop/HomeHealth/output/S_all", replace 

/*Type of Control
1 = Voluntary Nonprofit, Church
2 = Voluntary Nonprofit, Other
3 = Proprietary, Sole Proprietor
4 = Proprietary, Partnership
5 = Proprietary, Corporation
6 = Private Nonprofit
7 = Governmental & Private Combination
8 = Governmental, Federal
9 = Governmental, State
10 = Governmental, City
11 = Governmental, City-County
12 = Governmental, County
13 = Governmental, Health District
*/ 

foreach var in census_unduplicated_total census_unduplicated_xviii census_unduplicated_others total_visits_xviii total_visits_other total_visits sn_visits_full_episode pt_visits_full_episode ot_visits_full_episode sp_visits_full_episode hha_visits_full_episode total_visits_full_episode total_episodes_full {
	replace `var' =0 if missing(`var') & year >=2000 //missing should mean 0 for years larger than 2000
}

gen nonprofit = inlist(type_of_control,1,2,6,7,8,9,10,11,12,13) //including government 
gen hha_type =1 if inlist(type_of_control,1,2)
replace  hha_type =2 if inrange(type_of_control,3,6)
replace hha_type =3 if inrange(type_of_control,7,13)


gen hha_chain =1 if chain=="Y"
replace hha_chain = 0 if chain =="N" | chain == "NN"


//should check some of these things.  e.g. total_visits_full_episode not missing but total_episodes_full missing what might this mean. 

//can check these ones individually again 


save "/Users/bubbles/Desktop/HomeHealth/output/S_all", replace


////////////////////////////////////////
//merge with quality data CMS/////
//////////////////////////////////////


















