# Record_Linkage_Finite_Pop_Inference

This repository contains simulation code from "Estimating the Number of Persons with HIV in Jails via Web Scraping and Record Linkage" by Bonnie E. Shook-Sa, Michael G. Hudgens, Andrew L. Kavee, and David L. Rosen

Note that code requires both SAS and SAS-callable SUDAAN.

simdata.sas7bdat - dataset with covariates from 100 counties in North Carolina (square root of the index crime rate and poverty level, county population in 2016, HIV prevalence in 2016, and urbanicity)
IMPORTANT NOTE: For confidentiality purposes, this dataset does not contain the number of HIV+ defendants from the record linkage process. Instead, the 01 and 03 programs below generate a mock value that can be used to run the simulation code.
                For this reason, results of the simulations based on provided data and code will vary slightly from the results in the manuscript which are based on the true number of HIV+ defendants from the record linkage process.

01_Create_Frames_BC.sas and 03_Create_Frames_Inc_Models.sas create the sampling frames for each of the simulation scenarios described in Section 3 of the manuscript for correctly and incorrectly specified models, respectively

02a_Include_BC.sas, 04a_Include_BI.sas, 04a_Include_OI.sas, and 04a_Include_WI.sas are macros that implement the simulations for a given scenario with both models correct, both models incorrect, outcome models incorrect, and weight models incorrect, respectively

02b_Run_Sims_BC.sas, 04b_Run_Sims_BI.sas, 04b_Run_Sims_OI.sas, and 04b_Run_Sims_BI.sas call the corresponding 02a or 04a macros to implement the simulation study for each of the 9 finite population by sample size scenarios considered

02c_Simulation_Summary_BC.sas and 04c_Simulation_Summary_Inc_Models.sas combine the results of the simulations for correctly and incorrectly specified models, respectively
