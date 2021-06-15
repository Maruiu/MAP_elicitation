set seed 2021

clear
set matsize 1000
mat estimates = J(1000,2,.)
* Creates a matrix of 1000 rows by 2 columns. In each row, we will store the
*p-values of each simulation. In our case, since we have two treatments (G and B),
*there are two p-values per row.
local subjects=400
*We assume that about 11% of 450 participants fail the comprehension questions
*and do not make it to Part 2.
local teffect= 0.34*0.1473471
* Defines the number of subjects in our experiment, the treatment effect. We 
*take the treatment effect to be 0.35 times the betrayal aversion coefficient
*reported in Bohnet, Greig, Herrmann, & Zeckhauser (AER 2008)-- henceforth BGHZ.

* First, we assume that the second and the third MAP are `sticky', that is, they
*don't move far from the first MAP.
quietly forvalues j=1(1)1000 {
* Repeats the following code 1000 times.
clear
set obs `subjects'
gen id=_n
* Divides the subjects into six groups (there are six possible orders of going through the treatments).
gen t=runiform()
egen sequence=cut(t),group(6)
gen task1=cond(sequence==0 | sequence==3,1,cond(sequence==1 | sequence==5,0,2))
gen task2=cond(sequence==0 | sequence==4,0,cond(sequence==2 | sequence==5,1,2))
gen task3=cond(sequence==2 | sequence==3,0,cond(sequence==1 | sequence==4,1,2))
* Orders subjects randomly for each of the 3 tasks.
label define treat 0 "Uniform" 1 "Left skew" 2 "Right skew"
label values task1 treat
label values task2 treat
label values task3 treat
* Labels the treatments.
gen mu= rnormal()*0.25056*0.2
bys id: replace mu = mu[1]
gen eps1= rnormal()*0.25056*0.8
gen eps2= rnormal()*0.25056*0.8
gen eps3= rnormal()*0.25056*0.8
* Generates the individual effect and the error terms for the 3 decisions.
gen map1=rnormal(.4474194,.2362232)+mu+eps1
replace map1=map1+`teffect' if task1==1
replace map1=map1-`teffect' if task1==2
gen map2=0.8*map1+0.2*rnormal(.4474194,.2362232)+mu+eps2
*MAP2 is influenced by MAP1 (possibly due to order effects).
replace map2=map2+`teffect' if task2==1
replace map2=map2-`teffect' if task2==2
gen map3=0.7*map1+0.3*rnormal(.4474194,.2362232)+mu+eps3
*MAP3 is influenced by MAP1, but less so than MAP2 (possibly due to order effects).
replace map3=map3+`teffect' if task3==1
replace map3=map3-`teffect' if task3==2
* Assigns an observation per task to each of the subjects.

reshape long map, i(id) j(task)
gen treatment = cond(task==1,task1,cond(task==2,task2,task3))
reg map i.treatment i.task, robust cluster(id)
local q1 = _b[1.treatment]/_se[1.treatment]
scalar pvalue1 = 2*ttail(e(df_r),abs(`q1'))
local q2 = _b[2.treatment]/_se[2.treatment]
scalar pvalue2 = 2*ttail(e(df_r),abs(`q2'))
* Tests differences between the control and treated group. Stores the p-value
* of the test.
matrix estimates[`j',1] = pvalue1
matrix estimates[`j',2] = pvalue2
* Adds the p-value of the test to the row number "j" of column 1 (or 2) on the 1000x2
* matrix that we created.
noisily display `j'
* Shows you on which simulation we are at (personal preference)
}

* This experiment is repeated 1000 times.

svmat estimates, names(pvalues)
gen n=_n
* Retrieves (and adds to our dataset) the 1000x2 matrix with the p-values of all
* the simulated experiments.

gen significant=0 if n<1000
replace significant=1 if pvalues1<0.05
gen significant2=0 if n<1000
replace significant2=1 if pvalues2<0.05
* Creates a variable with value 1 if the experiment was significant.

ci means significant
ci means significant2
* It displays the percentage of experiments in which the test was significant
* (power) and its confidence interval.


set seed 2021
clear
set matsize 1000
mat estimates = J(1000,2,.)
* Creates a matrix of 1000 rows by 2 columns. In each row, we will store the
*p-values of each simulation. In our case, since we have two treatments (G and B),
*there are two p-values per row.
local subjects=400
*We assume that about 10% of 450 participants fail the comprehension questions
*and do not make it to Part 2.
local teffect= 0.42*0.1473471
* Defines the number of subjects in our experiment, the treatment effect. We 
*take the treatment effect to be 0.35 times the betrayal aversion coefficient
*reported in Bohnet, Greig, Herrmann, & Zeckhauser (AER 2008)-- henceforth BGHZ.


* Next, we assume that the MAPs are not sticky.
quietly forvalues j=1(1)1000 {
* Repeats the following code 1000 times.
clear
set obs `subjects'
gen id=_n
* Divides the subjects into six groups (there are six possible orders of going through the treatments).
gen t=runiform()
egen sequence=cut(t),group(6)
gen task1=cond(sequence==0 | sequence==3,1,cond(sequence==1 | sequence==5,0,2))
gen task2=cond(sequence==0 | sequence==4,0,cond(sequence==2 | sequence==5,1,2))
gen task3=cond(sequence==2 | sequence==3,0,cond(sequence==1 | sequence==4,1,2))
* Orders subjects randomly for each of the 3 tasks.
label define treat 0 "Uniform" 1 "Left skew" 2 "Right skew"
label values task1 treat
label values task2 treat
label values task3 treat
* Labels the treatments.
gen mu= rnormal()*0.25056*0.2
bys id: replace mu = mu[1]
gen eps1= rnormal()*0.25056*0.8
gen eps2= rnormal()*0.25056*0.8
gen eps3= rnormal()*0.25056*0.8
* Generates the individual effect and the error terms for the 3 decisions.
gen map1=rnormal(.4474194,.2362232)+mu+eps1
replace map1=map1+`teffect' if task1==1
replace map1=map1-`teffect' if task1==2
gen map2=rnormal(.4474194,.2362232)+mu+eps2
*MAP2 is influenced by MAP1 (possibly due to order effects).
replace map2=map2+`teffect' if task2==1
replace map2=map2-`teffect' if task2==2
gen map3=rnormal(.4474194,.2362232)+mu+eps3
*MAP3 is influenced by MAP1, but less so than MAP2 (possibly due to order effects).
replace map3=map3+`teffect' if task3==1
replace map3=map3-`teffect' if task3==2
* Assigns an observation per task to each of the subjects.

reshape long map, i(id) j(task)
gen treatment = cond(task==1,task1,cond(task==2,task2,task3))
reg map i.treatment i.task, robust cluster(id)
local q1 = _b[1.treatment]/_se[1.treatment]
scalar pvalue1 = 2*ttail(e(df_r),abs(`q1'))
local q2 = _b[2.treatment]/_se[2.treatment]
scalar pvalue2 = 2*ttail(e(df_r),abs(`q2'))
* Tests differences between the control and treated group. Stores the p-value
* of the test.
matrix estimates[`j',1] = pvalue1
matrix estimates[`j',2] = pvalue2
* Adds the p-value of the test to the row number "j" of column 1 (or 2) on the 1000x2
* matrix that we created.
noisily display `j'
* Shows you on which simulation we are at (personal preference)
}

* This experiment is repeated 1000 times.

svmat estimates, names(pvalues)
gen n=_n
* Retrieves (and adds to our dataset) the 1000x2 matrix with the p-values of all
* the simulated experiments.

gen significant=0 if n<1000
replace significant=1 if pvalues1<0.05
gen significant2=0 if n<1000
replace significant2=1 if pvalues2<0.05
* Creates a variable with value 1 if the experiment was significant.

ci means significant
ci means significant2
* It displays the percentage of experiments in which the test was significant
* (power) and its confidence interval.
