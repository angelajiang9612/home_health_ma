//Poisson regression vs just a normal linear regression results. 

//2019 much more entry and exits, back to normal 2020-2022, might want to exclude these years--maybe because of the policy change in 2020, could also try for only post the PPS (PPS introduced in 2000)

//include or exclude the extrapolated data for MA penetration. 

//try weighting the counties by population 

//could add CON laws control later 

//try commuting zones or hospital regions as area instead of counties 

//try something that controls for the size of entrants on the left hand side, maybe HHI type? 

//try exclude Puerto Rico, often have missing data issues 

//think about the implication of missing variables for y, try versions conditioning having at least some stock for entry and exit 

// a third of the county years have missing value for outcome variables 

//try setting it as panel vs not setting it as panel 

//can try binary variable for there being an entry or an exit or not? LPM type. 

//poisson regressions seem extremely slow 


cd /Users/bubbles/Desktop/HomeHealth/output/

log using MA_entry_cluster.log, replace 

use merged_pos_MA.dta, clear

gen log_pop = log(persons_tot)

local controls per_capita_income percent_black percent_hispan log_pop percent_65_74 percent_75_plus n_hosp_pc //same as Huckfeldt et al 2013 but no CON laws yet -used year fixed effects rather than linear time trends. 

reg n_firms penetration `controls' i.county_id i.year, vce (cluster state)

reg n_entrants penetration `controls' i.county_id i.year, vce (cluster state)

reg n_exits penetration `controls' i.county_id i.year, vce (cluster state)

log close 













