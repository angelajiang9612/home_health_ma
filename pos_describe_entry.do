use  "/Users/bubbles/Desktop/HomeHealth/output/pos92-22.dta", clear

//compare summary stats with Huckfeldt 2013 Medicare Payment Reform and ProviderEntry and Exit in the Post-Acute Care Market, looks similar but not identical, can check if there are spells rather than just do entry and exit as min and max. 

//2019 much more entry and exits, back to normal 2020-2022, might want to exclude these years--maybe because of the policy change in 2020 

sort prvdr_num year
//total number of HHAs each year 
bys prvdr_num year: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, removed 2.45% of observations
xtset prvdr_num year

//generate nt_year (the total number of HHA in a year)
egen nt_year = count(prvdr_num), by (year)

//generate ne_year (the number of firms that entered between t-1 and t) and nx_year, the number of firms that exited between (t-1 and t). Note that ne_year doesn't make sense for 

egen int entryYr = min(year), by(prvdr_num)
egen int exitYr = max(year), by(prvdr_num)

gen byte entry = (year==entryYr)
gen byte exit = (year==exitYr)

bys year: egen ne_year = total(entry)
replace ne_year=. if year==1993
bys year: egen nx_year = total(exit)
replace nx_year=. if year==2022

sort prvdr_num year
gen ER_year = ne_year/L1.nt_year  
gen XR_year = nx_year/nt_year  

/*
Entry rates are defined as the number of new
entries for a particular post-acute provider divided by the total count in the
prior year. Exit rates are defined as the total exits in a given year divided by
the total providers in the prior year.
*/ 


lgraph nt_year year, nomarker xtitle("year") ytitle("N") title("Number of Home Health Agencies") //graph looks similar but a little bit higher

lgraph ne_year year if year >=1993, nomarker xtitle("year") ytitle("N") title("Entry of Home Health Agencies") // 

lgraph ER_year year if inrange(year,1993,2022), nomarker xtitle("year") ytitle("N") title("Entry of Home Health Agencies") //graph looks good, almost identical 

lgraph XR_year year if inrange(year,1992,2022), nomarker xtitle("year") ytitle("N") title("Exit of Home Health Agencies") //graph looks good, 1998 seems a bit higher than their paper but the rest looks identical 












