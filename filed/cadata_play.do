//Home health agencies are not really all operating, sizes very different 
**initial look at some descriptives

cd "/Users/bubbles/Desktop/NH_data_&_application"

import excel "/Users/bubbles/Desktop/NH_data_&_application/home_health/hhah_22.xlsx", sheet("Page 1-11") clear

keep if ENTITY_TYPE=="Home Health Agency Only" //very few home health and hospice,0.81%. More than 2000 home health agencies. 

tab ENTITY_RELATION //80% Sole Facility 
tab HHAH_LICEE_TOC //only 4.63% non-profits
tab HHAH_CERT_FOR_HHA //92% medicare certified, 70% Medicare and Medicaid, 23% Medicare only, 1% Medicare only 
tab HHAH_REGISTERED_NURSE_HOME_VISIT //25.85% have RN that makes home visits
tab HHAH_SPECIAL_SERVICES_IV_THERAPY, mi //this seems like the most popular added services, 23%, others all have less 
sum HHAH_UNDUPLICATED_PERS, detail //lots of variation in the number of customers, high mean low median

tab HHAH_PERFORM_OTHER_SERVICES //only 7% performed any home care services (continuous care)

tab HHAH_HOME_HEALTH_* //should clarify whether these are just other servies, whether HHAH_HOME_HEALTH_TOT_VISITS is just the total of these other services or total of all services, which would be weird because most facilities have this line as missing


///50-54, home health other services, HHAH_CERT_NURSE_ASSISTANT etc, very few HHA have these services, less than 5%

**patients by age, see if can obtain unmasked version for research purpose

tab HHAH_REFERRALS* //many missing values, but the biggest group is referral from hospitals (generally not missing), and then referral from long-term care facilities and physicians, very few 'self',

br HHAH_TOT_REFERRALS //total referrals in general not missing, this number tend to be similar to the number of non-duplicate people, this probably means the missing in other categories are zeros, can used to check

//discharges, biggest reason for discharge was care no longer needed (vast majority), then family took over, hospitals/nursing homes and patient refused services, few deaths and very few no funds 


// why home health aide service so few chose X but so many HHAH have home aide visits 


//Types of visits: the big categories for types of visits are home health aides, skilled nursing, and occupational physical therapist, doesn't look like there is too much specialisation going on 


//Source of payment: there seem to be some specialisation in by payer source, the most popular sources are Medicare, (Medicare Advantage) HMO and PPO and other sources (this one is a big part of some home health organizations but not others)


//TRICARE is the uniformed services health care program for active duty service members (ADSMs), active duty family members (ADFMs

//HHAH_TOT_PATS_BY_PRINCIPAL_DIAGN HHAH_UNDUPLICATED_PERS are similar, number of patients is generally not large.

//TOT_visits by principal diagnosis. 



