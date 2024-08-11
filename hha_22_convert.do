
//this file convert the Home Health cost 2022 files from cvs to dta, don't do the 2023 yet because the data is still very incomplete (small file size)

//alpha file 

import delimited "/Users/bubbles/Desktop/hha_data/cost_hha/data_original/HHA20FY2022/HHA20_2022_ALPHA.CSV", clear 

rename v1 rpt_rec_num
rename v2 wksht_cd
rename v3 line_num
rename v4 clmn_num 
rename v5 alphnmrc_itm_txt

label var rpt_rec_num "report record number"
label var wksht_cd "worksheet code"
label var line_num "line number" 
label var clmn_num "column number"
label var alphnmrc_itm_txt "alphanumeric item text"

tostring line_num clmn_num, replace 
gen line_num_z = string(real(line_num), "%05.0f") //introduce leading zeros so that this matches with 2020 and 2021 
gen clmn_num_z =string(real(clmn_num), "%05.0f")
replace line_num =line_num_z
replace clmn_num =clmn_num_z
drop line_num_z clmn_num_z
save "/Users/bubbles/Desktop/hha_data/cost_hha/data/hha_alpha1728_20_2022_long.dta", replace

//nmrc file 

import delimited "/Users/bubbles/Desktop/hha_data/cost_hha/data_original/HHA20FY2022/HHA20_2022_NMRC.CSV", clear 

rename v1 rpt_rec_num
rename v2 wksht_cd
rename v3 line_num
rename v4 clmn_num
//gen clmn_num = ustrregexrf(v4,"^0","") //remove the first leading zero
//replace clmn_num="0" if missing(clmn_num)
rename v5 itm_val_num
//drop v4

label var rpt_rec_num "report record number"
label var wksht_cd "worksheet code"
label var line_num "line number" 
label var clmn_num "column number" //column always 5 rather than 4 (as in previous years)
label var itm_val_num "item value"


tostring line_num clmn_num, replace 
gen line_num_z = string(real(line_num), "%05.0f") //introduce leading zeros so that this matches with 2020 and 2021 
gen clmn_num_z =string(real(clmn_num), "%05.0f")
replace line_num =line_num_z
replace clmn_num =clmn_num_z
drop line_num_z clmn_num_z
save "/Users/bubbles/Desktop/hha_data/cost_hha/data/hha_nmrc1728_20_2022_long.dta", replace

//rpt file 

import delimited "/Users/bubbles/Desktop/hha_data/cost_hha/data_original/HHA20FY2022/HHA20_2022_RPT.CSV", clear 

rename v1 rpt_rec_num
rename v2 prvdr_ctrl_type_cd 
rename v3 prvdr_num
rename v4 npi
rename v5 rpt_stus_cd
rename v6 fy_bgn_dt
rename v7 fy_end_dt
rename v8 proc_dt
rename v9 initl_rpt_sw
rename v10 last_rpt_sw
rename v11 trnsmtl_num
rename v12 fi_num
rename v13 adr_vndr_cd
rename v14 fi_creat_dt
rename v15 util_cd
rename v16 npr_dt
rename v17 spec_ind
rename v18 fi_rcpt_dt

label var rpt_rec_num "report record number"
label var prvdr_ctrl_type_cd "provider control type code lbl_prvdr_ctrl_type_cd"
label var prvdr_num "provider number"
label var npi "national provider identifier"
label var rpt_stus_cd "report status code lbl_rpt_stus_cd"
label var fy_bgn_dt "fiscal year begin date"
label var fy_end_dt "fiscal year end date" 
label var proc_dt  "hcris process date" 
label var initl_rpt_sw "initial report switch" 
label var last_rpt_sw "last report switch"
label var trnsmtl_num "transmittal number"
label var fi_num "fiscal intermediary number"
label var adr_vndr_cd "automated desk review vendor code"
label var fi_creat_dt "fiscal intermediary create date"
label var util_cd "utilization code"
label var npr_dt "notice of program reimbursment date" 
label var spec_ind "special indicator" 
label var fi_rcpt_dt "fiscal intermediary receipt date"


save "/Users/bubbles/Desktop/hha_data/cost_hha/data/hha_rpt1728_20_2022_long.dta", replace



//useful code 

/*
foreach v of varlist _all {
    display `"`v'"', `"`:var label `v''"', `"`:val label `v''"'
}
*/ 
