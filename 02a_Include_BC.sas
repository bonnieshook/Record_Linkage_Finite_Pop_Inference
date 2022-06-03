/*************************************************************************/
/* Program: 02a_Include_BC.sas 
/* Creation Date: May 20, 2021
/* Project: JRSS-A Simulation Study
/* Purpose: Simulation to Evaluate two estimators for the number of HIV+ inmates in NC.
/* Author:  Bonnie Shook-Sa
/*************************************************************************/

%macro SimBC(seed=);

data sim_results;
delete;
run;

%do iter=1 %to 2000;

%let seed=%eval(&seed.+1);

*Randomize response status, and remove data for non-selected counties;
data mockdata_iter&iter.;
 set mockdatab;
 call streaminit(&seed.);
 response= RAND('BERNOULLI',P_R); 
 if response=0 then do;
	P_I=.;
	OBS_NUM_HIV_INMATES=.;
	end;
run;

*create macro variables with sample sizes;
proc freq data=mockdata_iter&iter. noprint; tables response / list out=num_resp_&iter.; run;

data _null_;
 set num_resp_&iter.;
 if response=0 then CALL SYMPUTX('ns', count);
 else if response=1 then CALL SYMPUTX('n', count);
run;

**************************************************************************************;
*** METHOD 1: Calculate estimated probability of incarceration|defendent in responding counties,
              and apply model results to other nonresponding counties ;
**************************************************************************************;
proc reg data=mockdata_iter&iter. outest=varcov&iter. covout;
 model P_I=urbannumcol sqrt_pov sqrt_ICR;
 output out=predvalues_&iter. p=phat LCL=LCL_phat UCL=UCL_phat;
run;
quit;

*check PI coverage;
data predvalues_&iter.b;
 set predvalues_&iter.;
 EST_NUM_HIV_INMATES=num_hiv_def*phat;
 if LCL_phat*num_hiv_def LE NUM_HIV_INMATES and NUM_HIV_INMATES LE UCL_phat*num_hiv_def then PI_COV=1;
 else PI_COV=0;
*create variable for estimating the total;
 if response=1 then EST_INMATES=OBS_NUM_HIV_INMATES;
 else if response=0 then EST_INMATES=EST_NUM_HIV_INMATES;
 label phat="Predicted Probability of inmate|defendant";
run;

*Estimate the total number of HIV+ inmates and get num counties with PI coverage;
proc means data=predvalues_&iter.b noprint; var EST_INMATES; output out=Method1_est_&iter.(drop=_TYPE_ _FREQ_) sum=EST_NUM_HIV_INMATES_M1; run;
proc means data=predvalues_&iter.b noprint; where response=0; var PI_COV; output out=Method1_cov_&iter.(drop=_TYPE_ _FREQ_) sum=NUM_PI_COV_M1 n=DENOM_PI_COV; run;


*calculate the critical value for the t-distribution;
%let df=%SYSEVALF(&n-4); *df for the t-value are n-1-p = n-4;
data _NULL_;
t_stat=TINV(0.975,&df.);
CALL SYMPUTX('tcrit', t_stat);
run;

data varcovb&iter.;
 set varcov&iter.;
 if _type_="PARMS" then delete;
 drop _model_ _type_ _depvar_ P_I;
run;

data X_75&iter.;
 retain  intercept urbannumcol sqrt_pov sqrt_ICR;
 set predvalues_&iter.;
 if response=0;
 intercept=1;
 keep intercept urbannumcol sqrt_pov sqrt_ICR;
run;

data G&iter.;
 set predvalues_&iter.;
 if response=0;
 G=num_hiv_def;
 keep G;
run;

*Calculate 95% CI;
data MSE&iter.;
 set varcov&iter.;
 if _N_=1;
 MSE=_RMSE_*_RMSE_;
 keep MSE;
run;

data Var&iter.;
 set varcovb&iter.;
 keep Intercept--sqrt_ICR;
run;

proc iml;
varNames = {"Intercept" "urbannumcol" "sqrt_pov" "sqrt_ICR"};
use X_75&iter.; 
read all var varNames into X75;  

use Var&iter.; 
read all var varNames into VarBeta;  

varNames2 = {"MSE"};
use MSE&iter.; 
read all var varNames2 into MSE2;  

varNames3 = {"G"};
use G&iter.; 
read all var varNames3 into G2; 

varNames4 = {"EST_NUM_HIV_INMATES_M1"};
use Method1_est_&iter.; 
read all var varNames4 into NC_tot; 


sigmastar = X75 * VarBeta * X75` + MSE2 * I(&ns.);
StdErr = sqrt( G2` * sigmastar * G2 );
LL = NC_tot - &tcrit. * StdErr;
UL = NC_tot + &tcrit. * StdErr;


create Delta&iter. var {"NC_tot" "StdErr" "LL" "UL"};                    
append;                                          
close Delta&iter.;

quit;


**************************************************************************************;
*** METHOD 2: Use a calibration model to estimate the total number of HIV+ inmates 
              in NC;
**************************************************************************************;
%if (&iter=182 or &iter=877 or &iter=1418 or &iter=1667 or &iter=1789 or &iter=1856 or &iter=1923) and &finpopsize=100 and &smpsize=25 %then %do; 
data iter&iter.;
  merge Method1_est_&iter. Method1_cov_&iter. Delta&iter.;
 iter=&iter.;
 n=&n.;
 ns=&ns.;
run;

data sim_results;
 set sim_results iter&iter.;
run;
%end;


%else %do;

proc sort data=mockdata_iter&iter.; by idnum; run;

data mockdata_resp_iter&iter.;
 set mockdata_iter&iter.;
 if response=1;
run;

PROC WTADJUST DATA=mockdata_resp_iter&iter. DESIGN=WR ADJUST=POST noprint MAXITER=100 P_EPSILON=0.001;
 WEIGHT _one_;
 NEST _one_;
 CLASS urbannumcol;
 MODEL response= urbannumcol sqrt_pov sqrt_ICR;
 POSTWGT &ctrl_tot.;
 VAR OBS_NUM_HIV_INMATES;
 IDVAR idnum;
 LOWERBD 1;
 CENTER 2;
 OUTPUT / predicted=all filename=NR_WTS_&iter. filetype=sas replace;
 OUTPUT TOTAL SE_TOTAL LOW_TOTAL UP_TOTAL / filename=Method3_iter&iter. replace; 
run;

*Compile all sim-level data;
data iter&iter.;
 merge Method1_est_&iter. Method1_cov_&iter. Delta&iter.
        Method3_iter&iter.(where=(_C1=0) keep=_C1 total se_total low_total up_total rename=(total=M3_est_tot se_total=M3_est_se_tot low_total=M3_low_tot up_total=M3_up_tot));
 iter=&iter.;
 n=&n.;
 ns=&ns.;
 drop _C1;
run;

data sim_results;
 set sim_results iter&iter.;
run;

%end;

proc datasets library=work; save sim_results: mockdatab; run; quit;

%end;


*** Calculate Coverage and CI Half Width;
proc means data=mockdatab noprint; var NUM_HIV_INMATES; output out=true_tot(drop=_TYPE_ _FREQ_) sum=; run;

data sim_results_b;
 if _N_=1 then set true_tot;
 set sim_results;

 if LL LE NUM_HIV_INMATES and NUM_HIV_INMATES LE UL then M1_Cov=1;
 else M1_COV=0;

 if M3_low_tot LE NUM_HIV_INMATES and NUM_HIV_INMATES LE M3_up_tot then M3_Cov_nofpc=1;
 else M3_COV_nofpc=0;

 wc_df=n-1;
 t_stat_wc=TINV(0.975,wc_df);
 M3_est_se_tot_fpc=M3_est_se_tot*SQRT(1-n/&finpopsize.);
 M3_low_tot_fpc=M3_est_tot-t_stat_wc*M3_est_se_tot_fpc;
 M3_up_tot_fpc=M3_est_tot+t_stat_wc*M3_est_se_tot_fpc;

 if M3_low_tot_fpc LE NUM_HIV_INMATES and NUM_HIV_INMATES LE M3_up_tot_fpc then M3_Cov_fpc=1;
 else M3_COV_fpc=0;

 M1_Pct_Cts_Cov=Num_PI_Cov_M1/Denom_PI_Cov;

 CI_HW_M1=(UL-LL)/2;
 CI_HW_M3_nofpc=(M3_up_tot-M3_low_tot)/2;
 CI_HW_M3_fpc=(M3_up_tot_fpc-M3_low_tot_fpc)/2;

run;

*** Output Results;
proc sort data=sim_results_b out=out.d02_sim_summary_n_&smpsize._N&finpopsize._&name.; by iter; run;

%mend;

%SimBC(seed=&startseed.);

proc datasets library=work kill; run; quit;





