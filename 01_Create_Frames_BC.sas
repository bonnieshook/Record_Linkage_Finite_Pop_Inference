/*************************************************************************/
/* Program: 01_Create_Frames_BC.sas 
/* Creation Date: May 20, 2021
/* Project: JRSS-A Simulation Study
/* Purpose: Create the sampling frames for the simulaton study where both models are correctly specified.
/* Author:  Bonnie Shook-Sa
/* Outputs: d01_sim_frame_100_BC.sas7bdat,d01_sim_frame_200_BC.sas7bdat,d01_sim_frame_500_BC.sas7bdat
/*************************************************************************/
options nofmterr;
libname adata "<path>";

****** Generate a mock HIV defendant variable;
data dat;
 set adata.simdata;
 num_hiv_def=round((county_pop_2016*0.0009+10*RANNOR(053122)),1);
 keep idnum num_hiv_def sqrt_pov SQRT_icr urbannumcol County_Prev_2016;
run;

****** Create frames for N=100, N=200, and N=500 with P_I and P_R for 3 response scenarios;
data mockdata_N100;
 set dat;

 *Set each countys probability of inmate|defendant based on covariates L;
 P_I=0.22-0.03*urbannumcol+0.02*SQRT_icr-.02*sqrt_pov+0.015*RANNOR(032419);

 *Set each countys probability of selection;
 logitP_R_25=-0.76-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_25=(exp(logitP_R_25))/(1+exp(logitP_R_25));

 logitP_R_50=0.34-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_50=(exp(logitP_R_50))/(1+exp(logitP_R_50));

 logitP_R_75=1.44-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_75=(exp(logitP_R_75))/(1+exp(logitP_R_75));

 keep idnum num_hiv_def sqrt_pov SQRT_icr urbannumcol P_I P_R_25 P_R_50 P_R_75;

run;

title2 "N=100 Frame Summary";
proc means data=mockdata_N100 min p25 median p75 max mean; var P_I P_R_25 P_R_50 P_R_75; run;
title2 "";

*** export N=100 frame;
proc sort data=mockdata_N100 out=adata.d01_sim_frame_100_BC; by idnum; run;

*** replicate for N=200 frame;
data mockdata_N200_hold;
 set mockdata_N100(drop=P_I P_R_25 P_R_50 P_R_75);
 output;
 sqrt_pov=max(0,sqrt_pov+1*RANNOR(090719)) ;
 SQRT_ICR=max(0,SQRT_ICR+0.75*RANNOR(090720));
 num_hiv_def=max(0,num_hiv_def+25*RANNOR(090721));
 output;
run;

data mockdata_N200;
 set mockdata_N200_hold;

 *Set each countys probability of inmate|defendant based on covariates L;
 P_I=0.22-0.03*urbannumcol+0.02*SQRT_icr-.02*sqrt_pov+0.015*RANNOR(032419);

 *Set each countys probability of selection;
 logitP_R_25=-0.76-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_25=(exp(logitP_R_25))/(1+exp(logitP_R_25));

 logitP_R_50=0.34-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_50=(exp(logitP_R_50))/(1+exp(logitP_R_50));

 logitP_R_75=1.44-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_75=(exp(logitP_R_75))/(1+exp(logitP_R_75));

 keep idnum num_hiv_def sqrt_pov SQRT_icr urbannumcol P_I P_R_25 P_R_50 P_R_75;

run;

title2 "N=200 Frame Summary";
proc means data=mockdata_N200 min p25 median p75 max mean; var P_I P_R_25 P_R_50 P_R_75; run;
title2 "";

*** export N=200 frame;
proc sort data=mockdata_N200 out=adata.d01_sim_frame_200_BC; by idnum; run;


*** replicate for N=500 frame;
data mockdata_N500_hold;
 set mockdata_N100(drop=P_I P_R_25 P_R_50 P_R_75);
 output;
 sqrt_pov=max(0,sqrt_pov+1*RANNOR(090719)) ;
 SQRT_ICR=max(0,SQRT_ICR+0.75*RANNOR(090720));
 num_hiv_def=max(0,num_hiv_def+25*RANNOR(090721));
 output;
 sqrt_pov=max(0,sqrt_pov+1*RANNOR(090819)) ;
 SQRT_ICR=max(0,SQRT_ICR+0.75*RANNOR(090820));
 num_hiv_def=max(0,num_hiv_def+25*RANNOR(090821));
 output;
 sqrt_pov=max(0,sqrt_pov+1*RANNOR(090919)) ;
 SQRT_ICR=max(0,SQRT_ICR+0.75*RANNOR(090920));
 num_hiv_def=max(0,num_hiv_def+25*RANNOR(090821));
 output;
 sqrt_pov=max(0,sqrt_pov+1*RANNOR(091019)) ;
 SQRT_ICR=max(0,SQRT_ICR+0.75*RANNOR(091020));
 num_hiv_def=max(0,num_hiv_def+25*RANNOR(090821));
 output;
run;

data mockdata_N500;
 set mockdata_N500_hold;

 *Set each countys probability of inmate|defendant based on covariates L;
 P_I=0.22-0.03*urbannumcol+0.02*SQRT_icr-.02*sqrt_pov+0.015*RANNOR(032419);

 *Set each countys probability of selection;
 logitP_R_25=-0.76-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_25=(exp(logitP_R_25))/(1+exp(logitP_R_25));

 logitP_R_50=0.34-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_50=(exp(logitP_R_50))/(1+exp(logitP_R_50));

 logitP_R_75=1.44-.15*urbannumcol-.1*sqrt_pov+0.1*SQRT_icr;
 P_R_75=(exp(logitP_R_75))/(1+exp(logitP_R_75));

 keep idnum num_hiv_def sqrt_pov SQRT_icr urbannumcol P_I P_R_25 P_R_50 P_R_75;

run;

title2 "N=500 Frame Summary";
proc means data=mockdata_N500 min p25 median p75 max mean; var P_I P_R_25 P_R_50 P_R_75; run;
title2 "";

*** export N=500 frame;
proc sort data=mockdata_N500 out=adata.d01_sim_frame_500_BC; by idnum; run;





