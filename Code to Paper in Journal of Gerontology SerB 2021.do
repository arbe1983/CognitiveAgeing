*************************
*** Codes for Article ***
*************************

* Bertogg, Ariane, and Leist, Anja. 2021. Partnership and Cognitive Aging in Europe: Mediating Factors and Social Stratification. Journal of Gerontology Series B. doi:10.1093/geronb/gbab020 *

* Code provided by Ariane Bertogg *
* Please cite the paper when using this code *



*************************
*** Data Availability ***
*************************
* Data availability: This paper uses publicly available data for research purposes from SHARE Waves 1, 2, 4, 5, 6 and the All Waves Coverscreen (DOI: 10.6103/SHARE.w1.700, 10.6103/ SHARE.w2.700, 10.6103/SHARE.w4.700, 10.6103/SHARE.w5.700, 10.6103/SHARE.w6.700, 10.6103/SHARE.wXcvr.700), see Börsch-Supan et al. for methodological details. The datasets analyzed during the current study are accessible through the SHARE Research Data Center, https://share-project.centerdata.nl/sharedatadissemination/users/login *



*****************
*** Variables ***
*****************

* z_memory_neu: z-standardized immediate recall of ten-word learning list (standardized at grand mean). Based on variable wllft *
* z_memory2_neu: z-standardized delayed recall of ten-word learning list (standarized at grand mean). Based on variabled wllst *
* z_verbflu_neu: z-standardized verbal fluency test (naming as many animals as possible within one minute). Based on variable cf010_ *

* age_int: from SHARE - not recoded *

* civilneu: civil / partnership status. Categorical, 5 groups: 1=married/cohabiting, 2=repartnered (living with a partner and being divorced/widowed) 3=never married (self reported, not living with a partner)  4=divorced or separated from partner (self-reported 5=widowed (self-reported). Based on variables dn014_ partnerinhh*

* dr: frequency of drinking. 1=less than once a month, 2=at most 2 times per week, 3=more than 2 times per week. Based on variables br039_ br040_ br623_ *

* vigorous_weekly: physical activity which is vigorous, at least weekly. Dichotomized. Based on variable br015_ *

* moderate weekly: physical activity which is moderate (walking, biking), at least weekly. Dichtomoized. Based on variable br016_*

* empl_small: Employment status. 1=employed, 2=retired, 3=economically inactive (including homemakers, unemployed, disabled). Based on variable ep005_ *

* soc_act: partipates in one of various social activities at least weekly (1=yes): club, association, religious community, political party. Dichotomized. Based on variables ac035d1 ac035d5 ac035d7 and ac036_1 ac036_5 ac026_7 *

* educ_act: participates in one of various educational activity at least weekly (1=yes): education / training activity, reading, quizzing. Dichotomized. Based on variables ac035d4 ac035d8 ac035d9 ac035d10 and ac036_4 ac036_8 ac036_9 ac036_10 *

* i_nchild: Number of children, generate and imputed variable as available in SHARE, not recoded *

* i_ngrchild: Number of grandchildren, generate and imputed variable as available in SHARE, not recoded *

* given: Has given help to others inside or outside household in the past 12 month, from SHARE generated variable data set. Dichotomized (1=at least one helpee). Based on variables sp008_ sp018_ *

* received: Has received help from others outside the household in the past 12 month. Dichotomized (1=at least one helper). Based on variables sp002_ sp020_ *

* lowic: Belongs to a low-income household 1=yes, 0=no. Defined as being in the bottom two quintiles of the respective country and wave specific distributino of the household's disposable income. Based on variable thinc from SHARE generated file with imputations *

* homeowner: Is homeowner (lives there or not). Dichotomized. Based on variables ho002_ *

* age_cat: recoded from age_int. 50-54 years, 55-59 years, 60-64 years, 65-69 years, 70-74 years, 75-74 years, 85plus *

* functional_neu: Number of functional and mobility limitations (sum). Based on variables adl and mobility from SHARE generated file *

* edu_small: Educational level low (ISCED 1/2), medium (ISEC 3/4) or high (ISCED 5/6). Based on variable isced1997_r *



*********************
*** Define Sample ***
*********************
*** Filter for Age and Missing Values (Listwise) ***
ge agegr50plus=0
replace agegr50plus=1 if age_int>49

ge filt_dv=0
replace filt_dv=. if z_memory_neu==.
replace filt_dv=. if z_memory2_neu==.
replace filt_dv=. if z_verbflu_neu==.

markout filter
mark ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat functional_neu ib1.count
ta filter


*** Exclude the cognitively impaired ***
* Create  filter variable first *
* Use diagnosis information *
ge alzheimer=ph006d16
ge parkinson=ph006d12
ge braincancer=ph008d1
replace braincancer=0 if braincancer==-1
replace braincancer=0 if braincancer==-2
replace braincancer=0 if braincancer==.
replace alzheimer=0 if alzheimer==-1
replace alzheimer=0 if alzheimer==-2
replace alzheimer=0 if alzheimer==.
replace parkinson=0 if parkinson==-1
replace parkinson=0 if parkinson==-2
replace parkinson=0 if parkinson==.

ge cogfilt_neu=1
replace cogfilt_neu=0 if alzheimer==1
replace cogfilt_neu=0 if braincancer==1

* Then replace all subsequent waves after a cognitive diagnosis *
ge cogfilt_conservative=cogfilt_neu
replace cogfilt_conservative=0 if l.cogfilt_conservative==0&cogfilt_conservative==1
replace cogfilt_conservative=0 if l2.cogfilt_conservative==0&cogfilt_conservative==1&l.cogfilt_conservative==.
replace cogfilt_conservative=0 if l3.cogfilt_conservative==0&cogfilt_conservative==1&l.cogfilt_conservative==.&l2.cogfilt_conservative==.



********************
*** Descriptives ***
********************
*** Describe Depvars ***
* (Both absolute values and changes since last wave) *
ge delta_men_neu= memory-l.memory
ge delta_mem2_neu=memory2-l.memory2 
ge delta_verbflu_neu=verbluf-l.verbflusum

* Mean over all person-years *
sum verbflu memory memory2 delta_mem_neu delta_mem2_neu delta_verbflu_neu if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1

* Mean at baseline *
sum memory memory2 verbflu if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&count==1


*** Create Table A1 for Appendix ***
** For Continuous Variables: Means **
* All Person-Year Observations *
sum memory1 memory2 verbflu delta_mem1_new delta_mem2_new delta_verbflu_new age_int i_nchildren i_ngrandchild functional_neu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1

bysort civilneu: sum memory1 memory2 verbflu delta_mem1_neu delta_mem2_neu delta_verbflu_neu age_int i_nchildren i_ngrandchild functional_neu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1

* At Baseline * 
sum memory1 memory2 verbflu delta_mem1_new delta_mem2_new delta_verbflu_new age_int i_nchildren i_ngrandchild functional_neu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1&count==1

bysort civilneu: sum memory1 memory2 verbflu delta_mem1_neu delta_mem2_neu delta_verbflu_neu age_int i_nchildren i_ngrandchild functional_neu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1&count==1


** Now for Categorical Variables: Percentages **
* Civil Status at Baseline * 
ta civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1&count==1, column

* Civil Status over all Person-Year Observation s*
ta civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1, column

* Other Categorical Vars *
* Over all person-year observations *
ta given civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta received civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta soc_act civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta educ_act civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta dr civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta vigorous_weekly civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta moderate_weekly civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta d_lowinc civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta lowinc civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta homeowner civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column
ta empl_small civilneu if obs>1&filt_dv==1&filter==1&cogfilt_conservative==1&agegr50plus==1,column


* Transition Rates by Starting Point *
* Measured at Baseline *
** Identify all transitions **
ge f_civilneu=f.civilneu
ge f2_civilneu=f2.civilneu
ge f3_civilneu=f3.civilneu
ge f4_civilneu=f4.civilneu
ge f5_civilneu=f5.civilneu

* Generate Categorical Variable (full details) *
ge transitions_detailed=0
replace transitions_detailed=1 if transitions_detailed==0&count==1&civilneu==1&(f_civilneu==1|f_civilneu==.)&(f2_civilneu==1|f2_civilneu==.)&(f3_civilneu==1|f3_civilneu==.)&(f4_civilneu==1|f4_civilneu==.)&(f5_civilneu==1|f5_civilneu==.)

replace transitions_detailed=2 if transitions_detailed==0&count==1&civilneu==2&(f_civilneu==2|f_civilneu==.)&(f2_civilneu==2|f2_civilneu==.)&(f3_civilneu==2|f3_civilneu==.)&(f4_civilneu==2|f4_civilneu==.)&(f5_civilneu==2|f5_civilneu==.)

replace transitions_detailed=3 if transitions_detailed==0&count==1&civilneu==1&(f_civilneu==2|f_civilneu==.)&(f2_civilneu==2|f2_civilneu==.)&(f3_civilneu==x|f3_civilneu==.)&(f4_civilneu==2|f4_civilneu==.)&(f5_civilneu==2|f5_civilneu==.)

replace transitions_detailed=4 if transitions_detailed==0&count==1&civilneu==2&(f_civilneu==1|f_civilneu==.)&(f2_civilneu==1|f2_civilneu==.)&(f3_civilneu==1|f3_civilneu==.)&(f4_civilneu==1|f4_civilneu==.)&(f5_civilneu==1|f5_civilneu==.)

replace transitions_detailed=5 if transitions_detailed==0&count==1&civilneu==4&(f_civilneu==4|f_civilneu==.)&(f2_civilneu==4|f2_civilneu==.)&(f3_civilneu==4|f3_civilneu==.)&(f4_civilneu==4|f4_civilneu==.)&(f5_civilneu==4|f5_civilneu==.)

replace transitions_detailed=6 if transitions_detailed==0&count==1&civilneu==4&(f_civilneu==1|f_civilneu==.)&(f2_civilneu==1|f2_civilneu==.)&(f3_civilneu==1|f3_civilneu==.)&(f4_civilneu==1|f4_civilneu==.)&(f5_civilneu==1|f5_civilneu==.)

replace transitions_detailed=6 if transitions_detailed==0&count==1&civilneu==4&(f_civilneu==4|f_civilneu==.)&(f2_civilneu==1|f2_civilneu==.)&(f3_civilneu==1|f3_civilneu==.)&(f4_civilneu==1|f4_civilneu==.)&(f5_civilneu==1|f5_civilneu==.)

replace transitions_detailed=6 if transitions_detailed==0&count==1&civilneu==4&(f_civilneu==4|f_civilneu==.)&(f2_civilneu==4|f2_civilneu==.)&(f3_civilneu==1|f3_civilneu==.)&(f4_civilneu==1|f4_civilneu==.)&(f5_civilneu==1|f5_civilneu==.)

replace transitions_detailed=6 if transitions_detailed==0&count==1&civilneu==4&(f_civilneu==4|f_civilneu==.)&(f2_civilneu==4|f2_civilneu==.)&(f3_civilneu==4|f3_civilneu==.)&(f4_civilneu==1|f4_civilneu==.)&(f5_civilneu==1|f5_civilneu==.)

replace transitions_detailed=7 if transitions_detailed==0&count==1&civilneu==4&(f_civilneu==5|f_civilneu==.)&(f2_civilneu==5|f2_civilneu==.)&(f3_civilneu==5|f3_civilneu==.)&(f4_civilneu==5|f4_civilneu==.)&(f5_civilneu==5|f5_civilneu==.)

replace transitions_detailed=8 if transitions_detailed==0&count==1&civilneu==4&(f_civilneu==6|f_civilneu==.)&(f2_civilneu==6|f2_civilneu==.)&(f3_civilneu==6|f3_civilneu==.)&(f4_civilneu==6|f4_civilneu==.)&(f5_civilneu==6|f5_civilneu==.)

replace transitions_detailed=9 if transitions_detailed==0&count==1&civilneu==5&(f_civilneu==2|f_civilneu==.)&(f2_civilneu==2|f2_civilneu==.)&(f3_civilneu==2|f3_civilneu==.)&(f4_civilneu==2|f4_civilneu==.)&(f5_civilneu==2|f5_civilneu==.)

replace transitions_detailed=11 if transitions_detailed==0&count==1&civilneu==5&(f_civilneu==5|f_civilneu==.)&(f2_civilneu==5|f2_civilneu==.)&(f3_civilneu==5|f3_civilneu==.)&(f4_civilneu==5|f4_civilneu==.)&(f5_civilneu==5|f5_civilneu==.)

replace transitions_detailed=12 if transitions_detailed==0&count==1&civilneu==5&(f_civilneu==6|f_civilneu==.)&(f2_civilneu==6|f2_civilneu==.)&(f3_civilneu==6|f3_civilneu==.)&(f4_civilneu==6|f4_civilneu==.)&(f5_civilneu==6|f5_civilneu==.)

replace transitions_detailed=13 if transitions_detailed==0&count==1&civilneu==6&(f_civilneu==6|f_civilneu==.)&(f2_civilneu==6|f2_civilneu==.)&(f3_civilneu==6|f3_civilneu==.)&(f4_civilneu==6|f4_civilneu==.)&(f5_civilneu==6|f5_civilneu==.)

replace transitions_detailed=14 if transitions_detailed==0&count==1&civilneu==6&(f_civilneu==2|f_civilneu==.)&(f2_civilneu==2|f2_civilneu==.)&(f3_civilneu==2|f3_civilneu==.)&(f4_civilneu==2|f4_civilneu==.)&(f5_civilneu==2|f5_civilneu==.)

replace transitions_detailed=16 if transitions_detailed==0&count==1&civilneu==x&(f_civilneu==x|f_civilneu==.)&(f2_civilneu==x|f2_civilneu==.)&(f3_civilneu==x|f3_civilneu==.)&(f4_civilneu==x|f4_civilneu==.)&(f5_civilneu==x|f5_civilneu==.)

replace transitions_detailed=17 if transitions_detailed==0&count==1&civilneu==1&(f_civilneu==5|f_civilneu==.)&(f2_civilneu==5|f2_civilneu==.)&(f3_civilneu==5|f3_civilneu==.)&(f4_civilneu==5|f4_civilneu==.)&(f5_civilneu==5|f5_civilneu==.)

replace transitions_detailed=18 if transitions_detailed==0&count==1&civilneu==1&(f_civilneu==6|f_civilneu==.)&(f2_civilneu==6|f2_civilneu==.)&(f3_civilneu==6|f3_civilneu==.)&(f4_civilneu==6|f4_civilneu==.)&(f5_civilneu==6|f5_civilneu==.)

lab var transitions_detailed "transitions since first observation"
lab define transitions_detailed 0"multiple transitions" 1"married->married" 2"repartnered->repartnered" 3"married->repartnered" 4"repartnered->married" 5"single->single" 6"single->married" 7"single->divorced" 8"single->widowed" 9"divorced->repartnered" 11"divorced->divorced" 12"divorced->widowed" 13"widowed->widowed" 14"widowed->repartnered" 16"widowed->divorced" 17"married->divorced" 18"married->widowed", replace
lab val transitions_detailed transitions_detailed

* Categorical Variable (4 Categories) *
ge ever_partners=0
ge ever_unpartners==0
ge ever_unpartners=0
ge remains_unpartnered=0
ge remains_partnered=0

replace remains_partnered=1 if transitions_detailed==1
replace remains_partnered=1 if transitions_detailed==2
replace remains_unpartnered=1 if transitions_detailed==5
replace remains_unpartnered=1 if transitions_detailed==9
replace remains_unpartnered=1 if transitions_detailed==13
replace ever_unpartners=1 if transitions_detailed==17
replace ever_unpartners=1 if transitions_detailed==18
replace ever_partners=1 if transitions_detailed==11
replace ever_partners=1 if transitions_detailed==14
replace ever_partners=1 if transitions_detailed==6
replace remains_partnered=1 if transitions_detailed==3
replace remains_partnered=1 if transitions_detailed==4
replace remains_unpartnered=1 if transitions_detailed==12
replace remains_unpartnered=1 if transitions_detailed==7
replace remains_unpartnered=1 if transitions_detailed==8
replace remains_unpartnered=1 if transitions_detailed==16

lab var remains_partnered "(person-stable)"
lab var remains_unpartnered "(person-stable)"
lab var ever_partners "(person-stable)"
lab var ever_unpartners "(person-stable)"


** Now calculate transition rates (unweighted) **
ta ever_partners civilneu if filter==1&filt_dv==1&obs>1&cogfilt_conservative==1&agegr50plus==1&count==1, column
ta ever_unpartners civilneu if filter==1&filt_dv==1&obs>1&cogfilt_conservative==1&agegr50plus==1&count==1, column
ta remains_partnered civilneu if filter==1&filt_dv==1&obs>1&cogfilt_conservative==1&agegr50plus==1&count==1, column
ta remains_unpartnered civilneu if filter==1&filt_dv==1&obs>1&cogfilt_conservative==1&agegr50plus==1&count==1, column


** Descriptive Figures **
graph hbar delta_mem_neu delta_mem2_neu delta_verbflu_neu if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1 [aweight=cciw], over (count)
gr save Fig2a.gph

graph hbar delta_mem_neu delta_mem2_neu delta_verbflu_neu if agegr50plus==1&obs>1&filter==1&filt_dv==1&cogfilt_conservative==1 [aweight=cciw], over (transitions_neu)
gr save Fig2b
gr combine Fig2a.gph Fig2b.gph

graph export Figure2neu.tif, width(10000)



***********************************
*** Main Models for Paper ***
***********************************
*** Table 1 (Full Sample) ***
* Run Raw and Full Models *
xtreg z_memory_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem1_raw_nofr

xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem1_fixed_nofr

xtreg z_memory2_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_raw_nofr

xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_fixed_nofr

xtreg z_verbflu_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_raw_nofr

xtreg z_verbflu_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_fixed_nofr


* Hausman Test: Fixed vs. Random Effects (Multilevel) Model *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, re
est sto zmem1_random_nofr
hausman zmem1_fixed_nofr zmem1_random_nofr

xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, re
est sto zmem2_random_nofr
hausman zmem2_fixed_nofr zmem2_random_nofr

xtreg z_verbflu_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, re
est sto zverbflu_random_nofr
hausman zverbflu_fixed_nofr zverbflu_random_nofr

* Create Table 1 for Paper *
esttab zmem1_raw_nofr zmem1_fixed_nofr zmem2_raw_nofr zmem2_fixed_nofr zmem2_fixed_nofr zverbflu_raw_nofr zverbflu_fixed_nofr  using "Table 1.rtf", b(3) se not nogap mti replace



*** Figure 3 for Paper ***
* (Stepwise Models) *
* Note: FUll Models in Appendix, run first *
coefplot zmem1_count zmem1_controls zmem1_ss zmem1_cs zmem_hb zmem1_ec zmem1_fixed, keep(*civilneu) xline(0) drop(_cons) base
gr save coefplot_zmem1.gph, replace

coefplot zmem2_count zmem2_controls zmem2_ss zmem2_cs zmem2_hb zmem2_ec zmem2_fixed, keep(*civilneu) xline(0) drop(_cons) base
gr save coefplot_zmem2.gph, replace

coefplot zverbflu_count zverbflu_controls zverbflu_ss zverbflu_cs zverbflu_hb zverbflu_ec zverbflu_fixed, keep(*civilneu) xline(0) drop(_cons) base
gr save coefplot_zverb.gph, replace

gr combine coefplot_zmem1.gph coefplot_zmem2.gph coefplot_zverb.gph
gr save Figure3neu.gph
gr save Figure3neu.tif, width(1000)



*** Table 2 (Stratified by Education) ***
** Lowest (ISCED 1 + 2) **
* Raw *
xtreg z_memory_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem1_count_low
xtreg z_memory2_neu ib1.civilneu  ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem2_count_low
xtreg z_verbflu_neu  ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zverbflu_count_low

* Full *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem1_fixed_low
xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem2_fixed_low
xtreg z_verbflu_neu  ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zverbflu_fixed_low


** Medium (ISCED 3 + 4) **
* Raw *
xtreg z_memory_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem1_count_medium
xtreg z_memory2_neu ib1.civilneu  ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem2_count_medium
xtreg z_verbflu_neu  ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zverbflu_count_medium

* Full *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem1_fixed_medium
xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem2_fixed_medium
xtreg z_verbflu_neu  ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zverbflu_fixed_medium


** Higher (ISCED 5 + 6) **
* Raw *
xtreg z_memory_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem1_count_high
xtreg z_memory2_neu ib1.civilneu  ib1.count if filter==1&agegr50plus==1&edu_small==3&filt_dv==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem2_count_high
xtreg z_verbflu_neu  ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zverbflu_count_high

* Full *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem1_fixed_high
xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem2_fixed_high
xtreg z_verbflu_neu  ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib1.empl_small soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zverbflu_fixed_high


** Put to tables **
* Note: Table were merged for paper, only displaying partnership effects *
esttab zmem1_count_low zmem1_fixed_low zmem2_count_low zmem2_fixed_low zverbflu_count_low zverbflu_fixed_low using "Table 2 low.rtf", compress star (* 0.05 ** 0.01 *** 0.001) b(3) se nogap not mti replace

esttab zmem1_count_medium zmem1_fixed_medium zmem2_count_medium zmem2_fixed_medium zverbflu_count_medium zverbflu_fixed_medium using "Table 2 medium.rtf", compress star (* 0.05 ** 0.01 *** 0.001) b(3) se nogap not mti replace

esttab zmem1_count_high zmem1_fixed_high zmem2_count_high zmem2_fixed_high zverbflu_count_high zverbflu_fixed_high using "Table 2 high.rtf", compress star (* 0.05 ** 0.01 *** 0.001) b(3) se nogap not mti replace



*********************************
*** Extra Tables for Appendix ***
*********************************
*** Table A.2: Stepwise Models (with Standard Errors) ***
** (For Models in Table 1) **
* "Gross" effect of partnership changes / No controls except observation fixed effects *
xtreg z_memory_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem1_count
xtreg z_memory2_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_count
xtreg z_verbflu_neu ib1.civilneu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_count

* Under control of only age, employment, physical health *
xtreg z_memory_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem1_controls
xtreg z_memory2_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_controls
xtreg z_verbflu_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_controls


** Include mediating mechanisms separately **
* Economic resources *
xtreg z_memory_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem1_ec
xtreg z_memory2_neu ib1.civilneu lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_ec
xtreg z_verbflu_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_ec

* Health behaviour *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem_hb
xtreg z_memory2_neu ib1.civilneu vigorous_weekly moderate_weekly ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_hb
xtreg z_verbflu_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_hb

* Social support *
xtreg z_memory_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem1_ss 
xtreg z_memory2_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_ss 
xtreg z_verbflu_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_ss 

* Cognitive Stimulation *
xtreg z_memory_neu ib1.civilneu soc_act educ_act ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem1_cs 
xtreg z_memory2_neu ib1.civilneu soc_act educ_act ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zmem2_cs 
xtreg z_verbflu_neu ib1.civilneu soc_act educ_act ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1, fe robust cluster(country)
est sto zverbflu_cs 

esttab zmem1_raw_nofr zmem1_controls zmem1_ss zmem1_cs zmem_hb zmem1_ec zmem1_fixed_nofr zmem2_raw_nofr zmem2_controls zmem2_ss zmem2_cs zmem2_hb zmem2_ec zmem2_fixed_nofr zverbflu_raw_nofr zverbflu_controls zverbflu_ss zverbflu_cs zverbflu_hb zverbflu_ec  zverbflu_fixed_nofr using "Table A2 Final.rtf", compress star (* 0.05 ** 0.01 *** 0.001) b(3) se nogap not mti replace



*** Table A.3: Stepwise Models by Education ***
** (Coefficients also Used for Table 2) **
* Low Education *
* Social Integration *
xtreg z_memory_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem1_ss_low
xtreg z_memory2_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received  ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem2_ss_low
xtreg z_verbflu_neu  ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zverbflu_ss_low

* Cognitive Stimulation *
xtreg z_memory_neu ib1.civilneu soc_act educ_act l ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem1_cs_low
xtreg z_memory2_neu ib1.civilneu soc_act educ_act ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem2_cs_low
xtreg z_verbflu_neu  ib1.civilneu soc_act educ_act iib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zverbflu_cs_low

* Health Behaviour *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem1_hb_low
xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem2_hb_low
xtreg z_verbflu_neu  ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zverbflu_hb_low

* Economic Resouces *
xtreg z_memory_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem1_ec_low
xtreg z_memory2_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem2_ec_low
xtreg z_verbflu_neu  ib1.civilneu lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zverbflu_ec_low

* Controls *
xtreg z_memory_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem1_controls_low
xtreg z_memory2_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zmem2_controls_low
xtreg z_verbflu_neu  ib1.civilneu ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==1, fe robust cluster(country)
est sto zverbflu_controls_low


** Medium Education (ISCED 3 + 4) **
* Social Integration *
xtreg z_memory_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem1_ss_medium
xtreg z_memory2_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received  ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem2_ss_medium
xtreg z_verbflu_neu  ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zverbflu_ss_medium

* Cognitive Stimulation *
xtreg z_memory_neu ib1.civilneu soc_act educ_act l ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem1_cs_medium
xtreg z_memory2_neu ib1.civilneu soc_act educ_act ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem2_cs_medium
xtreg z_verbflu_neu  ib1.civilneu soc_act educ_act iib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zverbflu_cs_medium

* Health Behaviour *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem1_hb_medium
xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem2_hb_medium
xtreg z_verbflu_neu  ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zverbflu_hb_medium

* Economic Resouces *
xtreg z_memory_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem1_ec_medium
xtreg z_memory2_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem2_ec_medium
xtreg z_verbflu_neu  ib1.civilneu lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zverbflu_ec_medium

* Controls *
xtreg z_memory_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem1_controls_medium
xtreg z_memory2_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2, fe robust cluster(country)
est sto zmem2_controls_medium
xtreg z_verbflu_neu  ib1.civilneu ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==2 fe robust cluster(country)
est sto zverbflu_controls_medium


** Higher Education (ISCED 5 + 6) **
* Social Integration *
xtreg z_memory_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem1_ss_high
xtreg z_memory2_neu ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received  ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem2_ss_high
xtreg z_verbflu_neu  ib1.civilneu i_nchild_1 i_ngrchild_1 i_given received ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zverbflu_ss_high

* Cognitive Stimulation *
xtreg z_memory_neu ib1.civilneu soc_act educ_act l ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem1_cs_high
xtreg z_memory2_neu ib1.civilneu soc_act educ_act ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem2_cs_high
xtreg z_verbflu_neu  ib1.civilneu soc_act educ_act iib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zverbflu_cs_high

* Health Behaviour *
xtreg z_memory_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem1_hb_high
xtreg z_memory2_neu ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem2_hb_high
xtreg z_verbflu_neu  ib1.civilneu ib0.dr vigorous_weekly moderate_weekly  ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zverbflu_hb_high

* Economic Resouces *
xtreg z_memory_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem1_ec_high
xtreg z_memory2_neu ib1.civilneu lowinc homeowner ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem2_ec_high
xtreg z_verbflu_neu  ib1.civilneu lowinc homeowner ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zverbflu_ec_high

* Controls *
xtreg z_memory_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem1_controls_high
xtreg z_memory2_neu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zmem2_controls_high
xtreg z_verbflu_neu  ib1.civilneu ib2.age_cat  ib1.empl_small functional_neu ib1.count if agegr50plus==1&filter==1&filt_dv==1&cogfilt_conservative==1&obs>1&edu_small==3, fe robust cluster(country)
est sto zverbflu_controls_high


** Put to tables **
esttab zmem1_count_low zmem1_ss_low zmem1_cs_low zmem1_hb_low zmem1_ec_low zmem1_fixed_low zmem2_count_low zmem2_ss_low zmem2_cs_low zmem2_hb_low zmem2_ec_low zmem2_fixed_low zverbflu_count_low zverbflu_ss_low zverbflu_cs_low zverbflu_hb_low zverbflu_ec_low zverbflu_fixed_low  using "Table A3 Low Final.rtf", compress star (* 0.05 ** 0.01 *** 0.001) b(3) se nogap not mti repla

esttab zmem1_count_medium zmem1_ss_medium zmem1_cs_medium zmem1_hb_medium zmem1_ec_medium zmem1_fixed_medium zmem2_count_medium zmem2_ss_medium zmem2_cs_medium zmem2_hb_medium zmem2_ec_medium zmem2_fixed_medium zverbflu_count_medium zverbflu_ss_medium zverbflu_cs_medium zverbflu_hb_medium zverbflu_ec_medium zverbflu_fixed_medium using "Table A3 Medium Final.rtf", compress star (* 0.05 ** 0.01 *** 0.001) b(3) se nogap not mti repla

esttab zmem1_count_high zmem1_ss_high zmem1_cs_high zmem1_hb_high zmem1_ec_high zmem1_fixed_high zmem2_count_high zmem2_ss_high zmem2_cs_high zmem2_hb_high zmem2_ec_high zmem2_fixed_high zverbflu_count_high zverbflu_ss_high zverbflu_cs_high zverbflu_hb_high zverbflu_ec_high zverbflu_fixed_high using "Table A3 High Final.rtf", compress star (* 0.05 ** 0.01 *** 0.001) b(3) se nogap not mti replace



*** Table A.4: Exclude Non-Changers ***
* Identify respondents with stable partnership trajectories (no change whatsoever) *
ge nochanger=0
replace nochanger=1 if transitions_detailed==1
replace nochanger=1 if transitions_detailed==2
replace nochanger=1 if transitions_detailed==5
replace nochanger=1 if transitions_detailed==9
replace nochanger=1 if transitions_detailed==13

*** Model: Bivariate, Time, Controls, Full ***
* Bivariate *
xtreg z_memory ib1.civilneu if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem1_bi_onlychanger
xtreg z_memory2 ib1.civilneu if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem2_bi_onlychange
xtreg z_verbflu ib1.civilneu if filter==1&agegr50plus==1&nochanger==0., fe robust cluster(country)
est sto zverbflu_bi_onlychange

* Control for time-trend *
xtreg z_memory ib1.civilneu ib1.count if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem1_raw_onlychanger
xtreg z_memory2 ib1.civilneu ib1.count if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem2_raw_onlychange
xtreg z_verbflu ib1.civilneu ib1.count if filter==1&agegr50plus==1&nochanger==0., fe robust cluster(country)
est sto zverbflu_raw_onlychange

* Add controls *
xtreg z_memory ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem1_controls_onlychanger
xtreg z_memory2 ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem2_controls_onlychange
xtreg z_verbflu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib1.count if filter==1&agegr50plus==1&nochanger==0., fe robust cluster(country)
est sto zverbflu_controls_onlychange

* Full *
xtreg z_memory ib1.civilneu ib2.age_cat ib1.empl_small functional_neu ib0.dr vigorous_weekly moderate_weekly soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib1.count if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem1_fixed_onlychanger
xtreg z_memory2 ib1.civilneu ib2.age_cat ib1.empl_small functional_neu functional_neu ib0.dr vigorous_weekly moderate_weekly soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib1.count ib1.count if filter==1&agegr50plus==1&nochanger==0, fe robust cluster(country)
est sto zmem2_fixed_onlychange
xtreg z_verbflu ib1.civilneu ib2.age_cat ib1.empl_small functional_neu functional_neu ib0.dr vigorous_weekly moderate_weekly soc_act educ_act i_nchild_1 i_ngrchild_1 i_given received lowinc homeowner ib1.count ib1.count if filter==1&agegr50plus==1&nochanger==0., fe robust cluster(country)
est sto zverbflu_fixed_onlychange

esttab zmem1_bi_onlychanger zmem1_raw_onlychanger zmem1_controls_onlychanger zmem1_fixed_onlychanger zmem2_bi_onlychange zmem2_raw_onlychange zmem2_controls_onlychange zmem2_fixed_onlychange zverbflu_bi_onlychange zverbflu_raw_onlychange zverb_controls_onlychange zverbflu_fixed_onlychange using "Table A.4.rtf", b(3) not nogap mti replace

