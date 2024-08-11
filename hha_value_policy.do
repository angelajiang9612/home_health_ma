*the effect of home health agency value policy on visits, type of visits, and admissions. 

///policy-https://www.cms.gov/priorities/innovation/innovation-models/home-health-value-based-purchasing-model 

///policy time -January 1, 2016 through December 31, 2021. 

///policy states-Massachusetts, Maryland, North Carolina, Florida, Washington, Arizona, Iowa, Nebraska, and Tennessee  

///exclusion states moratorium and information on review demonstration projects  -https://www.lilesparker.com/2019/02/19/cms-review-choice-demonstration-project/
//www.cms.gov/data-research/monitoring-programs/medicare-fee-service-compliance-programs/prior-authorization-and-pre-claim-review-initiatives/review-choice-demonstration-home-health-services
//States affected-Florida, Illinois, Michigan and Texas,--main thing in August 2016--use state borders?

//entry+exits 

//divide by quality star ratings in 2016
//divide by chain status and forprofit 

/* *what about in years 2016 and 2017? can double check on this. --no adjustment but 2018 adjustment based on 2016 results
a maximum payment adjustment of 3 percent (upward or downward) in 2018,
a maximum payment adjustment of 5 percent (upward or downward) in 2019,
a maximum payment adjustment of 6 percent (upward or downward) in 2020,
a maximum payment adjustment of 7 percent (upward or downward) in 2021.
*/ 

//did the policy have differential effects for home health agencies that mainly serve TM and MA patients?
//seems to be robust to exclusion of outliers

//question-why is only the Medicare group affected? 

//should do something with the charges data too

//can look at labor and charges too 

//look at the technical appendix by the government and check what other things are controlled 

//tried state linear time trends and excluding some of the states as the government did, and also different levels of winsorization, and not dropping moratorium states, increase in visits still appears, but sometimes in relative increase in TM vs others do not hold. 

//government found modest and some years significant increase in the percentage of TM using home health in treated states, decline in Medicare advantage in treated states larger than decline in Medicare advantage in control states. -possibly can do a DID in MA TM ratio by quality and use it as part of motivation. 

//try grouping by ratings

cd "/Users/bubbles/Desktop/HomeHealth/output/"
***************************************

use S_all_final_wratings.dta, clear 

gen post_2016 = year >= 2016 //
gen treated_group =1 if inlist(state,"MA","MD","NC","FL","WA","AZ","IA","NE","TN")
gen treated=post_2016*treated_group //don't actually need this variable 

//drop the states with the moratorium from comparison 
drop if inlist(state,"FL","IL","MI","TX")

gen timedd = year - 2016 if treated_group ==1 //this is the key variable, missing for control states 
keep if year>=2010

//try split into three groups, roughly to get 25% in top and bottom groups 

gen quality_group=1 if inrange(ratings_16,1,2.5) 
replace quality_group=2 if inrange(ratings_16,3,3.5) 
replace quality_group=3 if inrange(ratings_16,4,5) 

label define quality_group 1 "low" 2 "medium" 3 "high"

tab quality_group

//the event studies 

local types sn pt ot sp ms hha

keep if quality_group==3

local othervars total_visits_xviii total_visits_other total_visits census_unduplicated_xviii census_unduplicated_others census_unduplicated_total

foreach var in `othervars' {
	eventdd `var'_in i.year  i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_high.jpg", as(jpg) name(Graph) quality(90) replace
}




//total visits and patients, total visits increasing because total patients increasing? or another interpretation is now offering a more diverse range of visits types to patients-since overall numbers do not seem to be increasing

foreach var in `types' { 
	eventdd `var'_visits_xviii_in i.year i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'_visits_xviii"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_visits_xviii.jpg", as(jpg) name(Graph) quality(90) replace
	
	eventdd `var'_patients_xviii_in i.year i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'_patients_xviii"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_patients_xviii.jpg", as(jpg) name(Graph) quality(90) replace
	
	eventdd `var'_visits_others_in i.year i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'_visits_others"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_visits_others.jpg", as(jpg) name(Graph) quality(90) replace
	
	eventdd `var'_patients_others_in i.year i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'_patients_others"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_patients_others.jpg", as(jpg) name(Graph) quality(90) replace	
}

//visits per patient--doesn't seem to be increasing?  -almost look like an increase in the others categories but not the medicare categories

local types sn pt ot sp ms hha

foreach var in `types' {
	eventdd `var'_visits_pi_xviii_in i.year i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'_visits_pi_xviii"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_visits_pi_xviii.jpg", as(jpg) name(Graph) quality(90) replace
	
	eventdd `var'_visits_pi_others_in i.year i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'_visits_pi_others"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_visits_pi_others.jpg", as(jpg) name(Graph) quality(90) replace
}


//total visits per person--no change, should probably check the way some of this is constructed to reduce noise

local totals visits_per_person_xviii visits_per_person_others visits_per_person

 foreach var in `totals' {
	eventdd `var'_in i.year  i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'.jpg", as(jpg) name(Graph) quality(90) replace
}

//medicare PPS total visits this is similar to above, just didn't divide to full episodes vs the rest

local types sn pt ot sp ms hha total  

 foreach var in `types' {
	eventdd `var'_visits_full_episode_in i.year  i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("`var'_visits_full_episode"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/`var'_visits_full_episode.jpg", as(jpg) name(Graph) quality(90) replace
}

local types sn pt ot sp ms hha total   

 foreach var in `types' { //some weak indication of an increase (small in magnitude), but really depends on if extend of upper end trimming, for the less essential services there is an increase, seem to be supportive of more different types of services provided, magnitudes are very small, probably because baseline is small 
	eventdd visits_per_episode_`var'_in i.year  i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("visits_per_episode_`var'"))
	graph export "/Users/bubbles/Desktop/HomeHealth/tables_graphs/visits_per_episode_`var'.jpg", as(jpg) name(Graph) quality(90) replace
}

//number of firms, number of entries and exits-doesn't look like there is anything here

eventdd nt_year i.year  i.state_code, timevar(timedd) method(, cluster(state_code)) graph_op(title("nt"))

eventdd ne_year i.year  i.state_code if year<=2019, timevar(timedd) method(, cluster(state_code)) graph_op(title("ne")) 

eventdd nx_year i.year  i.state_code if year<=2018, timevar(timedd) method(, cluster(state_code)) graph_op(title("nx"))












