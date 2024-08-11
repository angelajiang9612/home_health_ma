//pseudo code for summary stats comparing with vs without MA firms and generally how much MA

cd /Users/bubbles/Desktop/HomeHealth/temp
sysuse auto.dta, clear //one year data 

egen tag = tag(rep78)

egen tag_1 = tag(rep78) if weight<=3000

collapse (mean) mean1=price (sd) sd1=price (semean) sem1=price (sum) tag_tot=tag, by(foreign)

collapse price mpg , by(foreign)

save testme.dta 

/////////////

//can variables be missing in this dataset?

cd

use data.dta 

keep if STATE_ID == "WI" //only available from version C (2010 onwards)

keep if M0014_BRANCH_STATE == "WI" //available in all years 

sample 10 //sample random 10 percentage of data. 

//payment information in the data 
rename M0150_CPY_MCAIDFFS medicaid_FFS
rename M0150_CPY_MCAREFFS medicaid_others
rename M0150_CPY_MCAREFFS medicare_FFS
rename M0150_CPY_MCAREHMO medicare_MA 
rename M0150_CPY_NONE no_charge 
rename M0150_CPY_OTH_GOVT other_gov
rename M0150_CPY_OTHER other_payer
rename M0150_CPY_PRIV_HMO private_managed
rename M0150_CPY_PRIV_INS private_insurance 
rename M0150_CPY_SELFPAY self_pay

gen pay_others =(no_charge==1 | other_gov==1 | other_payer==1 | private_managed==1| private_insurance==1|self_pay==1)

egen tag = tag(BENE_ID) //unique individuals 
egen tag_medicaid_FFS= tag(BENE_ID) if medicaid_FFS==1
egen tag_medicaid_others= tag(BENE_ID) if medicare_MA==1
egen tag_medicare_FFS= tag(BENE_ID) if medicare_FFS==1
egen tag_medicare_MA = tag(BENE_ID) if medicare_MA ==1
egen tag_others =  tag(BENE_ID) if pay_others ==1

collapse (sum) unique_persons=tag (sum) persons_medicaid_FFS=tag_medicaid_FFS (sum) persons_medicaid_others=tag_medicaid_others (sum) persons_medicare_FFS=tag_medicare_FFS (sum) persons_medicare_MA=tag_medicare_MA (sum) persons_others=tag_others, by(M0010_MEDICARE_ID)  

//merge with quality and costs data from the Medicare cost reports. 





//M0010_MEDICARE_ID is the Medicare certification number (CCN), need to check if it is the same for all branches for chains. -probably not. 





//not sure if Medicare provider number or branch ID should be used



//currently the data is at assessment level, need to convert to firm level and/or individual level 

