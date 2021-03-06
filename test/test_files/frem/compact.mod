$PROBLEM    MOXONIDINE PK ANALYSIS
$INPUT      ID VISI DROP DGRP DOSE DROP DROP DROP DROP NEUY SCR AGE
            SEX DROP WT DROP ACE DIG DIU DROP TAD TIME DROP CRCL AMT
            SS II DROP DROP DROP DV DROP DROP MDV FREMTYPE
$DATA      ../frem_dataset.dta IGNORE=@
$ABBREVIATED DERIV2=NO COMRES=6
$SUBROUTINE ADVAN2 TRANS1
$PK   
;----------IOV--------------------

   KPLAG = 0

   TVCL  = THETA(1)
   TVV   = THETA(2)
   TVKA  = THETA(3)

   CL    = TVCL*EXP(ETA(1))
   V     = TVV*EXP(ETA(2))
   KA    = TVKA*EXP(ETA(3))
   LAG   = THETA(4)
   PHI   = LOG(LAG/(1-LAG))
   ALAG1 = EXP(PHI+KPLAG)/(1+EXP(PHI+KPLAG))
   K     = CL/V
   S2    = V

$ERROR   

     IPRED = LOG(.025)
     W     = THETA(5)
     IF(F.GT.0) IPRED = LOG(F)
     IRES  = IPRED-DV
     IWRES = IRES/W
     Y     = IPRED+ERR(1)*W

;;;FREM CODE BEGIN COMPACT
;;;DO NOT MODIFY
     IF (FREMTYPE.EQ.100) THEN
;       AGE
        Y = THETA(6) + ETA(4)*7.82226906804 + EPS(2)
        IPRED = THETA(6) + ETA(4)*7.82226906804
     END IF
     IF (FREMTYPE.EQ.200) THEN
;       SEX
        Y = THETA(7) + ETA(5)*0.404756978659 + EPS(2)
        IPRED = THETA(7) + ETA(5)*0.404756978659
     END IF
;;;FREM CODE END COMPACT
$THETA  (0,32.8939)
 (0,21.0339)
 (0,0.283218)
$THETA  (0,0.0957656) ; LAG
$THETA  (0,0.334858) ; W
$THETA  65.1756756757 FIX ; TV_AGE
 1.2027027027 FIX ; TV_SEX
$OMEGA  BLOCK(5)
 0.4123
 0.664948 1.11316
 1E-07 1E-07 0.221903  ;         KA
 -0.0819163 -0.167456 0.0449267 0.986486  ;    BSV_AGE
 0.0898628 0.170926 0.0121642 -0.113683 0.986485  ;    BSV_SEX
$SIGMA  1  FIX
$SIGMA  1e-07  FIX  ;     EPSCOV
$ESTIMATION MAXEVALS=9990 PRINT=10 METHOD=CONDITIONAL
$COVARIANCE

