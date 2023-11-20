/****************************************************************************************
Program:          Program_3-1.sas

SAS Version:      SAS Enterprise Guide 7.15 (SAS 9.4m5)
Developer:        Yuchuan Han
Date:             2023-11-23
Purpose:          Produce outputs for SAS� Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10
Macros:           NONE
Input:            adlbchem.sas7bdat
Output:           Output_3-2.rtf
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
options validvarname=upcase;
libname adam "/home/u61403758" access=readonly;
libname tfldata "/home/u61403758/tfldata";
%let outputpath = /home/u61403758/output;
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

/* formats to display time point */
proc format;
   value trt
       0 = 'Placebo'
       54 = 'Xanomeline Low Dose'
       81 = 'Xanomeline High Dose'
                ;
run;

options nobyline nodate nonumber;
ods graphics on / imagefmt = png width = 5in noborder;
ods rtf file = "&outpath.\&outname..rtf"
        image_dpi = 300
        style = customSapphire;

title #byval2  at  #byval4;

/* subset for albumin and analysis visit less than 4 for display purposes only */
proc sgplot data = adam.adlbchem noautolegend; 
   where paramcd in ('ALB') and avisitn <= 4;
   by paramcd param avisitn avisit;
   format trtan trt.;

   vbox chg / category = trtan extreme displaystats = (max min std mean n);
   scatter x = trtan y = chg / jitter;
   xaxis type = discrete label = "Treatment";
   yaxis type = linear label = "Change from Baseline" ;
run;

ods rtf close;
ods graphics off;
