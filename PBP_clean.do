


//just look at 2018 Q1 home health and snf plan benefits information


/*

A copay is a set rate you pay for prescriptions, doctor visits, and other types of care.
Coinsurance is the percentage of costs you pay after you've met your deductible.
A deductible is the set amount you pay for medical services and prescriptions before your coinsurance kicks in fully.

After you have spent the out-of-pocket maximum, your healthcare plan should cover 100% of eligible expenses.
Generally, the lower your monthly premiums, the more out-of-pocket expenses you must pay before insurance begins to cover your bills.

*/


**home health, 23% says yes to coinsurance --why so many says yes to coinsurance but report zero for max and min?
**some variations in coinsurance/copay (yes/no alot but actual reported amount almost always zero)
*some variations in pre-authorization and referrals


import delimited "/Users/bubbles/Desktop/hha_data/MA_benefits/PBP Benefits_2018_Q1/pbp_b6_home_health.txt", clear 

label var pbp_a_ben_cov "Coverage Criteria"
label define pbp_a_ben_cov 1 " 1 Part A and Part B" 2 "2 Part B Only"

label var pbp_a_plan_type "Plan Type"

label define pbp_a_plan_type 1 "1 HMO" 2 "2	HMOPOS" 4 "4 Local PPO" 5 "5 PSO (State License)" 7 "7 MSA" /// 
8 "8 RFB PFFS" 9 "9 PFFS" 18 "18 1876 Cost" 19 "19 HCPP - 1833 Cost" 20 "20 National Pace" 29 "29 Medicare Prescription" 30 "30 Employer/Union Only Direct Contract PDP" 31 "31 Regional PPO" 32 "32 Fallback" 40 "40 Employer/Union Only Direct Contract PFFS" 42 "42	RFB HMO" 43 "43 RFB HMOPOS" 44 "44 RFB Local PPOS" 45 "45 RFB PSO (State License)" 47 "47 Employer Direct PPO" 48 "48 MMP HMO" 49 "49 MMP HMOPOS", modify
label values pbp_a_plan_type pbp_a_plan_type

label var orgtype "Organization Type"

label define orgtype 1 "1	Local CCP" 2 "2	MSA" 3 "3	RFB"  4 "4 PFFS" 5 "5 Demo" 6 "6 1876 Cost" 7 "7 HCPP - 1833 Cost" 8 "8 National PACE" 10 "10 PDP" 11 "11 Regional CCP" 12 "12	Fallback" 13 "13	Employer/Union Only Direct Contract PDP" 14 "14	Employer/Union Only Direct Contract PFFS" 15 "15	RFB Local CCP" 17 "17	Employer/Union Only Direct Contract Local CCP"

label values orgtype orgtype

label var bid_id "Bid ID"
label var version "Version Number"

rename pbp_b6_maxenr_yn hh_max_oop //no max oop

rename pbp_b6_coins_yn hh_coins  

label var  hh_coins "HHA Coinsurance YN" // 

rename pbp_b6_coins_pct_mc_min hh_coins_pct_min  //98% zero for min --only 16 out of 5000 contracts have none zero values for this 
rename pbp_b6_coins_pct_mc_max hh_coins_pct_max //max and min are the same 

rename pbp_b6_ded_yn hh_deductible //no deductible

rename pbp_b6_copay_yn hh_copay //43% says has copay 

rename pbp_b6_copay_mc_amt_min hh_copay_amt_min //close to two percent has a minimum copay value -and is this per visit or something?

rename pbp_b6_copay_mc_amt_max hh_copay_amt_max //three percent has a max copay value 

rename pbp_b6_auth_yn hh_auth //74% requires authorization 

rename pbp_b6_refer_yn hh_refer //35% requires referral 

//all the mm variables apply to non-medicare home health services, which very few provides

keep pbp_a_hnumber pbp_a_plan_identifier segment_id pbp_a_ben_cov pbp_a_plan_type orgtype bid_id version hh_*

save "/Users/bubbles/Desktop/HomeHealth/output/MA_benefits_hh_2018q1.dta", replace 





* why so many say there is coinsurance but max and min rates are both 0? only 1% ish has actually rates reported. 


//Skilled nursing facilities 

/*

Summary MA plan benefits variation for SNF:

Variation in whether charge coinsurance or not: but need to clarify what this means 
(e.g. how it differs from copay. Is it just one is rate paid after deductibles and another is amount?). 
Variationtion in whether allow less than three days inpatient care (most allow, usually 1 day)
Variation in copay payment. How many intervals, where the intervals start and end, and the actual copay per day in the intervals, a proportion of them had three intervals (>10%) with the third interval 0 copay. Variation in copay about but always below TM amount. 
Variation in whether prior authorization is required (most do) and whether referrals are required (most don't)


No deductible, no enhanced benefits in the form of additional days or SNF for non-Medicare approved days, cost sharing for consumers do not vary by SNF 


Tiering is a method of ranking health plans by cost and quality. Tier 1 plans typically offer a lower premium than Tier 2 or Tier 3

*/ 

import delimited "/Users/bubbles/Desktop/hha_data/MA_benefits/PBP Benefits_2018_Q1/pbp_b2_snf.txt", clear 

label define yn 1 "1.Yes" 2 "2.No"

rename (pbp_b2_*) (*) //drop the prefix 
label var pbp_a_ben_cov "Coverage Criteria"
label define pbp_a_ben_cov 1 " 1 Part A and Part B" 2 "2 Part B Only"
label values pbp_a_ben_cov pbp_a_ben_cov
label var pbp_a_plan_type "Plan Type"

label define pbp_a_plan_type 1 "1 HMO" 2 "2	HMOPOS" 4 "4 Local PPO" 5 "5 PSO (State License)" 7 "7 MSA" /// 
8 "8 RFB PFFS" 9 "9 PFFS" 18 "18 1876 Cost" 19 "19 HCPP - 1833 Cost" 20 "20 National Pace" 29 "29 Medicare Prescription" 30 "30 Employer/Union Only Direct Contract PDP" 31 "31 Regional PPO" 32 "32 Fallback" 40 "40 Employer/Union Only Direct Contract PFFS" 42 "42	RFB HMO" 43 "43 RFB HMOPOS" 44 "44 RFB Local PPOS" 45 "45 RFB PSO (State License)" 47 "47 Employer Direct PPO" 48 "48 MMP HMO" 49 "49 MMP HMOPOS", modify
label values pbp_a_plan_type pbp_a_plan_type

label var orgtype "Organization Type"

label define orgtype 1 "1	Local CCP" 2 "2	MSA" 3 "3	RFB"  4 "4 PFFS" 5 "5 Demo" 6 "6 1876 Cost" 7 "7 HCPP - 1833 Cost" 8 "8 National PACE" 10 "10 PDP" 11 "11 Regional CCP" 12 "12	Fallback" 13 "13	Employer/Union Only Direct Contract PDP" 14 "14	Employer/Union Only Direct Contract PFFS" 15 "15	RFB Local CCP" 17 "17	Employer/Union Only Direct Contract Local CCP"

label values orgtype orgtype

label var bid_id "Bid ID"

label var version "Version Number"

rename bendesc_yn snf_bene_supplement
label var snf_bene_supplement "Plan provide snf as supplemental benefit under part C?" //98.45% No, supplemental means additional days and no-medicare-covered stay 

rename bendesc_ad_nmcs snf_bene_enhanced
label var snf_bene_enhanced "Select enhanced benefits" //very few, 1.4% has this, 1 in 2	Additional days beyond Medicare-covered 1 in 1	Non-Medicare-covered stay (MMP Only). Basically no enhanced benefits of these two types

//pbp_b2_bendesc_amo_ad pbp_b2_benedesc_lim_ad pbp_b2_bendesc_ad pbp_b2_bendesc_amo_nmcs skipped because they only apply to extended stay or non-medicare covered stay

rename bendesc_pr_hosp_yn snf_bene_inp3orless
label var snf_bene_inp3orless "Allow less than 3 day inpatient hospital stay prior to SNF admission" //77% yes 

rename bendesc_pr_hosp_num snf_bene_inp02
label var snf_bene_inp02 "SNF Ben Desc Num of Days 0-2" //pre-dominantly 1 day allowed 

rename maxenr_yn snf_max_oop
label var  snf_max_oop "SNF Max Enr OOP Amt yn" //basically no one has OOP max

//pbp_b2_maxenr_per this is about max OOP too, no one answers it 

rename cost_vary_tiers_yn snf_cost_vary_by_facility
label var snf_cost_vary_by_facility "Cost Share Tiers Vary by snf YN" //97.56% does not vary

rename coins_yn snf_coins
label var snf_coins "SNF Coinsurance YN" // 23% says yes to coinsurance 

rename mc_coins_cstshr_yn_t1 snf_coins_tm 
label var snf_coins_tm  "Charge Medicare Defined Coinsurance Cost Shrs YN" //almost all that has coinsurance charge medicare defined coinsurance, which should just mean the same as TM schedule. 


//coins_mcs_pct_t1 (coinsurance percentage not available) --so no one charge a coinsurance and have it different from medicare defined,  pbp_b2_coins_mcs_int_num_t1 intervals also basically all missing (only applies to those who charge coinsurance and different from TM)

//only 3 plans answered all these information about coinsurance and intervals: coins_mcs_pct_int1_t1, coins_mcs_bgnd_int1_t1, coins_mcs_endd_int1_t1, coins_mcs_pct_int2_t1, coins_mcs_bgnd_int2_t1, coins_mcs_endd_int2_t1, coins_mcs_pct_int3_t1, coins_mcs_bgnd_int3_t1, coins_mcs_endd_int3_t1

rename ded_yn snf_deductibles
label var snf_deductibles "SNF Deductible YN" //why is this mostly missing? --check criteria for answering this question
//noboday do deductibles for nursing homes 

rename copay_yn snf_copay
label var snf_copay "SNF Copayment YN" //28% doesn't have copay, most the ones in this group has coinsurance which means they are probably just asking for the TM payment, not sure what the rest are doing. 

rename mc_copay_cstshr_yn_t1 snf_copay_tm
label var snf_copay_tm "Charge Med Def Copay Cost Shrs YN" //92.76% do not just follow TM schedule. 

//tab mc_copay_cstshr_yn_t1 //no observations on the amount of copay--is this data restricted or something? --probably because there are intervals for this thing so no copay amount can be defined?

//compared to TM (which has two intervals), some reported three intervals with actual payment info for these intervals(580)

rename copay_mcs_int_num_t1 snf_copay_num_intervals 
rename copay_mcs_amt_int1_t1 snf_copay_amt_int1  //96 percent of plans has 0 for for copay in tier 1, 3.38 has $20 
rename copay_mcs_bgnd_int1_t1 snf_copay_int1_begin //all 1 
rename copay_mcs_endd_int1_t1 snf_copay_int1_end //95.48 at 20, some at 100 *66 plans has no copay or coinsurance, does this just mean they are completely free for 100 days?
rename copay_mcs_amt_int2_t1 snf_copay_amt_int2 //lots of variation in this, max is the FFS payment about 
rename copay_mcs_bgnd_int2_t1 snf_copay_int2_begin
rename copay_mcs_endd_int2_t1 snf_copay_int2_end 
rename copay_mcs_amt_int3_t1 snf_copay_amt_int3 //majority zero copay for the third region why so many zeros here? up and down form?
rename copay_mcs_bgnd_int3_t1 snf_copay_int3_end //all at 100


//82 plans have tier 2 and none have tier 3, they fill in this information, but ignore for now 

//AD means additional days and nmcs means non medicare covered stays, only 82 plans have AD and non has  non medicare covered stays, ignore these variables

rename hosp_ben_period snf_bene_period

label define ben_period 1 "1 Original Medicare" 2 "2 Annual"  3 "3 Per Admission or Per Stay" 4 "4 Other" 
label values  snf_bene_period ben_period

rename cost_discharge_yn snf_cost_discharge
label var snf_cost_discharge "charge cost sharing on the day of discharge" //why only 320 answered this

rename auth_yn snf_auth
label var auth_yn "SNF prior authorization required" //80% do not require authorization

rename refer_yn snf_refer
label var refer_yn "referral required"

//SNF as benefit questions are not really answered, max plan benefit coverage questions also not answered. bonly questions also not asked. The rest is not asked. 

keep  pbp_a_hnumber pbp_a_plan_identifier segment_id pbp_a_ben_cov pbp_a_plan_type orgtype bid_id version snf_*

save "/Users/bubbles/Desktop/HomeHealth/output/MA_benefits_snf_2018q1.dta", replace 





























