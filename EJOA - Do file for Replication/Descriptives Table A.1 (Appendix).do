*** Descriptives for Appendix ***

sum cogscore if agegr5075==1&filter==1&count==1
sum cogscore if agegr5075==1&filter==1
sum cogscore if agegr5075==1&filter==1&female==0
sum cogscore if agegr5075==1&filter==1&female==1

sum count if agegr5075==1&filter==1
sum count if agegr5075==1&filter==1&female==0
sum count if agegr5075==1&filter==1&female==1

sum time if agegr5075==1&filter==1&count==1
sum time if agegr5075==1&filter==1
sum time if agegr5075==1&filter==1&female==0
sum time if agegr5075==1&filter==1&female==1
sum time_sq if agegr5075==1&filter==1
sum time_sq if agegr5075==1&filter==1 &female==0
sum time_sq if agegr5075==1&filter==1 &female==1

sum age_base if agegr5075==1&filter==1
sum age_base if agegr5075==1&filter==1&count==1
sum age_base if agegr5075==1&filter==1
sum age_base if agegr5075==1&filter==1&female==0
sum age_base if agegr5075==1&filter==1&female==1
sum agebase2 if agegr5075==1&filter==1&female==1

sum rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu rs_withpartner rs_withchildren if agegr5075==1&filter==1&count==1
sum rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu rs_withpartner rs_withchildren if agegr5075==1&filter==1
sum rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu rs_withpartner rs_withchildren if agegr5075==1&filter==1&female==0
sum rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu rs_withpartner rs_withchildren if agegr5075==1&filter==1&female==1
sum rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu rs_withpartner rs_withchildren if agegr5075==1&filter==1&female==1&count==1
sum rs_ft rs_pt rs_homemaking rs_unemployed rs_otherneu rs_withpartner rs_withchildren if agegr5075==1&filter==1&female==0&count==1


*** From now save to log file ***
* Table A1 *
log using "table_a1.smcl"

* Baseline *
sum  functional_neu eurod i_nchild_neu i_ngrchild_neu given received vigorous_weekly moderate_weekly soc_act educ_act born_in_country if agegr5075==1&filter==1&count==1
ta empl4neu if agegr5075==1&filter==1&count==1
ta sectors_new if agegr5075==1&filter==1&count==1
ta civilneu2 if agegr5075==1&filter==1&count==1
ta edu_cat if agegr5075==1&filter==1&count==1
ta ends_neu if agegr5075==1&filter==1&count==1

* Total *
sum  functional_neu eurod i_nchild_neu i_ngrchild_neu given received vigorous_weekly moderate_weekly soc_act educ_act born_in_country if agegr5075==1&filter==1
ta empl4neu if agegr5075==1&filter==1
ta sectors_new if agegr5075==1&filter==1
ta civilneu2 if agegr5075==1&filter==1
ta edu_cat if agegr5075==1&filter==1
ta ends_neu if agegr5075==1&filter==1

* Men *
sum  functional_neu eurod i_nchild_neu i_ngrchild_neu given received vigorous_weekly moderate_weekly soc_act educ_act born_in_country if agegr5075==1&filter==1&female==0
ta empl4neu if agegr5075==1&filter==1&female==0
ta sectors_new if agegr5075==1&filter==1&female==0
ta civilneu2 if agegr5075==1&filter==1&female==0
ta edu_cat if agegr5075==1&filter==1&female==0
ta ends_neu if agegr5075==1&filter==1&female==0

* Women *
sum  functional_neu eurod i_nchild_neu i_ngrchild_neu given received vigorous_weekly moderate_weekly soc_act educ_act born_in_country if agegr5075==1&filter==1&female==1
ta empl4neu if agegr5075==1&filter==1&female==1
ta sectors_new if agegr5075==1&filter==1&female==1
ta civilneu2 if agegr5075==1&filter==1&female==1
ta edu_cat if agegr5075==1&filter==1&female==1
ta ends_neu 

log close

* Table A.3 *
log using "table_a3.smcl"

* Country-Level Case Numbers and Percentages *
ta country if agegr5075==1&filter==1

* Cognitive Score at Basline *
sort country
by country: sum cogscore if agegr5075==1&filter==1&count==1

* Average Cognitive Score (all observations) *
by country: sum cogscore if agegr5075==1&filter==1
log close 


* Mean Values (incl Standard Deviation), Minimum and Maximum of the Gender Norm Indicators) - by country *
"C:\Users\abertogg\Dropbox\Anja Ariane Partnership Cognitive Health\Paper II Gender and Cognitive Decline\DATA and DO FILES\data files\collapsed_scatterplot.dta" 
log using "table_a3_partb.smcl"
by country: sum rightjob cutdown normindex
log off