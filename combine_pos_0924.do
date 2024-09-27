//combines pos info with census controls

cd /Users/bubbles/Desktop/HomeHealth/output/
 
use pos92-22.dta, clear
bys prvdr_num year: gen dup = cond(_N==1,0,_n)
drop if dup>1 //no duplicates 

decode prvdr_num, gen(prvdr_num_sec) //the original values are encoded 
destring prvdr_num_sec, replace 
drop prvdr_num
rename prvdr_num_sec prvdr_num
tostring prvdr_num, replace 

rename fips_cnty_cd county_fips
rename state_cd state 
rename fips_state_cd state_fips

drop if missing(county_fips) | missing(state_fips)

//generate five digit unique state+fips first 
gen state_fips_string = string(state_fips,"%02.0f") //two digit state code
gen county_fips_string = string(county_fips,"%03.0f") //three digits county code 
gen state_cty_fips = state_fips_string  + county_fips_string

egen n_firms = count(prvdr_num), by (year state_cty_fips) //number of home health agencies in county year

bysort prvdr_num (year) : gen gap = year - year[_n-1] 










egen int entryYr = min(year), by(prvdr_num)
egen int exitYr = max(year), by(prvdr_num)

gen byte entry = (year==entryYr)
gen byte exit = (year==exitYr)



bys year state_cty_fips: egen  n_entrants = total(entry) //number of entries in county year
replace n_entrants =. if year==1992 //entrants undefined for first year
bys year state_cty_fips : egen n_exits = total(exit) // number of exits in county year 
replace n_exits=. if year==2022 //exits undefined for last year 

keep year county_fips state_fips n_firms n_entrants n_exits state_cty_fips state 

duplicates drop

save county_entry_92-22.dta, replace //entry and exit variables 


//services provided variables 
//these variables have no missing values
//0=NOT PROVIDED, 1=PROVIDED BY STAFF, 2=PROVIDED UNDER ARRANGEMENT, 3=COMBINATION

use pos92-22.dta, clear
bys prvdr_num year: gen dup = cond(_N==1,0,_n)
drop if dup>1 //no duplicates 

decode prvdr_num, gen(prvdr_num_sec) //the original values are encoded 
destring prvdr_num_sec, replace 
drop prvdr_num
rename prvdr_num_sec prvdr_num
tostring prvdr_num, replace 

rename fips_cnty_cd county_fips
rename state_cd state 
rename fips_state_cd state_fips

drop if missing(county_fips) | missing(state_fips)

//generate five digit unique state+fips first 
gen state_fips_string = string(state_fips,"%02.0f") //two digit state code
gen county_fips_string = string(county_fips,"%03.0f") //three digits county code 
gen state_cty_fips = state_fips_string  + county_fips_string

//provided the service at all
gen nursing_sv = inlist(nrsng_srvc_cd,1,2,3) //provided by all home health agencies
gen ot_sv= inlist(ot_srvc_cd ,1,2,3)
gen pt_sv= inlist(pt_srvc_cd,1,2,3)
gen speech_sv= inlist(spch_thrpy_srvc_cd,1,2,3)
gen hh_aide_sv = inlist(hh_aide_srvc_cd,1,2,3)
gen medicalsc_sv = inlist(mdcl_scl_srvc_cd ,1,2,3) //medical social services 
gen lab_sv = inlist(lab_srvc_cd,1,2,3) //laboratory services 
gen pharmcy_sv = inlist(phrmcy_srvc_cd,1,2,3)
gen equipment_sv = inlist(aplnc_equip_srvc_cd,1,2,3)
gen intern_sv = inlist(intrn_rsdnt_srvc_cd ,1,2,3)
gen nutritional_sv = inlist(ntrtnl_gdnc_srvc_cd,1,2,3)
gen vocational_sv = inlist(vctnl_gdnc_srvc_cd,1,2,3)
gen other_sv = inlist(othr_srvc_cd,1,2,3)

//provided by staff only
gen staff_nursing_sv = inlist(nrsng_srvc_cd,1) 
gen staff_ot_sv= inlist(ot_srvc_cd,1)
gen staff_pt_sv= inlist(pt_srvc_cd,1)
gen staff_speech_sv= inlist(spch_thrpy_srvc_cd,1)
gen staff_hh_aide_sv = inlist(hh_aide_srvc_cd,1)
gen staff_medicalsc_sv = inlist(mdcl_scl_srvc_cd,1) //medical social services 
gen staff_lab_sv = inlist(lab_srvc_cd,1) //laboratory services 
gen staff_pharmcy_sv = inlist(phrmcy_srvc_cd,1)
gen staff_equipment_sv = inlist(aplnc_equip_srvc_cd,1)
gen staff_intern_sv = inlist(intrn_rsdnt_srvc_cd ,1)
gen staff_nutritional_sv = inlist(ntrtnl_gdnc_srvc_cd,1)
gen staff_vocational_sv = inlist(vctnl_gdnc_srvc_cd,1)
gen staff_other_sv = inlist(othr_srvc_cd,1)

//contracted (arranged) only 
gen arranged_nursing_sv = inlist(nrsng_srvc_cd,2) 
gen arranged_ot_sv= inlist(ot_srvc_cd,2)
gen arranged_pt_sv= inlist(pt_srvc_cd,2)
gen arranged_speech_sv= inlist(spch_thrpy_srvc_cd,2)
gen arranged_hh_aide_sv = inlist(hh_aide_srvc_cd,2)
gen arranged_medicalsc_sv = inlist(mdcl_scl_srvc_cd,2) //medical social services 
gen arranged_lab_sv = inlist(lab_srvc_cd,2) //laboratory services 
gen arranged_pharmcy_sv = inlist(phrmcy_srvc_cd,2)
gen arranged_equipment_sv = inlist(aplnc_equip_srvc_cd,2)
gen arranged_intern_sv = inlist(intrn_rsdnt_srvc_cd,2)
gen arranged_nutritional_sv = inlist(ntrtnl_gdnc_srvc_cd,2)
gen arranged_vocational_sv = inlist(vctnl_gdnc_srvc_cd,2)
gen arranged_other_sv = inlist(othr_srvc_cd,2)

//any provided by staff (including combination)
gen inhouse_nursing_sv = inlist(nrsng_srvc_cd,1,3) 
gen inhouse_ot_sv= inlist(ot_srvc_cd,1,3)
gen inhouse_pt_sv= inlist(pt_srvc_cd,1,3)
gen inhouse_speech_sv= inlist(spch_thrpy_srvc_cd,1,3)
gen inhouse_hh_aide_sv = inlist(hh_aide_srvc_cd,1,3)
gen inhouse_medicalsc_sv = inlist(mdcl_scl_srvc_cd,1,3) //medical social services 
gen inhouse_lab_sv = inlist(lab_srvc_cd,1,3) //laboratory services 
gen inhouse_pharmcy_sv = inlist(phrmcy_srvc_cd,1,3)
gen inhouse_equipment_sv = inlist(aplnc_equip_srvc_cd,1,3)
gen inhouse_intern_sv = inlist(intrn_rsdnt_srvc_cd ,1,3)
gen inhouse_nutritional_sv = inlist(ntrtnl_gdnc_srvc_cd,1,3)
gen inhouse_vocational_sv = inlist(vctnl_gdnc_srvc_cd,1,3)
gen inhouse_other_sv = inlist(othr_srvc_cd,1,3)

//labor variables (full time equivalent)-Number of full-time equivalent registered nurses employed by a provider --(probably doesn't include contracted)

rename rn_cnt fte_rn
rename lpn_lvn_cnt fte_lpn 
rename ocptnl_thrpst_cnt fte_ot
rename phys_thrpst_stf_cnt fte_pt 
rename spch_pthlgst_audlgst_cnt fte_speech 
rename hh_aide_cnt fte_hha
rename scl_workr_cnt fte_social_worker
rename reg_phrmcst_cnt fte_pharmacist
rename prsnel_othr_cnt fte_other
rename dietn_cnt fte_dietitian

keep prvdr_num year state_cty_fips *_sv fte_* 

collapse (mean) *_sv fte_* (sum) rn_cty = fte_rn lpn_cty=fte_lpn ot_cty=fte_ot pt_cty=fte_pt speech_cty = fte_speech hha_cty = fte_hha social_worker_cty=fte_social_worker pharmacist_cty=fte_pharmacist other_staff_cty=fte_other dietitian_cty=fte_dietitian, by (state_cty_fips year) //for labor created mean and total for services created proportion of agencies that provides this (not weighted by size)

save county_posothers_92-22.dta, replace


///merging together 

use county_entry_92-22.dta, clear 
merge 1:1 state_cty_fips year using county_posothers_92-22.dta  //combine with labor and services 
drop _merge 
merge 1:1 state_cty_fips year using pos92-22_hospitals.dta //combine with hospitals 
//replace n_hospital =0 if _merge==1//missing becauses there are no hospitals in the county that year 
drop if _merge==2 //drop if only hospitals and no home health
drop _merge  
replace n_hospital=0 if missing(n_hospital)

merge 1:1 county_fips state year using controls_census.dta //census data. Can check again the counties that are unmatched from master dataset (home health entry and exits) for the individual cases to see what is going on. 

//not sure what to do with the cases unmatched from the census, probably this means those counties had no home health agencies and also 0 entry and exits, but not sure if this will lead to too many zeros.

//looking at the merge==1 
//at some point probably should just drop those with populations less than 10000 or something---
//some cleaning for the unmatched ones 
drop if state =="MP" // state is Northern Mariana Islands, doesn't have any counties, that's why county codes are 0s
drop if state =="GU" //Guam only has one county and no census information 
drop if state =="VI" //no census data for VI, which only has three counties 
drop if state =="AK" & county_fips==1 //just one random observation
drop if state =="CT" & inrange(county_fips,1100,1900) //weird regions 
drop if inlist(state,"CN","MX","CM") // no such state 
//in the rest _merge ==1 only a hundred and something, generally the county code seems wrong/outdated, probably just ignore in analysis 

//looking at the merge==2
//seems like all small places can probably just replace the number of firms, entry and exits by 0, do versions with or without those

replace n_firms =0 if _merge==2
replace n_entrants =0 if _merge==2 & year != 1992 
replace n_exits =0 if _merge==2 & year !=2022 
replace n_hospitals =0 if _merge==2

local othervars nursing_sv ot_sv pt_sv speech_sv hh_aide_sv medicalsc_sv lab_sv pharmcy_sv equipment_sv intern_sv nutritional_sv vocational_sv other_sv staff_nursing_sv staff_ot_sv staff_pt_sv staff_speech_sv staff_hh_aide_sv staff_medicalsc_sv staff_lab_sv staff_pharmcy_sv staff_equipment_sv staff_intern_sv staff_nutritional_sv staff_vocational_sv staff_other_sv arranged_nursing_sv arranged_ot_sv arranged_pt_sv arranged_speech_sv arranged_hh_aide_sv arranged_medicalsc_sv arranged_lab_sv arranged_pharmcy_sv arranged_equipment_sv arranged_intern_sv arranged_nutritional_sv arranged_vocational_sv arranged_other_sv inhouse_nursing_sv inhouse_ot_sv inhouse_pt_sv inhouse_speech_sv inhouse_hh_aide_sv inhouse_medicalsc_sv inhouse_lab_sv inhouse_pharmcy_sv inhouse_equipment_sv inhouse_intern_sv inhouse_nutritional_sv inhouse_vocational_sv inhouse_other_sv fte_other fte_dietitian fte_hha fte_lpn fte_ot fte_pt fte_pharmacist fte_rn fte_social_worker fte_speech rn_cty lpn_cty ot_cty pt_cty speech_cty hha_cty social_worker_cty pharmacist_cty other_staff_cty dietitian_cty 

foreach v in `othervars' {
	replace `v' = 0 if _merge==2
}


drop _merge


save temp_merged.dta, replace

use temp_merged.dta, clear

drop if year==1992 //no MA data for this


//in main but not in using because missing 2006 and 2007 MA data, can interpolate later

gen n_hosp_pc = n_hospitals/persons_tot

//merge with CON laws 

merge m:1 state year using con_laws.dta

drop _merge 

drop state_fips

statastates, abbreviation(state)

replace state_fips = 43 if state =="PR"
replace state_fips = 52 if state =="VI"

gen state_fips_string = string(state_fips,"%02.0f") //two digit state code
gen county_fips_string = string(county_fips,"%03.0f") //three digits county code 

replace state_cty_fips = state_fips_string  + county_fips_string if state_cty_fips == "" //some of the state cty code for PR from before doesn't look correct because they start with 7...

drop state_fips_string county_fips_string _merge 

destring state_cty_fips, replace 
rename state_cty_fips fips 
rename county county_name_pos
drop state_fips county_fips state_name state
  
save merged_pos_census_0924.dta, replace


//missing data for y variables 
count if missing(n_firms) //missing when a county year is not in census but is in the MA data --usually this county is in PR
count if missing(n_exits) //missing when a county year is not in census and when year is 2022, so exits are not defined. 

count if missing(n_entrants) //because 1992 was excluded due to no MA information, this is only missing when a county year is not in census but is in the MA data --usually this county is in PR


