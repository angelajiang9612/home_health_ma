use "/Users/bubbles/Desktop/HomeHealth/output/SF_all_20_final", replace

//need to look at some of the earlier years

keep if year ==2022 //do one year first

//should check whether visits are much more likely to be home health aide visits or some cheaper visits in the rest/medicaid section -do a composition of visits graph?

sum rev_pa_xviii_in, detail
sum rev_pa_medicaid_in, detail
sum rev_pa_rest_in, detail


sum rev_pv_xviii_in, detail
sum rev_pv_medicaid_in, detail
sum rev_pv_rest_in, detail

/* this is too hard to see 
scatter rev_pa_xviii_in rev_pa_rest_in
scatter rev_pv_xviii_in rev_pv_rest_in

*/
//note that this is for people who have values in both 
gen rev_pa_ratio = rev_pa_rest/rev_pa_xviii
gen rev_pv_ratio = rev_pv_rest/rev_pv_xviii

_pctile rev_pa_ratio, p(2,98)
gen rev_pa_ratio_in= rev_pa_ratio if inrange(rev_pa_ratio, r(r1), r(r2))
	
_pctile rev_pv_ratio, p(2,98)
gen rev_pv_ratio_in= rev_pv_ratio if inrange(rev_pv_ratio, r(r1), r(r2))


hist rev_pa_ratio_in if rev_pa_ratio_in<=5, xtitle("Revenue Per Person Ratio")

hist rev_pv_ratio_in if rev_pv_ratio_in<=5, xtitle("Revenue Per Visit Ratio")

//look at difference between type of visits 

local types sn_rn sn_lpn ptm pta otm ota sp ms hha 

foreach var in `types' {
	sum  `var'_visits_pi_xviii, detail 
	sum  `var'_visits_pi_rest, detail 
}




