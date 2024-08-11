//build information on CON Laws 

// https://ij.org/report/striving-for-better-care/the-state-of-certificate-of-need-laws-around-the-country/

//Paper-Association Between States' Certificate of Need Laws and Home Health Care Access in the US 

//https://georgiarecorder.com/wp-content/uploads/2023/06/Memo_CON-Repeal-and-Reform_Dolezal-sent-6-3-23.pdf 

//https://www.ncsl.org/health/certificate-of-need-state-laws#:~:text=New%20Hampshire%20was%20the%20most,that%20function%20similarly%20to%20CON

//Sourth Carolina- SB 164 (Enacted 2023) removed CON for home health 


cd /Users/bubbles/Desktop/HomeHealth/output/

use merged_pos_MA.dta, clear

bys state year: gen dup = cond(_N==1,0,_n)
drop if dup>1 //no duplicates 

keep year state state_name 

//17 states and the District of Columbia with CON laws for HHAs: Alabama, Arkansas, Georgia, Hawaii, Kentucky, Maryland, Mississippi, Montana, New Jersey, New York, North Carolina, Rhode Island, South Carolina, Tennessee, Vermont, Washington, and West Virginia. -paper

gen CON = inlist(state, "AL","AR","GA","HI","KY","MD")
replace CON = 1 if inlist(state, "MS","MT","NJ","NY","NC")
replace CON = 1 if inlist(state,"RI","SC","TN","VT","WA","WV","DC")

//states with changes in CON laws in this period (assume before complete repeal hhas were counted as part of CON)

replace CON =1 if state == "IN" & year <=1999 //ij 
replace CON=1 if state == "NH" & year <=2016 // ncsl
replace CON=1 if state == "ND" & year <=1995 //georgia memo
replace CON=1 if state == "PA" & year <=1996 //georgia memo
replace CON=1 if state == "OH" & year <=2012 //ij 
replace CON=0 if state == "MT" & year >= 2022 //ij 

save con_laws.dta, replace 

