/*************************************************************************/
/* Program: 02b_Run_Sims_BC.sas 
/* Creation Date: May 20, 2021
/* Project: JRSS-A Simulation Study
/* Purpose: Simulation to Evaluate two estimators for the number of HIV+ inmates in NC.
/* Author:  Bonnie Shook-Sa
/*************************************************************************/

libname out "<path>";
options linesize=95 pagesize=60;
%let path=<path>;



**** N=100, n=25;
%let finpopsize=100;
%let smpsize=25;
%let resp=P_R_25;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=100 80 20 439.2213559 142.7180089;

%include "&path.\02a_Include_BC.sas";


**** N=100, n=50;
%let finpopsize=100;
%let smpsize=50;
%let resp=P_R_50;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=100 80 20 439.2213559 142.7180089;

%include "&path.\02a_Include_BC.sas";


**** N=100, n=75;
%let finpopsize=100;
%let smpsize=75;
%let resp=P_R_75;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=100 80 20 439.2213559 142.7180089;

%include "&path.\02a_Include_BC.sas";


**** N=200, n=50;
%let finpopsize=200;
%let smpsize=50;
%let resp=P_R_25;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=200 160 40 894.7328533 287.3756926;

%include "&path.\02a_Include_BC.sas";


**** N=200, n=100;
%let finpopsize=200;
%let smpsize=100;
%let resp=P_R_50;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=200 160 40 894.7328533 287.3756926;

%include "&path.\02a_Include_BC.sas";


**** N=200, n=150;
%let finpopsize=200;
%let smpsize=150;
%let resp=P_R_75;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=200 160 40 894.7328533 287.3756926;

%include "&path.\02a_Include_BC.sas";



**** N=500, n=125;

*** BC;
%let finpopsize=500;
%let smpsize=125;
%let resp=P_R_25;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=500 400 100 2316.85 783.2971675;

%include "&path.\02a_Include_BC.sas";


**** N=500, n=250;

*** BC;
%let finpopsize=500;
%let smpsize=250;
%let resp=P_R_50;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=500 400 100 2316.85 783.2971675;

%include "&path.\02a_Include_BC.sas";




**** N=500, n=375;

*** BC;
%let finpopsize=500;
%let smpsize=375;
%let resp=P_R_75;
%let out=P_I;
%let name=BC;
%let startseed=102420;

*** bring in the frame;
data mockdatab;
 set out.d01_sim_frame_&finpopsize._BC;

 NUM_HIV_INMATES=NUM_HIV_DEF*P_I;
 OBS_NUM_HIV_INMATES=NUM_HIV_INMATES;

 *Set each countys probability of selection;
 P_R=&resp.;
run;

*obtain control totals for poststratification;
proc means data=mockdatab sum; var sqrt_pov sqrt_ICR; run;
proc freq data=mockdatab; tables urbannumcol / list missing; run; 

%let ctrl_tot=500 400 100 2316.85 783.2971675;

%include "&path.\02a_Include_BC.sas";

