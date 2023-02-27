*********************************************************
*** Gendered Life Courses & Gender Inequalities Paper ***
*********************************************************

* A Bertogg *
* September 2022 *
* Modelling only, for data preparation, see respective do-file *

set maxvar 10000

use "C:\Users\abertogg\Desktop\DATA in use\Ariane Anja Daten\analysefile_w1tow5_retromacro_w8.dta" 

xtset newid wave


*** Define relevant variables and Filter Missings (Listwise) ***

* Listwise deletion of cases with missing values on the covariates *
mark nomiss
markout nomiss functional_neu edu_cat eurod vigorous_weekly moderate_weekly empl4neu sectors_new soc_act educ_act civilneu2 i_nchild_neu i_ngrchild_neu given received ends_neu born_in_country female sharecohort 

* define covariates *
global controls functional_neu ib1.edu_cat eurod vigorous_weekly moderate_weekly ib1.empl4neu i.sectors_new i.job_stim_neu i.job_agency_neu soc_act educ_act ib1.civilneu2 i_nchild_neu i_ngrchild_neu given received ib2.ends_neu born_in_country rs_withpartner rs_withchildren

global lifecourse rs_ft rs_pt rs_unemp rs_homemaking rs_otherneu rs_withpartner rs_withchildren

global lmcontrols i.isco10_new i.job_stim_neu i.job_agency_neu


* Mark cases without valid retrospective data *
* prefix rs denotes retrospective *
mark nomiss_lc
markout nomiss_lc rs_ft rs_pt rs_unemp rs_homemaking rs_otherneu

* Mark cases without valid information on job characteristics (entered the survey being retired at baseline) *
mark nomiss_lm
markout nomiss_lm isco10_new job_stim_neu job_agency_neu

* Mark cases with less than 50 per cent valid information on the employment spells *
ge rs_miss_filt=0
replace rs_miss_filt=1 if rs_miss>50



********************
*** Descriptives ***
********************

graph hbar cogscore if agegr5075==1&filter==1, over(country) by(female)
gr save cogscore_over_country.gph

graph hbar rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu if agegr5075==1&filter==1, over(country) by(female) stack
gr save lifecourse_over_country.gph, replace

graph hbar rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu if agegr5075==1&filter==1, over(sharecohort) by(female) stack
gr save lifecourse_over_cohort.gph, replace

graph hbar cogscore if agegr5075==1&filter==1, over(typical4) by(female)
gr save cogscore_over_lifecourse.gph

gr combine lifecourse_over_country.gph cogscore_over_country.gph lifecourse_over_cohort.gph cogscore_over_lifecourse.gph
gr save Figure A1.gph



***************************
*** Growth Curve Models ***
***************************

*** Two-Level Models *** 
** PErson-years nested in Persons, time trend, squared time trend and random slope of time variable for each individual **

* Empty model *
qui mixed z_cogscore time time_sq || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estat icc
estadd scalar ICC = `r(icc2)'
est sto p1women

qui mixed z_cogscore time time_sq || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estadd scalar ICC = `r(icc2)'
est sto p1men


* Only Life Course, Time Trends, Cohort and Age at Baseline *
qui mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estat icc
estadd scalar ICC = `r(icc2)'
est sto p5women

qui mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2  rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estadd scalar ICC = `r(icc2)'
est sto p5men


* Only Controls and Life Course *
qui mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estat icc
estadd scalar ICC = `r(icc2)'
est sto p6women

qui mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estadd scalar ICC = `r(icc2)'
est sto p6men


* Add Job Characteristics *
qui mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren ib0.job_stim_neu ib0.job_agency_neu || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estat icc
estadd scalar ICC = `r(icc2)'
est sto p7women

mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren ib1.isco10_new ib0.job_stim_neu ib0.job_agency_neu || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estat icc
estadd scalar ICC = `r(icc2)'
est sto p7men


* Add Country Fixed Effects *
qui mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2 ibn.country $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&female==0  
estat icc
estadd scalar ICC = `r(icc2)'
est sto p8_men

qui mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2 ibn.country $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&female==1 
estat icc
estadd scalar ICC = `r(icc2)'
est sto p8_women

esttab p6women p7women p8_women p6men p7men p8_men using "Composite Score Table 1.rtf", b(3) not nogap mti lab replace scalars(ICC)


* Plot *
coefplot p8_men p8_women, keep(*empl4neu)
gr save lifecourse_bygender1.gph, replace
coefplot p6men p8_men p6women p8_women, keep(rs_pt rs_homemaking rs_unemployed rs_otherneu)
gr save lifecourse_bygender4.gph, replace

coefplot p5men p6men p8_men, keep(rs_pt rs_homemaking rs_unemployed rs_otherneu)
gr save lc_men.gph, replace
coefplot p5women p6women p8_women, keep (rs_pt rs_homemaking rs_unemployed rs_otherneu)
gr save lc_women.gph, replace
gr combine lc_men.gph lc_women.gph, replace
gr save Fig2.gph, replace

coefplot p8_men p8_women, keep(*edu_cat)
gr save edu.gph, replace

coefplot p8_men p8_women, keep(*sectors_new)
gr save sectors.gph, replace

gr combine edu.gph sectors.gph
gr save edu_and_sector.gph, replace

coefplot p8_men p8_women, keep(*country)
gr save country_fixedeffects.gph



****************************************************
*** Explore the Contextual Level Variance Better ***
****************************************************

*** Explore the Country Intercepts ***
* For a more intuitive overview of country effects: new country ordering *
drop countr_ord 
recode country (13=1) (18=2) (14=3) (23=4) (17=5) (20=6) (12=7) (11=8) (30=9) (28=10) (35=11) (34=12) (47=13) (32=14) (29=15) (15=16) (16=17) (19=18) (33=19), gen(countr_ord)
lab define countr_ord 1"Sweden" 2"Denmark" 3"Netherlands" 4"Belgium" 5"France" 6"Switzerland" 7"Germany" 8"Austria" 9"Ireland" 10"Czech Republic" 11"Estonia" 12"Slovenia" 13"Croatia" 14 "Hungary" 15"Poland" 16"Spain" 17"Italy" 18"Greece" 19"Portugal", replace
lab val countr_ord countr_ord


* Use Croatia as Reference *
mixed z_cogscore time time_sq  ib1.sharecohort age_baseline agebase2 ib13.countr_ord $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&female==0
estat icc
estadd scalar ICC = `r(icc2)'
est sto p8_ordered_men

mixed z_cogscore time time_sq  ib1.sharecohort age_baseline agebase2 ib13.countr_ord $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&cogfilt_conservative==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&female==1
estat icc
estadd scalar ICC = `r(icc2)'
est sto p8_ordered_women

coefplot p8_ordered_men p8_ordered_women, keep(*countr_ord) base
gr save countryFE_ordered2.gph, replace


* Calculate a Random Intercept for each Country  (No Reference Category) - for that purpose, omit the constant *
mixed z_cogscore time time_sq  ib1.sharecohort age_baseline agebase2 ibn.countr_ord $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren, nocons || mergeid: time if agegr5075==1&cogfilt_conservative==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&female==0
estat icc
estadd scalar ICC = `r(icc2)'
est sto p8_ordered_men

mixed z_cogscore time time_sq  ib1.sharecohort age_baseline agebase2 ibn.countr_ord $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren, nocons || mergeid: time if agegr5075==1&cogfilt_conservative==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&female==1
estat icc
estadd scalar ICC = `r(icc2)'
est sto p8_ordered_women

coefplot p8_ordered_men p8_ordered_women, keep(*countr_ord) base
gr save countryFE_ordered3.gph, replace



***  Three-Level Models ***
** Null Models **
* Women *
mixed z_cogscore time time_sq || country: || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
estadd scalar ICC3 = `r(icc3)'
est sto threelevel_women_null

* Men *
mixed z_cogscore time time_sq ||country: || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
estadd scalar ICC3 = `r(icc3)'
est sto threelevel_men_null


** Full controls **
* Women *
mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 $controls $lifecourse || country: || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estat icc
estadd scalar ICC = `r(icc2)'
estadd scalar ICC3 = `r(icc3)'
est sto threelevel_women_full

* Men *
mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 $controls $lifecourse ||country: || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5 
estat icc
estadd scalar ICC = `r(icc2)'
estadd scalar ICC3 = `r(icc3)'
est sto threelevel_men_full

esttab threelevel_women_null threelevel_women_full threelevel_men_null threeleve_men_full using "Threelevel.rtf", b(3) not nogap mti replace
* ICCs look really good *



*** Do separate analyses by country ***
* Need to kick out Ireland, because it is not running through when estimated alone, due to low case numbers *

gen countr_ord_neu=countr_ord
replace countr_ord_neu=. if country==30
replace countr_ord_neu=countr_ord_neu-1 if countr_ord_neu>8

lab define countr_ord_neu 1"Sweden" 2"Denmark" 3"Netherlands" 4"Belgium" 5"France" 6"Switzerland" 7"Germany" 8"Austria" 9"Czech Republic" 10"Estonia" 11"Slovenia" 12"Croatia" 13"Hungary" 14"Poland" 15"Spain" 16"Italy" 17"Greece" 18"Portugal", replace
lab val countr_ord_neu countr_ord_neu

local i countr_ord_neu
forval i=1/18 {
	mixed z_cogscore time time_sq age_baseline agebase2 $controls rs_pt rs_unemployed rs_homemaking rs_otherneu rs_withpartner rs_withchildren || mergeid: time if agegr5075==1&filter==1&countr_ord_neu==`i'
	est sto country_`i'
	est sto forplot
	coefplot forplot, keep(rs_pt rs_unemployed rs_homemaking rs_otherneu) title ("Country `i'")
	graph save lc_`i'.gph, replace
	drop _est_forplot
}

gr combine lc_1.gph lc_2.gph lc_3.gph lc_4.gph lc_5.gph lc_6.gph  lc7.gph lc_8.gph lc_9.gph lc_10.gph lc_11.gph lc_12.gph lc_13.gph lc_14.gph lc_15.gph lc_16.gph lc_17.gph lc_18.gph 
gr save lc_by_country.gph, replace

esttab country_1 country_2 country_3 country_4 country_5 country_6 country_7 country_8 country_9 country_10 country_11 country_12 country_13 country_14 country_15 country_16 country_17 country_18 using "Separate Regressions by Country.rtf", b(3) not nogap mti replace



*********************************************
*** Explain Country Variance w/ Indicators ***
**********************************************

*** Structural Inequalities ***
** Descriptive **
/*
pwcorr cogscore gpaygap if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5, sig
pwcorr cogscore femp5065 if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5, sig
pwcorr cogscore gpaygap if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5, sig
pwcorr cogscore femp5065 if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5, sig


* Twoway Scatterplot (Not yet adjusted for Individual-Level Variables) *
twoway scatter cogscore femp5065 if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore femp5065 if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc1.gph, replace

twoway scatter cogscore femp5065 if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore femp5065 if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc2.gph, replace

twoway scatter cogscore GDI if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore GDI if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc3.gph, replace

twoway scatter cogscore GDI if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore GDI if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc4.gph, replace

twoway scatter cogscore GII if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore GII if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc5.gph, replace

twoway scatter cogscore GII if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore GII if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc6.gph, replace

gr combine sc1.gph sc2.gph sc3.gph sc4.gph sc5.gph sc6.gph
gr save scatter_normsnew2.gph
*/


** Interacted with Life Course **
mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2 c.rs_pt##c.femp5065_ctr c.rs_homemaking##c.femp5065_ctr c.rs_unemployed##c.femp5065_ctr c.rs_otherneu gdp_percap_ctr $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&rs_miss_filt==0&eurod<5
est sto p9b_femp

mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2 c.rs_pt##c.femp5065_ctr c.rs_homemaking##c.femp5065_ctr c.rs_unemployed##c.femp5065_ctr c.rs_otherneu gdp_percap_ctr $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&rs_miss_filt==0&eurod<5
est sto p9b_female_femp

mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2  c.rs_pt##c.GII_ctr c.rs_homemaking##c.GII_ctr c.rs_unemployed##c.GII_ctr c.rs_otherneu rs_withpartner rs_withchildren gdp_percap_ctr $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&rs_miss_filt==0&eurod<5
est sto p9b_GII

mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2  c.rs_pt##c.GII_ctr c.rs_homemaking##c.GII_ctr c.rs_unemployed##c.GII_ctr c.rs_otherneu rs_withpartner rs_withchildren gdp_percap_ctr $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&rs_miss_filt==0&eurod<5
est sto p9b_female_GII

esttab  p9b_femp p9b_GII  p9b_female_femp  p9b_female_GII  using "Macros Structural2 - Interacted.rtf", b(3) not nogap mti lab replace 



*** Normative Inequalities ***

** Descriptive **
* Correlate Level with Gender Norm Index *
/*
sort sharecohort

by sharecohort: pwcorr cogscore normindex if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5, sig

by sharecohort: pwcorr cogscore normindex if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5, sig

* Twoway Scatterplot (Not yet adjusted for Individual-Level Variables) *
twoway scatter cogscore normindex [aweight=cciw]  if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore normdindex [aweight=cciw]  if female==0&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc1.gph, replace

twoway scatter cogscore normindex [aweight=cciw]  if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5 || lfit cogscore normindex [aweight=cciw]  if female==1&agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5
gr save sc2.gph, replace

gr combine sc1.gph sc2.gph 
gr save scatter_normsnew5075.gph


ge filter=0
replace filter=1 if agegr5075==1&cogfilt_conservative==1&nomiss==1&nomiss_lc==1&rs_miss_filt==0&eurod<5

twoway scatter cogscore normindex if filter==1&sharecohort==1&female==0 || lfit cogscore normindex if filter==1&sharecohort==1&female==0
gr save c1men.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==2&female==0 || lfit cogscore normindex if filter==1&sharecohort==2&female==0
gr save c2men.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==3&female==0 || lfit cogscore normindex if filter==1&sharecohort==3&female==0
gr save c3men.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==4&female==0 || lfit cogscore normindex if filter==1&sharecohort==4&female==0
gr save c4men.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==5&female==0 || lfit cogscore normindex if filter==1&sharecohort==5&female==0
gr save c5men.gph, replace

twoway scatter cogscore normindex if filter==1&sharecohort==1&female==1 || lfit cogscore normindex if filter==1&sharecohort==1&female==1
gr save c1women.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==2&female==1 || lfit cogscore normindex if filter==1&sharecohort==2&female==1
gr sav ec2women.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==3&female==1 || lfit cogscore normindex if filter==1&sharecohort==3&female==1
gr save c3women.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==4&female==1 || lfit cogscore normindex if filter==1&sharecohort==4&female==1
gr save c4women.gph, replace
twoway scatter cogscore normindex if filter==1&sharecohort==5&female==1 || lfit cogscore normindex if filter==1&sharecohort==5&female==1
gr save c5women.gph, replace

gr combine c1men.gph c1women.gph c2men.gph c2women.gph c3men.gph c3women.gph c4men.gph c4women.gph c5men.gph c5women.gph
gr save scatter_norms_cohort.gph, replace
*/



** Multivariate **
* Raw Effects of Gender Norms *
mixed z_cogscore time time_sq rightjob_c  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto rightraw

mixed z_cogscore time time_sq  cutdown_c  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto cutraw

mixed z_cogscore time time_sq rightjob_c $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto rightraw_female

mixed z_cogscore time time_sq cutdown_c || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto cutraw_female


** Main Effects of Gender Norms **
* Gender Norms Separate *
mixed z_cogscore time time_sq rightjob_c $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto rightmain

mixed z_cogscore time time_sq cutdown_c $controls   || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto cutmain

mixed z_cogscore time time_sq rightjob_c $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto rightmain_female
mixed z_cogscore time time_sq  cutdown_c $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto cutmain_female

* Mediated *
mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2 rightjob_c $controls rs_pt rs_unemployed rs_homemaking rs_otherneu || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto righmed

mixed z_cogscore time time_sq i.female ib1.sharecohort age_baseline agebase2 cutdown_c $controls  rs_pt rs_unemployed rs_homemaking rs_otherneu || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto cutmed

mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 rightjob_c $controls rs_pt rs_unemployed rs_homemaking rs_otherneu || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto rightmed_female

mixed z_cogscore time time_sq ib1.sharecohort age_baseline agebase2 cutdown_c $controls rs_pt rs_unemployed rs_homemaking rs_otherneu || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_lc==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto cutmed_female

esttab rightraw rightmain rightmed cutraw cutmain cutmed rightraw_female rightmain_female rightmed_female cutraw_female cutmain_female cutmed_female using "Macros - Stepwise.rtf", b(3) not nogap mti lab replace scalar (ICC) 


** Interacted: Gender Norms*Life Course **
* (Not adjusting for structural inequality, not adjusted for GDP percapita) *
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11rightneu

mixed z_cogscore time time_sq  c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls   || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_rightneu

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_cutneu

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estadd scalar ICC = `r(icc2)'
est sto p11male_cutneu

esttab p11rightneu p11male_cutneu p11female_rightneu p11female_cutneu using "Macros - Interacted5075-nogdp2.rtf", b(3) not nogap mti lab replace scalars (ICC)


** Do gender norms still play a role when...? **
* (Adjusting for structural inequality) *
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls GII_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11right

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  GII_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_right

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls GII_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_cut

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  GII_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11male_cut

esttab p11right p11male_cut p11female_right p11female_cut using "Macros - Adjusted for GII-neu.rtf", b(3) not nogap mti lab replace scalars (ICC)


* Female EMployment in the Age Group 50-65 *
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls femp5065_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11right

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  femp5065_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_right

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls femp5065_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_cut

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  femp5065_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11male_cut

esttab p11right p11male_cut p11female_right p11female_cut using "Macros - Adjusted for Femp-neu.rtf", b(3) not nogap mti lab replace scalars (ICC)


** Adjusting for GDP **
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls gdp_percap|| mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11right_gdp

mixed z_cogscore time time_sq  c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  gdp_percap || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_right_gdp

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls gdp_percap || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_cut_gdp

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls gdp_percap || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estadd scalar ICC = `r(icc2)'
est sto p11male_cut_gdp

esttab p11right_gdp p11male_cut_gdp p11female_right_gdp p11female_cut_gdp using "Macros - Interacted5075-GDP.rtf", b(3) not nogap mti lab replace scalars (ICC)



** Plot **
* Use typical groups instead of percentages *
/* * Generate Typical Trajectories *
sum rs_ft rs_pt rs_homemaking rs_unemployed if female==1
sum rs_ft rs_pt rs_homemaking rs_unemployed if female==0

ge typical_male=.
replace typical_male=1 if rs_ft>89
replace typical_male=2 if rs_pt>0&rs_ft<90
replace typical_male=3 if rs_homemaking>0&rs_ft<90
replace typical_male=4 if rs_unemployed>0&rs_ft<90
replace typical_male=. if female==1
ge typical_female=.
replace typical_female=1 if rs_ft>65
replace typical_female=2 if rs_pt>9&rs_ft<66
replace typical_female=3 if rs_homemaking>9&rs_ft<66
replace typical_female=4 if rs_unemployed>0&rs_ft<90
replace typical_female=. if female==0

ren typical_male typical_male4
ren typical_female typical_female4

lab define typical_male 1"Full-time min. 90%" 2"Part-time >0%" 3"Homemaking >0%" 4"Unemployed >0%" replace
lab define typical_female 1"Full-time mind. 66%" 2"Part-time mind. 10%" 3"Homemaking mind. 10%" 4 "Unemployed >0%" replace
lab val typical_female4 typical_female
lab val typical_male4 typical_male

graph hbar typmal1-typmal4 if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&count==1&nomiss_lc&rs_miss_filt==0&eurod<5, over(sharecohort) 
gr save typical_men.gph

graph hbar typfem1-typfem4 if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&count==1&nomiss_lc&rs_miss_filt==0&eurod<5, over(sharecohort) 
gr save typical_women.gph

gr combine typical_men.gph typical_women.gph
gr save "Typical Trajectories.gph"
*/



*** Gender Norm Index ***
/*ge normindex=(rightjob+cutdown)/2
sum normindex
ge normindex_c=(normindex-38)/15.9
*/ 

** Interact with Prev Employment Variables **
mixed z_cogscore time time_sq c.normindex_c##c.rs_pt c.normindex_c##c.rs_homemaking c.normindex_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11female_normindex

mixed z_cogscore time time_sq c.normindex_c##c.rs_pt c.normindex_c##c.rs_homemaking c.normindex_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto p11male_normindex

esttab p11female_normindex p11male_normindex using "Normindex.rtf", b(3) not nogap mti replace


** Interact with Typcial Groups **
mixed z_cogscore time time_sq c.normindex##ib1.typical4 c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls gdp_percap_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
margins, at (typical4=(1 2 3 4) normindex=(10(10)80))
marginsplot, x(normindex)
gr save female_norm2.gph, replace

mixed z_cogscore time time_sq c.normindex##ib1.typical4 c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls gdp_percap_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
margins, at (typical4=(1 2 3 4) normindex=(10(10)80))
marginsplot, x(normindex)
gr save male_norm2.gph, replace

* FIgure to present in Paper *
gr combine male_norm2.gph female_norm2.gph
gr save normboth2.gph, replace




**************************
*** Robustness Checks ***
*************************

*** (0) First of all: Full Factorial of Interactions ***
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_cut_men 

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_right_men 

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_FF_Int.rtf", b(3)  not nogap mti replace lab



*** (1a) Country Fixed Effects and Excluding Certain Countries ***
** Country FE **
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls i.country || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls i.country || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_cut_men 

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls i.country || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls i.country || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_right_men 

esttab country_right_men country_cut_men country_right_women country_cut_women using "Robust_countryFE.rtf", b(3)  not nogap mti replace lab


** Exclude suspected countries **
* Exclude Germany *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=12
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=12
est sto country_cut_men 

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=12
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noGermany.rtf", b(3)  not nogap mti replace lab


* Exclude Austria *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=11
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=11
est sto country_cut_men 

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=11
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=11
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noAustria.rtf", b(3)  not nogap mti replace lab


* Exclude Netherlands *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14
est sto country_cut_men 

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noNL.rtf", b(3)  not nogap mti replace lab


* Exclude Switzerland *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=20
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=20
est sto country_cut_men 

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=20
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=20
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noCH.rtf", b(3)  not nogap mti replace lab


* Exclude Luxembourg *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=31
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=31
est sto country_cut_men 

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=31
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=31
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noLUX.rtf", b(3)  not nogap mti replace lab

* Exclude Denmark *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=19
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=19
est sto country_cut_men

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=19
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=19
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noDK.rtf", b(3)  not nogap mti replace lab

* Exclude Belgium *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=23
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=23
est sto country_cut_men

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=23
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=23
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noBE.rtf", b(3)  not nogap mti replace lab


* Exclude DACH *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=12&country!=20&country!=11
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=12&country!=20&country!=11
est sto country_cut_men

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=12&country!=20&country!=11
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=12&country!=20&country!=11
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noDACH.rtf", b(3)  not nogap mti replace lab


* Exclude BeNeLuxDk *
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14&country!=23&country!=31&country!=18
est sto country_cut_women

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14&country!=23&country!=31&country!=18
est sto country_cut_men

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14&country!=23&country!=31&country!=18
est sto country_right_women

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=14&country!=23&country!=31&country!=18
est sto country_right_men

esttab country_right_men country_cut_men country_right_women country_cut_women using "RObust_noBENELUXDK.rtf", b(3)  not nogap mti replace lab


*** (1b) By countries ***
log using bycountry.smcl, replace

bysort country: mixed  z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=30&country!=32

bysort country: mixed  z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss==1&nomiss_macros==1&rs_miss_filt==0&eurod<5&country!=30&country!=32

log close


** Notes **
* Germany, Austria and Switzerland drive the part-time effect for women (the opposite effect is found for PL and EE) *

* Germany, Austria and Switzerland drive the part-time effect for men; Denamrk has the opposite effect *



*** (2) Estimate the same models as in the Paper, but stratified by education ***
** Two - Level Models **
* Low *
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&edu_cat==1&rs_miss_filt==0&eurod<5
est sto p12right
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&edu_cat==1&rs_miss_filt==0&eurod<5
est sto p12female_right
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&edu_cat==1&rs_miss_filt==0&eurod<5
est sto p12female_cut
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&edu_cat==1&rs_miss_filt==0&eurod<5
est sto p12male_cut

* Medium *
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&edu_cat==2&rs_miss_filt==0&eurod<5
est sto p13right
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&edu_cat==2&rs_miss_filt==0&eurod<5
est sto p13female_right
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&edu_cat==2&rs_miss_filt==0&eurod<5
est sto p13female_cut
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&edu_cat==2&rs_miss_filt==0&eurod<5
est sto p13male_cut

* High *
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&edu_cat==3&rs_miss_filt==0&eurod<5
est sto p14right
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&edu_cat==3&rs_miss_filt==0&eurod<5
est sto p14female_right
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&edu_cat==3&rs_miss_filt==0&eurod<5
est sto p14female_cut
mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&edu_cat==3&rs_miss_filt==0&eurod<5
est sto p14male_cut

esttab p12right p13right p14right p12male_cut p13male_cut p14male_cut using "Robustness ByEdu -Men.rtf", b(3) not nogap mti lab scalars (ICC) replace

esttab p12female_right p13female_right p14female_right p12female_cut p13female_cut p14female_cut using "Robustness ByEdu -Women.rtf", b(3) not nogap mti lab scalars (ICC) replace



*** (3) Models with Recall / Verbal Fluency instead of the Composite Score ***
* Only the absolute central models for the paper *

** Recall **
* Table 1 *
mixed z_recall time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto n11right

mixed z_recall time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto n11female_right

mixed z_recall time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time  if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto n11female_cut

mixed z_recall time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto n11male_cut

esttab n11right n11male_cut n11female_right n11female_cut using "RECALL Macros Interacted.rtf", b(3) not nogap mti lab replace scalar (icc)


** Verbal Fluency **
* Table 1 *
mixed z_verbflu time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto o11right

mixed z_verbflu time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rightjob_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto o11female_right

mixed z_verbflu time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto o11female_cut

mixed z_verbflu time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.cutdown_c##c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto o11male_cut

esttab o11right o11male_cut o11female_right o11female_cut using "VERBFLU Macros Interacted.rtf", b(3) not nogap mti lab replace scalar (icc)



*** (4) Other Interactions ***
** Norm Indicator with Time **
mixed z_cogscore c.normindex_c##c.time time_sq rs_pt rs_homemaking rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls gdp_percap_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5
estadd scalar ICC = `r(icc2)'
est sto q1_men

mixed z_cogscore c.normindex_c##c.time time_sq rs_pt rs_homemaking rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls gdp_percap_ctr || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto q1_women
* Women significant, overall steeper decline when norms are stronger *


** Interact Life Course with Cohort **
mixed z_cogscore c.normindex_c c.time time_sq ib1.sharecohort ib1.sharecohort##c.rs_pt ib1.sharecohort##c.rs_homemaking ib1.sharecohort##c.rs_unemployed c.rs_otherneu rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5
estadd scalar ICC = `r(icc2)'
est sto q2_men

mixed z_cogscore c.normindex_c c.time time_sq ib1.sharecohort ib1.sharecohort##c.rs_pt ib1.sharecohort##c.rs_homemaking ib1.sharecohort##c.rs_unemployed c.rs_otherneu  rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto q2_women
* No significant interaction whatsoever *

** Current with previous employment **
mixed z_cogscore c.normindex_c c.time time_sq ib1.sharecohort ib1.sharecohort ib1.empl4neu##c.rs_pt ib1.empl4neu##c.rs_homemaking ib1.empl4neu##c.rs_unemployed c.rs_otherneu rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5
estadd scalar ICC = `r(icc2)'
est sto q3_men

mixed z_cogscore c.normindex_c c.time time_sq ib1.sharecohort ib1.sharecohort ib1.empl4neu##c.rs_pt ib1.empl4neu##c.rs_homemaking ib1.empl4neu##c.rs_unemployed c.rs_otherneu  rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
estat icc
estadd scalar ICC = `r(icc2)'
est sto q3_women
* significant interaction for women and part-time *

esttab q2_men q2_women q1_men q1_women q3_men q3_women using "Robustness - Interactions.rtf", b(3) not nogap mti
'
est restore q3_women
margins, at (empl4neu=(1 2 3 4) rs_pt=(0(20)100))
marginsplot, x(rs_pt)



*** (5) Adjust DV for Norm Means ****
mixed cogscore_degroup time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto gdm_right

mixed cogscore_degroup time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto gdm_female_right

mixed cogscore_degroup time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time i if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto gdm_female_cut

mixed cogscore_degroup time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5
est sto gdm_male_cut

esttab gdm_right gdm_male_cut gdm_female_right gdm_female_cut using "Norm Score Adjusted.rtf", b(3) not nogap mti lab replace scalar (icc)
* Norm groups are by gender, country and cohort *



*** (6) Robust Standard Errors ***
mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5, robust cluster(country)
est sto men_right_rob

mixed z_cogscore time time_sq c.rightjob_c##c.rs_pt c.rightjob_c##c.rs_homemaking c.rightjob_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls  || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurod<5, robust cluster(country)
est sto women_right_rob

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==1&nomiss_macros==1&rs_miss_filt==0&eurodf<5, robust cluster(country)
est sto women_cut_rob

mixed z_cogscore time time_sq c.cutdown_c##c.rs_pt c.cutdown_c##c.rs_homemaking c.cutdown_c##c.rs_unemployed c.rs_otherneu ib1.sharecohort rs_withpartner rs_withchildren age_baseline agebase2 $controls || mergeid: time if agegr5075==1&cogfilt_conservative==1&female==0&nomiss_macros==1&rs_miss_filt==0&eurod<5, robust cluster(country)
est sto men_cut_rob

esttab men_right_rob men_cut_rob women_right_rob women_cut_rob using "Robust SE.rtf", b(3) not nogap mti lab replace 
* Norm groups are by gender, country and cohort *


/*
* Clean File after Use *
drop _est*
save, replace
*/