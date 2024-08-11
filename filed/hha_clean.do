//rough logic 

use "/Users/bubbles/Desktop/hha_data/cost_hha/play/hha_alpha1728_94_2012_long.dta", replace //use alpha file to test 

rename alphnmrc_itm_txt vars_ //string variable 

gen variable_code = wksht_cd + line_num + clmn_num //generates unique variable code 

unique variable_code //556 unique variables in the alpha file 

drop wksht_cd line_num clmn_num //don't need these anymore   

reshape wide vars_ , i(rpt_rec_num) j(variable_code) string //takes a while to ran, but not sure how to do sample selection without doing this step first. //bys id, keep if variable_code = state code & vars_ = "CA" //most of the variables are not very populated. 

//merge across files using the id rpt_rec_num 


