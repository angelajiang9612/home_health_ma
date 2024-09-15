import excel "/Users/bubbles/Downloads/PBP Benefits_2018/home_health_2018.xlsx", sheet("2018_home_health") firstrow

//some coinsurance and copayment but generally very small 

local varsyn pbp_b6_maxenr_yn pbp_b6_coins_yn pbp_b6_ded_yn pbp_b6_copay_yn pbp_b6_auth_yn pbp_b6_refer_yn pbp_b6_mm_limit_yn pbp_b6_mm_nmc_yn pbp_b6_mm_maxplan_yn pbp_b6_mm_coins_yn pbp_b6_mm_copay_yn pbp_b6_mmp_waiver_yn pbp_b6_mm_auth_yn pbp_b6_mm_refer_yn 

foreach var in `varsyn' {
	tab `var'
}


* why so many say there is coinsurance but max and min rates are both 0? only 1% ish has actually rates reported. 

/*

A copay is a set rate you pay for prescriptions, doctor visits, and other types of care.
Coinsurance is the percentage of costs you pay after you've met your deductible.
A deductible is the set amount you pay for medical services and prescriptions before your coinsurance kicks in fully.
After you have spent the out-of-pocket maximum, your healthcare plan should cover 100% of eligible expenses.
Generally, the lower your monthly premiums, the more out-of-pocket expenses you must pay before insurance begins to cover your bills.

--no one has any deductibles for home health


*/
