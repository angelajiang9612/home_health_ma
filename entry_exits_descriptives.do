//a crude look at entry and exit patterns in the data

//checked with CA data, N total broadly consistent but tend to be smaller than reported in CA data. 

//need to cross check with POS
 
//check if firms go in and out of this dataset (i.e. if panel not continuous)

use "/Users/bubbles/Desktop/HomeHealth/output/S_all", clear 

//sample selection 

destring prvdr_num, replace

sort prvdr_num year
//total number of HHAs each year 

bys prvdr_num year: gen dup = cond(_N==1,0,_n)
drop if dup>1 // keep only one record of a firm in a year, removed 2.45% of observations
xtset prvdr_num year

**********entry 

//generate nt_year (the total number of HHA in a year)
egen nt_year = count(prvdr_num), by (year)

//generate ne_year (the number of firms that entered between t-1 and t) and nx_year, the number of firms that exited between (t-1 and t). Note that ne_year doesn't make sense for 

egen int entryYr = min(year), by(prvdr_num)
egen int exitYr = max(year), by(prvdr_num)

gen byte entry = (year==entryYr)
gen byte exit = (year==exitYr)

bys year: egen ne_year = total(entry)
bys year: egen nx_year = total(exit)

sort prvdr_num year
gen ER_year = ne_year/L1.nt_year  
gen XR_year = nx_year/nt_year  

order  prvdr_num entryYr exitYr year  nt_year ne_year ER_year nx_year XR_year

lgraph nt_year year if year>=2000, nomarker xtitle("year") ytitle("N") title("Number of Home Health Agencies")

//br prvdr_num year entryYr exitYr nt_year ne_year ER_year nx_year XR_year

//variation in visit per patient 

//look at market share (unduplicated census) and quality (visit per patient (Medicare, others, all)), number of full visits per full episode

gen visits_per_person_xviii =total_visits_xviii/census_unduplicated_xviii
gen visits_per_person_others = total_visits_other/census_unduplicated_others
gen visits_per_person = total_visits/census_unduplicated_total 

gen visits_per_episode = total_visits_full_episode/total_episodes_full 
gen visits_per_episode_sn = sn_visits_full_episode/total_episodes_full
gen visits_per_episode_pt = pt_visits_full_episode/total_episodes_full
gen visits_per_episode_ot = ot_visits_full_episode/total_episodes_full
gen visits_per_episode_sp = sp_visits_full_episode/total_episodes_full
gen visits_per_episode_ms = ms_visits_full_episode/total_episodes_full
gen visits_per_episode_hha = hha_visits_full_episode/total_episodes_full //home health aides 

histogram visits_per_episode if year==2019 & inrange(visits_per_episode, 5, 45) //trim lower than minimum for full episode and higher than 99% percentile. 

histogram visits_per_episode_sn if year==2019 & visits_per_episode_sn <= 27
histogram visits_per_episode_pt if year==2019 & visits_per_episode_pt <= 14
histogram visits_per_episode_ot if year==2019 & visits_per_episode_ot <= 5 
histogram visits_per_episode_sp if year==2019 & visits_per_episode_sp <= 5 //99th percentile is 1.23 
histogram visits_per_episode_ms if year==2019 & visits_per_episode_ms <= 5 //99th percentile is 0.73

forvalues i = 2000/2019 {
	sum visits_per_episode_sn if year == `i', detail
	di `i'
}

//nonprofits and gov declined signficantly during this period


lgraph visits_per_episode year if year>=2000 & visits_per_episode<=70, nomarker //above the highest 99th percentile for the highest year, generally downwards trend, mean heavily influenced by max too high
lgraph visits_per_episode_sn year if year>=2000 & visits_per_episode_sn<= 55, nomarker 

lgraph visits_per_episode_pt year if year>=2000 & visits_per_episode_pt<= 16, nomarker //upwards trend 
lgraph visits_per_episode_ot year if year>=2000 & visits_per_episode_ot<= 6, nomarker //upwards trend 
lgraph visits_per_episode_sp year if year>=2000 & visits_per_episode_sp<= 5, nomarker //upwards trend 
lgraph visits_per_episode_ms year if year>=2000 & visits_per_episode_ms<= 5, nomarker //upwards trend 
lgraph visits_per_episode_hha year if year>=2000 & visits_per_episode_hha<= 25, nomarker //signficant downwards trend 

lgraph hha_chain year, nomarker 

lgraph nonprofit year, nomarker //nonprofits and governments seem to have really declined ove the years 

preserve
collapse (median) visits_per_episode visits_per_episode_sn visits_per_episode_pt visits_per_episode_ot visits_per_episode_sp visits_per_episode_ms  visits_per_episode_hha, by(year)
twoway line visits_per_episode visits_per_episode_sn visits_per_episode_pt visits_per_episode_ot visits_per_episode_sp visits_per_episode_ms  visits_per_episode_hha year if year>=2000
restore


preserve
collapse (mean) visits_per_episode visits_per_episode_sn visits_per_episode_pt visits_per_episode_ot visits_per_episode_sp visits_per_episode_ms  visits_per_episode_hha, by(year)
twoway line visits_per_episode visits_per_episode_sn visits_per_episode_pt visits_per_episode_ot visits_per_episode_sp visits_per_episode_ms  visits_per_episode_hha year if year>=2000
restore


preserve
collapse (mean) hha_chain nonprofit, by(year)
twoway line hha_chain nonprofit year if year>=2000
restore




//compute market shares 

bys year: egen total_census = total(census_unduplicated_total)
bys year: egen mean_visits_per_episode = mean(visits_per_episode)

bys year entry: egen total_census_entry = total(census_unduplicated_total) //total of incumbent and entrants 
bys year exit: egen total_census_exit = total(census_unduplicated_total) 

bys year entry: egen mean_visits_per_episode_entry = mean(visits_per_episode)
bys year exit: egen mean_visits_per_episode_exit = mean(visits_per_episode)

gen entrant_market_share = total_census_entry/total_census if entry ==1
gen exiter_market_share = total_census_exit/total_census if exit == 1

sort entry year

/*
//br entry year entrant_market_share

bys exit year: gen dupp = cond(_N==1,0,_n)
drop if dupp>1 

br exit year mean_visits_per_episode_exit

*/
******probably instead of dropping just do conditioning 
drop if visits_per_person_others >= 932 //drop those larger than 99th percentile //should considering including missing 
drop if visits_per_person_xviii>=278 //drop those larger than 99th percentile
drop if census_unduplicated_total > 10000 //drop outliers --need to think more about how this is done, maybe check across the years and drop observations that do not seem plausible. Or just do largest excluded versions. 

drop if visits_per_episode > 100 & !missing(visits_per_episode) //get rid of unreliable outliers 
drop if visits_per_episode <=4 
//lgraph visits_per_episode year if year>=2000, nomarker //some suspicious reporting seem to be driving 2013 and 2014 up a lot, 




//lgraph  visits_per_person_xviii year, nomarker

lgraph census_unduplicated_total year if year>=2000, nomarker //again something looks weird for the 2012-2014 years. A big dip census unduplicated. Would this match with a quality quantity tradeoff thing? What is driving the weirdness in those years? exist for prior 2000 years but data look very strange. 

lgraph census_unduplicated_total year if year>=2000, nomarker 
 
lgraph visits_per_person_xviii year, nomarker //sharp decline in visits per person when changed to PPS
 
lgraph visits_per_person_others year, nomarker 

//entrant quality and market share 
























