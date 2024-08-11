//import POS data from excel into dta, keeping home health relevant variables.

//prvdr_num to uniquely identify provider
//-In dictionary, home health starts from page 242 and ends on 280
//Description: Indicates the current termination status for the provider.
// SAS Name: PGM_TRMNTN_CD can be important to double check on this

//following Huckfeldt 2013, start from 1991. Seems like the variables were very different before 1991 (50 variables vs 440 variables). --1991 need to manually change variable names for all variables, just start with 1992. Generally most variables exists in most years 

//note that POS as quarterly information on employment for home health agencies, should check if can access other quarters somewhere

//variables I need for now: provider number, year, county code, current status PGM_TRMNTN_CD type of thing, organization type

//list of variables that are relevant for home health agencies according to the dictionary

//no duplicates 

//all variables exist, the cross reference one has a different name 

//what to do with mergers? --not sure if should distinguish between closures and mergers and how 

//from 2023 Q4 data doesn't contain home health, there will be a new POS file that will be updated that contains home health and some other providers. 

//pos2019-2022 created from posothers, which had additional string variables for dates

//destring and merge everything 

local hhvars prvdr_ctgry_sbtyp_cd prvdr_ctgry_cd chow_cnt chow_dt city_name acptbl_poc_sw cmplnc_stus_cd ssa_cnty_cd /// 
cross_ref_provider_number crtfctn_dt elgblty_sw fac_name intrmdry_carr_cd mdcd_vndr_num chow_prior_dt ///
intrmdry_carr_prior_cd prvdr_num rgn_cd skltn_rec_sw state_cd state_rgn_cd st_adr phne_num pgm_trmntn_cd trmntn_exprtn_dt ///
crtfctn_actn_type_cd gnrl_cntl_type_cd zip_cd fips_state_cd fips_cnty_cd cbsa_urbn_rrl_ind acrdtn_type_cd ///
lab_srvc_cd phrmcy_srvc_cd brnch_cnt brnch_oprtn_sw gnrl_fac_type_cd chow_sw fy_end_mo_day_cd hha_qlfyd_opt_spch_sw ///
hh_aide_trng_pgm_cd mdcr_hospc_sw medicare_hospice_provider_num medicare_medicaid_prvdr_number pgm_prtcptn_cd ///
related_provider_number hh_aide_srvc_cd  aplnc_equip_srvc_cd intrn_rsdnt_srvc_cd mdcl_scl_srvc_cd nrsng_srvc_cd ntrtnl_gdnc_srvc_cd ///
ot_srvc_cd othr_srvc_cd pt_srvc_cd spch_thrpy_srvc_cd vctnl_gdnc_srvc_cd ovrrd_stfg_sw prsnel_othr_cnt dietn_cnt hh_aide_cnt ///
lpn_lvn_cnt ocptnl_thrpst_cnt phys_thrpst_stf_cnt reg_phrmcst_cnt rn_cnt scl_workr_cnt spch_pthlgst_audlgst_cnt ///
sbunit_cnt sbunit_sw sbunit_oprtn_sw

//most important variables: prvdr_num, prvdr_ctgry_cd fips_cnty_cd ssa_cnty_cd (county) pgm_trmntn_cd (status) gnrl_cntl_type_cd (control type), 


cd "/Users/bubbles/Desktop/hha_data/"

forvalues i = 1992/1993 {
 use pos/pos`i'.dta, clear
 rename prov2805 pgm_trmntn_cd
 isvar `hhvars'
 keep `r(varlist)' //keeping the variables in home health varlist
 destring, replace 
 keep if prvdr_ctgry_cd ==5 //keep home health 
 keep if pgm_trmntn_cd ==0 //keep active providers 
 gen year = `i'
 save temp/pos`i'.dta, replace 
}

forvalues i = 1994/2022 {
 use pos/pos`i'.dta, clear
 isvar `hhvars'
 keep `r(varlist)'
 destring, replace 
 keep if prvdr_ctgry_cd ==5 //keep home health 
 keep if pgm_trmntn_cd ==0 //keep active providers 
 gen year = `i'
 save temp/pos`i'.dta, replace 
}

//appending to get panel 

forvalues i = 1992/2021 { 
	append using temp/pos`i'.dta, force
	quietly describe 
	di r(k)
} 

save  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22.dta", replace 


use  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22.dta", clear

encode prvdr_num, gen(prvdr_number)
drop prvdr_num
rename prvdr_number prvdr_num

save  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22.dta", replace 



/*
List of variables that are home health relevant according to the data dictionary 


local hhvars prvdr_ctgry_sbtyp_cd prvdr_ctgry_cd chow_cnt chow_dt city_name acptbl_poc_sw cmplnc_stus_cd ssa_cnty_cd /// 
cross_ref_provider_number crtfctn_dt elgblty_sw fac_name intrmdry_carr_cd mdcd_vndr_num chow_prior_dt ///
intrmdry_carr_prior_cd prvdr_num rgn_cd skltn_rec_sw state_cd state_rgn_cd st_adr phne_num pgm_trmntn_cd trmntn_exprtn_dt ///
crtfctn_actn_type_cd gnrl_cntl_type_cd zip_cd fips_state_cd fips_cnty_cd cbsa_urbn_rrl_ind acrdtn_type_cd ///
lab_srvc_cd phrmcy_srvc_cd brnch_cnt brnch_oprtn_sw gnrl_fac_type_cd chow_sw fy_end_mo_day_cd hha_qlfyd_opt_spch_sw ///
hh_aide_trng_pgm_cd mdcr_hospc_sw medicare_hospice_provider_num medicare_medicaid_prvdr_number pgm_prtcptn_cd ///
related_provider_number hh_aide_srvc_cd  aplnc_equip_srvc_cd intrn_rsdnt_srvc_cd mdcl_scl_srvc_cd nrsng_srvc_cd ntrtnl_gdnc_srvc_cd ///
ot_srvc_cd othr_srvc_cd pt_srvc_cd spch_thrpy_srvc_cd vctnl_gdnc_srvc_cd ovrrd_stfg_sw prsnel_othr_cnt dietn_cnt hh_aide_cnt ///
lpn_lvn_cnt ocptnl_thrpst_cnt phys_thrpst_stf_cnt reg_phrmcst_cnt rn_cnt scl_workr_cnt spch_pthlgst_audlgst_cnt ///
sbunit_cnt sbunit_sw sbunit_oprtn_sw

*/

/*


//nothing missing but cross_ref_provider_number name is different 

forvalues i = 2013/2018 {
 use "/Users/bubbles/Desktop/hha_data/pos/pos`i'.dta", clear 
 keep `hhvars'
}


//only two variables are missing
forvalues i = 2011/2012 {
 use "/Users/bubbles/Desktop/hha_data/pos/pos`i'.dta", clear 
 isvar `hhvars' 
 keep `r(varlist)'
 describe 
}

//58 variables left, same for these all 11 years
forvalues i = 2000/2010 {
 use "/Users/bubbles/Desktop/hha_data/pos/pos`i'.dta", clear 
 isvar `hhvars' 
 keep `r(varlist)'
 describe 
}

//similar, a bit more variables missing 

forvalues i = 1993/1999 { 
 use "/Users/bubbles/Desktop/hha_data/pos/pos`i'.dta", clear 
 isvar `hhvars' 
 keep `r(varlist)'
 describe 
}


*/ 

/* keeping variables that are home health related: 

keep `hhvars'

sysuse auto, clear 

local keep myphonyvar make price

isvar `keep' 

keep `r(varlist)'
describe 

*/



/*
cd "/Users/bubbles/Desktop/hha_data/pos"

//the difference between posotherdec and pos is the former has the dates in string version too, don't need to use these numbers right now so ignore for now. These str versions are not listed in the current dictionary either 

forvalues i = 2011/2018 {
	quietly des using posotherdec`i'.dta, varlist
	local file1_vars `r(varlist)'
	quietly des using pos`i'.dta, varlist
	local file2_vars `r(varlist)'
	local common: list file1_vars & file2_vars
	local file1_only: list file1_vars - file2_vars
	local file2_only: list file2_vars - file1_vars
	di `i'
	display "common"
	display `"`common'"'
	display "file1_only"
	display `"`file1_only'"'
	display "file2_only"
	display `"`file2_only'"'
}



pgm_trmntn_cd changed from 0 to 00

*/ 










 