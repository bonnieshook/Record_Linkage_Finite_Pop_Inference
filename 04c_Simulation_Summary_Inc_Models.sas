/*************************************************************************/
/* Program: 04c_Simulation_Summary_Inc_Models.sas 
/* Creation Date: 24May2021
/* Purpose: Create tables with simulation summary results for incorrectly specified models.
/* Author:  Bonnie Shook-Sa
/*************************************************************************/

libname adata "<path>";


*** Bring in simulation summary data (Note: Method 1 = OR, Method 3 = WC), Calc emp bias, coverage, and CI half width for each method and sample size;
%macro readdat(smp,fpop,num,type);
*** Read in the data;
 data simsum_&smp._&fpop._&type;
  set adata.d&num._sim_summary_n_&smp._N&fpop._&type.; 
   /*correction for sims that did not converge*/
  if &smp.=25 and &fpop.=100 and "&type."in ("WI" "OI") and iter in (182 877 1418 1667 1789 1856 1923) then do; 
     M3_est_tot=.; M3_est_se_tot=.; M3_est_se_tot_fpc=.; M3_Cov_nofpc=.; M3_Cov_fpc=.; CI_HW_M3_nofpc=.; CI_HW_M3_fpc=.;
	 end;
  ebias_M1=NC_tot-NUM_HIV_INMATES;
  ebias_M3=M3_est_tot-NUM_HIV_INMATES;
  RSE_M1=100*StdErr/NC_tot;
  RSE_M3_nofpc=100*M3_est_se_tot/M3_est_tot;
  RSE_M3_fpc=100*M3_est_se_tot_fpc/M3_est_tot;
 

 run;

*** Calc bias and coverage;
 proc means data=simsum_&smp._&fpop._&type noprint; 
 var ebias_M1 NC_Tot M1_Cov CI_HW_M1 M1_Pct_Cts_Cov StdErr n RSE_M1; 
 output out=M1_summary_&smp._&fpop._&type.(drop=_TYPE_ _FREQ_) mean(ebias_M1)=ebias mean(NC_Tot)=est_tot mean(M1_Cov)=Cov mean(CI_HW_M1)=CI_HW
                                               mean(M1_Pct_Cts_Cov)=PI_COV mean(StdErr)=Avg_SE std(NC_Tot)=Emp_SE mean(n)=ss mean(RSE_M1)=mean_RSE; 
run;

proc means data=simsum_&smp._&fpop._&type noprint; 
 var ebias_M3 M3_est_tot M3_Cov_nofpc CI_HW_M3_nofpc M3_est_se_tot n RSE_M3_nofpc; 
 output out=M3nofpc_summary_&smp._&fpop._&type.(drop=_TYPE_ _FREQ_) mean(ebias_M3)=ebias mean(M3_est_tot)=est_tot mean(M3_Cov_nofpc)=Cov mean(CI_HW_M3_nofpc)=CI_HW
                                               mean(M3_est_se_tot)=Avg_SE std(M3_est_tot)=Emp_SE mean(n)=ss mean(RSE_M3_nofpc)=mean_RSE; 
run;

proc means data=simsum_&smp._&fpop._&type noprint; 
 var ebias_M3 M3_est_tot M3_Cov_fpc CI_HW_M3_fpc M3_est_se_tot_fpc n RSE_M3_fpc; 
 output out=M3fpc_summary_&smp._&fpop._&type.(drop=_TYPE_ _FREQ_) mean(ebias_M3)=ebias mean(M3_est_tot)=est_tot mean(M3_Cov_fpc)=Cov mean(CI_HW_M3_fpc)=CI_HW
                                               mean(M3_est_se_tot_fpc)=Avg_SE std(M3_est_tot)=Emp_SE mean(n)=ss mean(RSE_M3_fpc)=mean_RSE; 
run;


%mend;

*N=100;
%readdat(25,100,04,OI);
%readdat(25,100,04,WI);
%readdat(25,100,04,BI);

%readdat(50,100,04,OI);
%readdat(50,100,04,WI);
%readdat(50,100,04,BI);

%readdat(75,100,04,OI);
%readdat(75,100,04,WI);
%readdat(75,100,04,BI);

*N=200;
%readdat(50,200,04,OI);
%readdat(50,200,04,WI);
%readdat(50,200,04,BI);

%readdat(100,200,04,OI);
%readdat(100,200,04,WI);
%readdat(100,200,04,BI);

%readdat(150,200,04,OI);
%readdat(150,200,04,WI);
%readdat(150,200,04,BI);

*N=500;
%readdat(125,500,04,OI);
%readdat(125,500,04,WI);
%readdat(125,500,04,BI);

%readdat(250,500,04,OI);
%readdat(250,500,04,WI);
%readdat(250,500,04,BI);

%readdat(375,500,04,OI);
%readdat(375,500,04,WI);
%readdat(375,500,04,BI);

*** Format data for each specification of model;
%macro format_dat(spec);
data sim_table_&spec.;
 length Method $100. SPECIFICATION $2.;
 set M1_Summary_25_100_&spec.(in=a) 
     M3nofpc_summary_25_100_&spec.(in=b)
     M3fpc_summary_25_100_&spec.(in=c)
     M1_Summary_50_100_&spec.(in=d) 
     M3nofpc_summary_50_100_&spec.(in=e)
     M3fpc_summary_50_100_&spec.(in=f)
     M1_Summary_75_100_&spec.(in=g) 
     M3nofpc_summary_75_100_&spec.(in=h)
     M3fpc_summary_75_100_&spec.(in=i)

     M1_Summary_50_200_&spec.(in=j) 
     M3nofpc_summary_50_200_&spec.(in=k)
     M3fpc_summary_50_200_&spec.(in=l)
     M1_Summary_100_200_&spec.(in=m) 
     M3nofpc_summary_100_200_&spec.(in=n)
     M3fpc_summary_100_200_&spec.(in=o)
     M1_Summary_150_200_&spec.(in=p) 
     M3nofpc_summary_150_200_&spec.(in=q)
     M3fpc_summary_150_200_&spec.(in=r)

     M1_Summary_125_500_&spec.(in=s) 
     M3nofpc_summary_125_500_&spec.(in=t)
     M3fpc_summary_125_500_&spec.(in=u)
     M1_Summary_250_500_&spec.(in=v) 
     M3nofpc_summary_250_500_&spec.(in=w)
     M3fpc_summary_250_500_&spec.(in=x)
     M1_Summary_375_500_&spec.(in=y) 
     M3nofpc_summary_375_500_&spec.(in=z)
     M3fpc_summary_375_500_&spec.(in=aa)

; 
	 

 if (a or d or g or j or m or p or s or v or y) then Method="OR";
 else if (b or e or h or k or n or q or t or w or z) then Method="WC";
 else if (c or f or i or l or o or r or u or x or aa) then Method="WC-fpc";
 if (a or b or c) then Sample_size=25;
 else if (d or e or f) then Sample_size=50;
 else if (g or h or i) then Sample_size=75;
 else if (j or k or l) then Sample_size=50;
 else if (m or n or o) then Sample_size=100;
 else if (p or q or r) then Sample_size=150;
 else if (s or t or u) then Sample_size=125;
 else if (v or w or x) then Sample_size=250;
 else if (y or z or aa) then Sample_size=375;

 if (a or b or c or d or e or f or g or h or i) then Pop_size=100;
 else if (j or k or l or m or n or o or p or q or r) then Pop_size=200;
 else if (s or t or u or v or w or x or y or z or aa) then Pop_size=500;

 sample_size2=round(ss,1);
 cov2=cov*100;
 SE_RATIO=Avg_SE/Emp_SE;
 PCT_BIAS=(ebias/(Est_tot-ebias));

 SPECIFICATION="&spec.";
 label ebias="Empirical Bias"
       PCT_BIAS="Empirical Bias (%)"
       sample_size="Average Sample Size"
	   Pop_size="Population Size"
       Est_tot="Average Estimated Number HIV+ Inmates"
       Cov="95% CI Coverage (state-level estimate)"
	   Cov2="95% CI Coverage (state-level estimate)"
       CI_HW="95% CI Half-Width (state-level estimate)"
       PI_Cov="95% PI Coverage (county-level estimates)"
	   Emp_SE="ESE"
	   Avg_SE="ASE"
	   SE_RATIO="SER";
	   
run;

%MEND;

%format_dat(BI);
%format_dat(OI);
%format_dat(WI);

*weight model incorrect;
   proc report data=sim_table_WI headskip missing split="$"  style(column)=[font_size=8pt] nowindows ;
	  columns Pop_size sample_size Method Est_Tot /*ebias*/ pct_bias avg_se emp_se SE_ratio Cov CI_HW PI_Cov mean_RSE; 
	  define Pop_size / group order=data;
	  define sample_size / group order=data;
	  format Est_Tot CI_HW 10.0 ebias avg_se emp_se 10.1 Cov PI_Cov SE_ratio mean_RSE 10.2 PCT_bias percentn10.2;
	run ;

*outcome model incorrect;
	proc report data=sim_table_OI headskip missing split="$"  style(column)=[font_size=8pt] nowindows ;
	  columns Pop_size sample_size Method Est_Tot /*ebias*/ pct_bias avg_se emp_se SE_ratio Cov CI_HW PI_Cov mean_RSE; 
	  define Pop_size / group order=data;
	  define sample_size / group order=data;
	  format Est_Tot CI_HW 10.0 ebias avg_se emp_se 10.1 Cov PI_Cov SE_ratio mean_RSE 10.2 PCT_bias percentn10.2;
	run ;

*both models incorrect;
	proc report data=sim_table_BI headskip missing split="$"  style(column)=[font_size=8pt] nowindows ;
	  columns Pop_size sample_size Method Est_Tot /*ebias*/ pct_bias avg_se emp_se SE_ratio Cov CI_HW PI_Cov mean_RSE; 
	  define Pop_size / group order=data;
	  define sample_size / group order=data;
	  format Est_Tot CI_HW 10.0 ebias avg_se emp_se 10.1 Cov PI_Cov SE_ratio mean_RSE 10.2 PCT_bias percentn10.2;
	run ;
