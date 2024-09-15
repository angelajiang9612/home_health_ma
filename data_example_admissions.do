/*


Constructing census using incomplete admissions and discharge data 
​​​​​​​
Hi all,

I am trying to construct census data using admissions and discharge data. ​​​​​​​I have data at the assessment level. Each patient is supposed to be assessed when they are admitted and when they are discharged (though in practice this do not happen all the time). The problem is I do not observe both admission and discharge for all patients. My data starts in 2006, some patients were admitted in 2005 but discharged in 2006 but in this case I will only see their discharge date. Others are admitted in the last year I observe (2019) but I not see their discharge dates. I do not observe census at the beginning of my data period (2006). I know on average each person is a patient for something like 40 days.

Robert's advice: https://www.statalist.org/forums/forum/general-stata-discussion/general/139328-converting-data-from-time-periods-to-counts-on-days

I am trying to understand the best way to get a census information that overcomes the problem of not observing stock at the beginning. I am constructing census data to understand the relationship between congestion (using census measure) and outcomes like health improvement of patients. The final outcome I am interested in is the health entity's congestion levels relative to itself (e.g. its census as a percentile). 


My data looks something like 
id  assess_date  assess_reason 
1   20180309.       1
1   20180609.       2

*/ 

clear

input long id adm_date dis_date
1 20160308 20160509
2 0        20160203
3 20161223 0 
4 20160708 20160909 
5 20160703 20160925
6 0        20160102
7 20161225 0

end

format %10.0g adm_date dis_date

expand 2 
bys id: gen long date =cond(_n==1,adm_date,dis_date)
bys id: gen inout=cond(_n==1,1,-1)
drop if date==0 //if no date information cannot be used to calculate stocks because will lead to problem when sorting 

sort date
gen present = sum(inout) 

xtile quart = present, nq(4)

gen init_census =5 if _n==1

gen present_real = present + 5  

xtile quart_real = present_real, nq(4)


//why isn't not observing initial a problem here?

////









