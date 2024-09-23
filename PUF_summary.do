import delimited "/Users/bubbles/Desktop/hha_data/CMS_PUF_county/2014-2022 Medicare FFS Geographic Variation Public Use File.csv", clear 

keep if year==2019 & bene_geo_lvl == "National"

keep if bene_age_lvl == "All"

br bene_age_lvl snf_mdcr_stdzd_pymt_per_user  irf_mdcr_stdzd_pymt_per_user ltch_mdcr_stdzd_pymt_per_user hh_mdcr_stdzd_pymt_per_user

br snf_mdcr_stdzd_pymt_pct ltch_mdcr_stdzd_pymt_pct irf_mdcr_stdzd_pymt_pct hh_mdcr_stdzd_pymt_pct 




