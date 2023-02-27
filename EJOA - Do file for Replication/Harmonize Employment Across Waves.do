use "C:\Users\abertogg\Desktop\DATA in use\SHARE\sharew8_rel1-0-0_ALL_datasets_stata\sharew8_rel1-0-0_ep.dta" 
ta ep125_
ta ep010_
ge jobsince=2020-ep010_
ta jobsince
replace jobsince=. if ep010_==.
ta ep010_
ta ep010_, nol
replace jobsince=. if ep010_==-1
replace jobsince=. if ep010_==-2
ta jobsince
hist jobsince
save, replace
ta ep018_
ta ep018_, nol
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sectors)
lab define sectors 1"agriculture" 2"industry" 3"service - low skill" 4"service - high skill"
lab val sector sector
ta ep030_
recode ep030_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_stim)
ta ep029_
recode ep029_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_agency)
ta ep954_
ta ep054_
ta ep018_
ta ep054_
recode ep054_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_last)
ta sectros
ta sectors
lab val sector sector
lab val sectors sector
lab val sectorlast sector
lab val sector_last sector
replace sectors=sector_last if sectors==.
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_now)
lab val sector_now sector
ta ep002_
ge d_work=0
replace d_work=1 if ep002_==1
ta sector_now d_work, m
ren d_work work_now
ta ep005_
ta ep005_, nol
replace ep005=.a if ep005==-1
replace ep005=.b if ep005==-2
ta ep013_
replace ep013=.a if ep013==-1
replace ep013=.b if ep013==-2
ren ep013 real_hours
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70
drop real_hours_cap
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70&real_hours_cap!=.
ge parttime=0
replace parttime=1 if real_hours_cap<36
replace parttime=. if real_hours_cap==.
save, replace
ta ep009_
replace ep009=.a if ep009==-1
replace ep009=.b if ep009==-2
ren ep009_ pubpriv
save, replace
save ep8.dta
sort mergeid
ge wave=8
keep mergeid country exrate ep005_ ep010_ real_hours ep616isco ep811_ jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave
ta ep61isco
ta ep61isco
ta ep616isco
ren ep616isco isco
ta ep005_
ren ep005_ empl_stat
recode empl_stat (1=3) (2=1) (3 4 5 97=4), ge(empl4)
replace empl4=2 if empl_stat==1&partime==1
replace empl4=2 if empl_stat==1&parttime==1
ta empl4
ta empl, m
ta empl4, m
ta empl_stat, m
ta real_hours_ca pif empl_stat==.
ta real_hours_ca if empl_stat==.
ta real_hours if empl_stat==.
ta work_how if empl_stat==
ta work_how if empl_stat==.
ta work_now if empl_stat==.
replace empl_stat=4 if empl_stat==.&work_now==0
save, replace
ta empl_stat
replace empl_stat=97 if empl_stat==4&empl_stat4==.&work_now==0
replace empl_stat=97 if empl_stat==4&empl4==.&work_now==0
replace empl4=4 if empl4==.&work_now==0
save, replace
ren * *_8
ren mergeid_8 mergeid
ren *__* *_*
save, replace
drop empl_stat_8 
use ep8
clear
use ep8
drop ep811_8 
clear
use ep9
use ep8
drop ep010_8 
save, replace
clear
use "C:\Users\abertogg\Desktop\DATA in use\SHARE\SHARE zipped Original\sharew7_rel7-1-1_ALL_datasets_stata\sharew7_rel7-1-1_ep.dta"
ge jobsince=2017-ep010_
replace jobsince=. if ep010_==.
ta jobsince
ta ep010_
ta jobsince
replace jobsince=. if ep010_==-1
ta ep018_
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sectors)
lab define sectors 1"agriculture" 2"industry" 3"service - low skill" 4"service - high skill"
lab val sectors sector
ta ep030_
recode ep030_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_stim)
recode ep029_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_agency)
ta ep054_
recode ep054_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_last)
lab val sector_last sector
replace sectors=sector_last if sectors==.
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_now)
lab val sector_now sector
ge d_work=0
replace d_work=1 if ep002_==1
ren d_work work_now
save, replace
ta ep005_
ta ep005_
replace ep005=.a if ep005==-1
replace ep005=.b if ep005==-2
ta ep013_
ta ep013_
replace ep013=.a if ep013==-1
replace ep013=.b if ep013==-2
ren ep013 real_hours
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70&real_hours_cap!=.
ge parttime=0
replace parttime=1 if real_hours_cap<36
replace parttime=. if real_hours_cap==.
ta ep009_
replace ep009=.a if ep009==-1
replace ep009=.b if ep009==-2
ren ep009_ pubpriv
save ep7.dta
sort mergeid
ge wave=7
keep mergeid country exrate ep005_ ep010_ real_hours ep616isco ep811_ jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave
keep mergeid country exrate ep005_ ep010_ real_hours ep616isco jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave
drop ep010_
ren ep616isco isco
ren ep005_ empl_stat
recode empl_stat (1=3) (2=1) (3 4 5 97=4), ge(empl4)
replace empl4=2 if empl_stat==1&parttime==1
replace empl_stat=4 if empl_stat==.&work_now==0
replace empl_stat=97 if empl_stat==4&empl4==.&work_now==0
replace empl4=4 if empl4==.&work_now==0
save, replace
ren * *_7
ren mergeid_7 mergeid
ren *__* *_*
save, replace
clear
use "C:\Users\abertogg\Desktop\DATA in use\SHARE\SHARE zipped Original\sharew6_rel7-1-1_ALL_datasets_stata\sharew6_rel7-1-1_ep.dta"
use "C:\Users\abertogg\Desktop\DATA in use\SHARE\SHARE zipped Original\sharew6_rel7-0-0_ALL_datasets_stata\sharew6_rel7-0-0_ep.dta"
ge jobsince=2015-ep010_
replace jobsince=. if ep010_==.
ta ep010_
ta jobsince
replace jobsince=. if ep010_==-1
replace jobsince=. if ep010_==-2
ta ep018_
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sectors)
lab define sectors 1"agriculture" 2"industry" 3"service - low skill" 4"service - high skill"
lab val sectors sector
ta ep030_
recode ep030_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_stim)
recode ep029_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_agency)
ta ep054_
recode ep054_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_last)
lab val sector_last sector
replace sectors=sector_last if sectors==.
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_now)
lab val sector_now sector
ge d_work=0
replace d_work=1 if ep002_==1
ren d_work work_now
save, replace
ta ep005_
ta ep005_
replace ep005=.a if ep005==-1
replace ep005=.b if ep005==-2
ta ep013_
ta ep013_
replace ep013=.a if ep013==-1
replace ep013=.b if ep013==-2
ren ep013 real_hours
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70&real_hours_cap!=.
ge parttime=0
replace parttime=1 if real_hours_cap<36
replace parttime=. if real_hours_cap==.
ta ep009_
replace ep009=.a if ep009==-1
replace ep009=.b if ep009==-2
ren ep009_ pubpriv
save ep6.dta
save ep7.dta
sort mergeid
ge wave=6
keep mergeid country exrate ep005_ ep010_ real_hours ep616isco jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave ep011_
drop ep010_
ren ep616isco isco
ren ep005_ empl_stat
recode empl_stat (1=3) (2=1) (3 4 5 97=4), ge(empl4)
replace empl4=2 if empl_stat==1&parttime==1
replace empl_stat=4 if empl_stat==.&work_now==0
replace empl_stat=97 if empl_stat==4&empl4==.&work_now==0
replace empl4=4 if empl4==.&work_now==0
save, replace
ren * *_6
ren mergeid_6 mergeid
save, replace
ren *__* *_*
save, replace
clear
use "C:\Users\abertogg\Desktop\DATA in use\SHARE\SHARE zipped Original\sharew5_rel7-0-0_ALL_datasets_stata\sharew5_rel7-0-0_ep.dta"
ge jobsince=2013-ep010_
replace jobsince=. if ep010_==.
ta ep010_
ta jobsince
replace jobsince=. if ep010_==-1
replace jobsince=. if ep010_==-2
ta ep018_
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sectors)
lab define sectors 1"agriculture" 2"industry" 3"service - low skill" 4"service - high skill"
lab val sectors sector
ta ep030_
recode ep030_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_stim)
recode ep029_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_agency)
ta ep054_
recode ep054_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_last)
lab val sector_last sector
replace sectors=sector_last if sectors==.
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_now)
lab val sector_now sector
ge d_work=0
replace d_work=1 if ep002_==1
ren d_work work_now
save, replace
ta ep005_
ta ep005_
replace ep005=.a if ep005==-1
replace ep005=.b if ep005==-2
ta ep013_
ta ep013_
replace ep013=.a if ep013==-1
replace ep013=.b if ep013==-2
ren ep013 real_hours
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70&real_hours_cap!=.
ge parttime=0
replace parttime=1 if real_hours_cap<36
replace parttime=. if real_hours_cap==.
ta ep009_
replace ep009=.a if ep009==-1
replace ep009=.b if ep009==-2
ren ep009_ pubpriv
save ep5.dta
sort mergeid
ge wave=5+
ge wave=5
keep mergeid country exrate ep005_ ep010_ real_hours ep616isco jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave ep011_
lookfor isco
keep mergeid country exrate ep005_ ep010_ real_hours jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave ep011_
save, replace
ren * *_5
ren mergeid_5 mergeid
ren *__* *_*
save, replace
clear
use "C:\Users\abertogg\Desktop\DATA in use\SHARE\SHARE zipped Original\sharew4_rel7-0-0_ALL_datasets_stata\sharew4_rel7-0-0_ep.dta"
ge jobsince=201^-ep010_
replace jobsince=. if ep010_==.
replace jobsince=. if ep010_==-1
replace jobsince=. if ep010_==-2
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sectors)
lab define sectors 1"agriculture" 2"industry" 3"service - low skill" 4"service - high skill"
lab val sectors sector
ta ep030_
recode ep030_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_stim)
recode ep029_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_agency)
ta ep054_
recode ep054_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_last)
lab val sector_last sector
replace sectors=sector_last if sectors==.
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_now)
lab val sector_now sector
ge d_work=0
replace d_work=1 if ep002_==1
ren d_work work_now
save, replace
ta ep005_
ta ep005_
replace ep005=.a if ep005==-1
replace ep005=.b if ep005==-2
ta ep013_
ta ep013_
replace ep013=.a if ep013==-1
replace ep013=.b if ep013==-2
ren ep013 real_hours
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70&real_hours_cap!=.
ge parttime=0
replace parttime=1 if real_hours_cap<36
replace parttime=. if real_hours_cap==.
ta ep009_
replace ep009=.a if ep009==-1
replace ep009=.b if ep009==-2
ren ep009_ pubpriv
save ep4.dta
sort mergeid
ge wave=4
lookfor isco
keep mergeid country exrate ep005_ ep010_ real_hours jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave ep011_
save, replace
ren * *_4
ren mergeid_4 mergeid
ren *__* *_*
save, replace
clear
use "C:\Users\abertogg\Desktop\DATA in use\SHARE\SHARE zipped Original\sharew2_rel7-0-0_ALL_datasets_stata\sharew2_rel7-0-0_ep.dta"
ge jobsince=2006-ep010_
replace jobsince=. if ep010_==.
replace jobsince=. if ep010_==-1
replace jobsince=. if ep010_==-2
replace jobsince=. if ep010_==-1
replace jobsince=. if ep010_==-2
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sectors)
lab define sectors 1"agriculture" 2"industry" 3"service - low skill" 4"service - high skill"
lab val sectors sector
ta ep030_
recode ep030_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_stim)
recode ep029_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_agency)
ta ep054_
recode ep054_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_last)
lab val sector_last sector
replace sectors=sector_last if sectors==.
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sector_now)
lab val sector_now sector
ge d_work=0
replace d_work=1 if ep002_==1
ren d_work work_now
save, replace
ta ep005_
ta ep005_
replace ep005=.a if ep005==-1
replace ep005=.b if ep005==-2
ta ep013_
ta ep013_
replace ep013=.a if ep013==-1
replace ep013=.b if ep013==-2
ren ep013 real_hours
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70&real_hours_cap!=.
ge parttime=0
replace parttime=1 if real_hours_cap<36
replace parttime=. if real_hours_cap==.
ta ep009_
replace ep009=.a if ep009==-1
replace ep009=.b if ep009==-2
ren ep009_ pubpriv
save ep.dta
save ep2.dta
sort mergeid
ge wave=2
lookfor isco
keep mergeid country exrate ep005_ ep010_ real_hours jobsince sectors job_stim job_agency sector_last sector_now work_now real_hours_cap parttime wave ep011_
save, replace
ren * *_2
ren mergeid_2 mergeid
ren *__* *_*
save, replace
clear
use "C:\Users\abertogg\Desktop\DATA in use\SHARE\SHARE zipped Original\sharew1_rel7-0-0_ALL_datasets_stata\sharew1_rel7-0-0_ep.dta"
ge jobsince=2004-ep010_
ge jobsince=2004-ep010_1
replace jobsince=. if ep010_^1==.
replace jobsince=. if ep010_1==-1
replace jobsince=. if ep010_1==-2
recode ep018_ (-1 -2=.) (1 2=1) (3 4 5 6 =2) (7 8 14 =3) (9 10 11 12 13=4), ge(sectors)
ta ep019_1
recode ep019_1 (-1 -2 =.) (1=1) (5=0), ge (public)
lab define sectors 1"agriculture" 2"industry" 3"service - low skill" 4"service - high skill"
ta ep030_
recode ep030_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_stim)
recode ep029_ ( -1 -2=.) (1 2 =1) (3 4 =0), gen (job_agency)
ta ep054_
replace ep005=.a if ep005==-1
replace ep005=.b if ep005==-2
replace ep005_=.a if ep005_==-1
replace ep005_=.b if ep005_==-2
ge d_work=0
replace d_work=1 if ep002_==1
replace ep013_1=.a if ep013_1==-1
replace ep013_1=.b if ep013_1==-2
ren ep013_1 real_hours
ge real_hours_cap=real_hours
replace real_hours_cap=70 if real_hours_cap>70&real_hours_cap!=.
ge parttime=0
replace parttime=1 if real_hours_cap<36
replace parttime=. if real_hours_cap==.
ta ep009_
ta ep009_1
recode ep009_1 (-1 -2 =.) (1 2 =0) (3=1), ge(self_employed)
ta self_employed
ta ep019_
save ep^.dta
save ep1.dta
sort mergeid
ge wave=1
keep mergeid country exrate ep005_ ep010_1 real_hours jobsince job_stim job_agency  work_now real_hours_cap parttime wave ep011_1
ren d_work work_now
keep mergeid country exrate ep005_ ep010_1 real_hours jobsince job_stim job_agency  work_now real_hours_cap parttime wave ep011_1
ren * *_^1
ren * *_1
ren mergeid_1 mergeid
ren *__* *_*
save, replace
merge 1:1 mergeid using isco1
drop _merge
save, replace
use ep2
ta sectors_2, m
ta sectors_2 sector_last2, m
ta sectors_2 sector_last_2, m
ta sectors_2
ta sector_last_2
ta sector_now_2
save, replace
use ep1
append using ep2
append using ep4
append using ep5
append using ep6
append using ep7
append using eö8
append using ep8
duplicates report mergeid
clear
use ep1
merge 1:1 mergeid using ep2
drop _merge
merge 1:1 mergeid using ep4
drop _merge
merge 1:1 mergeid using ep5
drop _merge
merge 1:1 mergeid using ep6
drop _merge
merge 1:1 mergeid using ep7
drop _merge
merge 1:1 mergeid using ep8
duplicates report mergeid
save ep_wide
en ep010_1_1 ep010_1
ren ep010_1_1 ep010_1
ren ep011_1_1 ep011_1
drop _merge
save, replace
ta wave
ta wave_1
drop wave
reshape wide country exrate ep005_ ep010_ ep011_ real_hours_ jobsince job_stim_ job_agency_ job_now_ real_hours_cap_ parttime_ wave_ isco_ isco_last_  sector_last_ sector_now_ sectors_ work_how_ empl4_
reshape wide country exrate ep005_ ep010_ ep011_ real_hours_ jobsince job_stim_ job_agency_ job_now_ real_hours_cap_ parttime_ wave_ isco_ isco_last_  sector_last_ sector_now_ sectors_ work_how_ empl4_, i(mergeid) j(welle)
reshape long country exrate ep005_ ep010_ ep011_ real_hours_ jobsince job_stim_ job_agency_ job_now_ real_hours_cap_ parttime_ wave_ isco_ isco_last_  sector_last_ sector_now_ sectors_ work_how_ empl4_, i(mergeid) j(welle)
sum isco*
ta isco_6
destring isco_6
destring isco_6, replace
ta isco_1
destring isco_1, replace
ta isco_1
destring isco_last_1, replace
destring isco_2, replace
destring isco_4, replace
destring isco_5, replace
sum isc*
destring isco_7, replace
destring isco_8, replace
save, replace
sum isco*
sum sector*
