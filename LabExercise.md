Introduction to Survival Analysis Using R(Spring 2006)
=======================================================
**www.stat.ncu.edu.tw/teacher/Tsengyk/Handout2b.doc**


In this session we cover the basics of modeling time-to-event (TTE) data using the R software package.  R is the free clone of S and can be downloaded from http://www.r-project.org/.   The following topics will be addressed:

•	Importing data into R.
•	Fitting accelerated failure time (AFT) models and obtaining inferences for parameters of interest, including regression coefficients, median TTE’s for any covariate combination, the survivor function for any covariate combination.
•	Fitting proportional hazards models and obtaining inferences for risk ratios and survivor functions.
•	Model selection using stepAIC.  
•	Goodness of fit/model diagnostics (time permitting)


We consider a subset of the data from a study designed to assess the effect of a new treatment on the time to infection of burn patients.  The analyses presented are for illustrative purposes only.  The covariates included in the analyses we will consider include (i) treatment (new=1; standard=0), (ii) female (1=female, 0=male), (iii) white (1=white, 0=other), (iv) surface area burned, (v) burntype (1=chemical, 2=scald, 3=electric, 4=flame).  

We need to load the survival library and the MASS library in R.  Do this by running the lines
library(survival)
library(MASS)


<hr> 
### 1.	Importing data into R

Data are often stored in text files or in Excel files.  If the data are in an Excel file then I usually save the data in a .txt file in order to import it into R.  We can import Excel files into R but this can require some fussing (this is easy to do in Splus though).  To import the burn data I used the command

burndata <- read.table(file="C:\\Stat 222\\BurnData\\subsetoftheburndata.txt",header=T,sep="\t")
attach(burndata)
options(contrasts=c("contr.treatment","contr.poly"))

Of course, you need to change the path in order to import your data.  The header=T option tells R that the variable names are stored in the first row of my data set.  If you don’t have variable names in the first row, set header=F and you can use the col.names function to provide variable names.  


### 2.	AFT models

AFT models are specified as
Log(T)=x+W.
Log normal, log-logistic, and Weibull regression are obtained when W~N(0,1), W~logistic, and W~Extreme value, respectively.  These models are fit using the survreg() function:

survreg(formula, data=sys.parent(), weights, subset, na.action, dist="weibull", init, scale=0, control, ...)

and usually we will work with 

survreg(Surv(time,status)~…, data=, na.action=na.omit, dist=" "),

where the “dist=” option can be set equal to "weibull", "lognormal", or "loglogistic", among others (see documentation), and after the ~ is a list of your covariates separated by “+” signs.  The data= option is set equal to whatever name you assigned your data to; for the burn data it would be data=burndata.

To fit a log normal regression we use

LogNormalReg <- survreg(Surv(time,status)~newtrt+female+white+saburned+factor(burntype),data=burndata,na.action=na.omit, dist="lognormal")

Alternatively we could have created indicator variables for the burntype variable.  

chemical <- burntype==1
scald <- burntype==2
electric <- burntype==3
flame <- burntype==4

and fit the model 

LogNormalReg1 <- survreg(Surv(time,status)~newtrt+female+white+saburned+scald+electric+flame,data=burndata,na.action=na.omit, dist="lognormal")


The fitted model is obtained using the command summary(LogNormalReg) and summary(LogNormalReg1).  It gives the estimated regression coefficients and their standard errors.  It also gives loglik(MLE) for the full and baseline models.  Note that in LogNormalReg, the covariate burntype is categorical and we tell R to treat it as such using factor(burntype).  

> summary(LogNormalReg)

Call:
survreg(formula = Surv(time, status) ~ newtrt + female + white + saburned + factor(burntype), data = burndata, na.action = na.omit, dist = "lognormal")
                     Value Std. Error      z         p 
      (Intercept)  6.92312    1.25462  5.518 3.43e-008
           newtrt  0.51484    0.31840  1.617 1.06e-001
           female  0.58168    0.40554  1.434 1.51e-001
            white -2.38017    0.80204 -2.968 3.00e-003
         saburned -0.00524    0.00801 -0.654 5.13e-001
factor(burntype)2 -1.75471    0.99325 -1.767 7.73e-002
factor(burntype)3 -2.33690    1.02081 -2.289 2.21e-002
factor(burntype)4 -0.92192    0.88542 -1.041 2.98e-001
       Log(scale)  0.40636    0.11339  3.584 3.39e-004

Scale= 1.5 

Log Normal distribution
Loglik(model)= -232.6   Loglik(intercept only)= -247.2
	Chisq= 29.13 on 7 degrees of freedom, p= 0.00014 
Number of Newton-Raphson Iterations: 3 
n= 154 



We can compare the Weibull, log logistic, and log normal fits using AIC, where 
AIC=-2loglik(MLE) +2p where p is the number of parameters in the model.  The ANOVA function will provide –2loglik(MLE) for each model (this can also be obtained from the summaries).  The log normal model yields the smallest AIC so we’ll proceed with that model.


anova(WeibullReg,LogNormalReg,LogLogisticReg)

-2loglik = 474.9971	Weibull
-2loglik = 465.2968	Log normal
-2loglik = 469.0688	Log logistic


There are no built in functions that will provide inferences for median TTE’s or plot survivor functions for the AFT model.  To get inferences for median TTE’s and for the survivor function at a point, we need the covariance matrix Cov( ).  Unfortunately R gives the covariance matrix for Cov( ).   To get this use,

LogNormalReg$var


To get the covariance matrix we want, Cov( ), simply multiply all the elements in the last row and the last column by  .

covhatstar <- LogNormalReg$var
covhat <- covhatstar
covhat[,9] <- covhatstar[,9]* LogNormalReg$scale
covhat[9,] <- covhatstar[9,]* LogNormalReg$scale
    
 

Median TTE’s:

Consider two burn patients with the following covariate combinations
x1=(1, treatment=1, female=0, white=1, surface area burned=20, burntype=4)
x2=(1, treatment=0, female=0, white=1, surface area burned=20, burntype=4).

The median TTE for an individual with covariate vector x under the log normal regression model is exp(x).

x1 <- c(1,1,0,1,20,0,0,1)
x2 <- c(1,0,0,1,20,0,0,1)

medx1 <- exp(x1%*%LogNormalReg$coeff)
c(exp(x1%*%LogNormalReg$coeff-1.96*sqrt(matrix(c(x1,0),1,9)%*%covhat%*%matrix(c(x1,0),9,1))), medx1,
exp(x1%*%LogNormalReg$coeff+1.96*sqrt(matrix(c(x1,0),1,9)%*%covhat%*%matrix(c(x1,0),9,1))))

medx2 <- exp(x2%*%LogNormalReg$coeff)
c(exp(x2%*%LogNormalReg$coeff-1.96*sqrt(matrix(c(x2,0),1,9)%*%covhat%*%matrix(c(x2,0),9,1))), medx2,
exp(x2%*%LogNormalReg$coeff+1.96*sqrt(matrix(c(x2,0),1,9)%*%covhat%*%matrix(c(x2,0),9,1))))

For subject 1:
L		Median	U
31.29894  56.31643 101.33061

For subject 2:
L		Median	U
18.83368 33.65439 60.13791

 

Plotting survivor curves:

S(t|x)=S0{(log t – x)/ } where for log normal regression S0(w)=1- .  The estimated survivor functions for patients 1 and 2 are obtained using the code

t <- seq(0,50,0.1)
survx1 <- 1-pnorm((log(t)-x1%*%LogNormalReg$coeff)/LogNormalReg$scale)
survx2 <- 1-pnorm((log(t)-x2%*%LogNormalReg$coeff)/LogNormalReg$scale)
plot(t,survx1,type='l',xlab="Time",ylab="Surv Prob",ylim=c(0,1))
lines(t,survx2,lty=2)


 
Fig 1:  Survivor functions based on the log normal model for white males that had 20% surface area burned by flame and that received the new treatment (solid line) or the standard treatment (dashed line).  

<hr>
### 3.	Proportional hazards model

The R function used to fit the PH model is coxph() and to fit the burn data we use

> PHmodel <- coxph(Surv(time, status) ~ newtrt + female + white + saburned + factor(burntype), data = burndata)
> summary(PHmodel)
Call:
coxph(formula = Surv(time, status) ~ newtrt + female + white + saburned + factor(burntype), data = burndata)

  n= 154 

                     coef exp(coef) se(coef)      z     p 
           newtrt -0.6166     0.540  0.30333 -2.033 0.042
           female -0.5341     0.586  0.39862 -1.340 0.180
            white  2.2316     9.314  1.02956  2.167 0.030
         saburned  0.0045     1.005  0.00727  0.619 0.540
factor(burntype)2  1.5213     4.578  1.09518  1.389 0.160
factor(burntype)3  2.0679     7.908  1.08898  1.899 0.058
factor(burntype)4  0.9651     2.625  1.02064  0.946 0.340

                  exp(coef) exp(-coef) lower .95 upper .95 
           newtrt     0.540      1.853     0.298     0.978
           female     0.586      1.706     0.268     1.280
            white     9.314      0.107     1.238    70.068
         saburned     1.005      0.996     0.990     1.019
factor(burntype)2     4.578      0.218     0.535    39.166
factor(burntype)3     7.908      0.126     0.936    66.835
factor(burntype)4     2.625      0.381     0.355    19.406

Rsquare= 0.147   (max possible= 0.942 )
Likelihood ratio test= 24.4  on 7 df,   p=0.000952
Wald test            = 19.8  on 7 df,   p=0.00594
Score (logrank) test = 23.3  on 7 df,   p=0.0015



We extract the covariance matrix for the MLE of  as in the AFT model.  Use

PHmodel$var

Only here R gives the covariance matrix we want.  Relative risks for individuals with
covariate combinations x and x* are obtained as previously described in the AFT setting.  
The relative risk is exp{(x-x*)} so we get a 95% CI for (x-x*) and then exponentiate 
the endpoints.  

We can use the built in function stepAIC in the MASS library for automatic model 
selection.   First we must run the following code
library(MASS)

Type ?stepAIC for help.

To use this function we specify an upper and a lower model.  The code below specifies 
the upper model as the model that includes all main effects and all 2 way interactions 
with newtrt.  The lower model contains only the newtrt variable.

PHstp <- stepAIC(PHmodel, scope = list(upper = .~.+newtrt*female +newtrt*factor(burntype)+newtrt*saburned,lower = ~newtrt))


The procedure removed the saburned variable first and then stopped.  The final result was 

					  <none>    426.5009
                 - female  1 426.7209
       - factor(burntype)  3 427.8148
               + saburned  1 428.1300
          + newtrt:female  1 428.2391
+ newtrt:factor(burntype)  3 429.7343
                  - white  1 434.8294





















 
Survivor functions are also easy to get.  

PHmodel1 <- coxph(Surv(time, status) ~ newtrt+female+white+scald+electric+flame)
PHmodelx1 <- survfit(PHmodel1, list(newtrt=1, female=0, white=1, scald=0,electric=0,flame=1))
PHmodelx2 <- survfit(PHmodel1, list(newtrt=0, female=0, white=1, scald=0,electric=0,flame=1))
plot(PHmodelx1$time, PHmodelx1$surv, type="l", ylim=c(0,1), xlab="Time to Infection", ylab="Surv Prob")
lines(PHmodelx2$time, PHmodelx2$surv, lty=2)
legend(2, 0.3, c("New treatment", "Routine Treatment"), lty=c(1,3), bty='n')

 
Fig 2:  Survivor functions based on the Cox model for white males that were burned by flame and that received the new treatment (solid line) or the standard treatment (dashed line).  
 
We can try to get inferences for the median TTE based on the Cox model for these two 
individuals the survfit function.  In my experience the 0.95Ucl is usually missing 
and often the median is as well.  This, of course, is data dependent.

> PHmodelx1
Call: survfit.coxph(object = PHmodel1, newdata = list(newtrt = 1, female = 0, 
    white = 1, scald = 0, electric = 0, flame = 1))

      n  events  median 0.95LCL 0.95UCL 
    154      48     Inf      44     Inf

> PHmodelx2
Call: survfit.coxph(object = PHmodel1, newdata = list(newtrt = 0, female = 0, 
    white = 1, scald = 0, electric = 0, flame = 1))

      n  events  median 0.95LCL 0.95UCL 
    154      48      42      17     Inf































A graphical summary 

 




 


Here is the code used to get this plot

par(mfrow=c(2,2))
plot(PHmodelx1$time, PHmodelx1$surv, type="l", ylim=c(0,1), xlab="Time to Infection", ylab="Surv Prob",main="Cox Model")
lines(PHmodelx2$time, PHmodelx2$surv, lty=2)
t <- seq(0,50,0.1)
survx1 <- 1-pnorm((log(t)-x1%*%LogNormalReg$coeff)/LogNormalReg$scale)
survx2 <- 1-pnorm((log(t)-x2%*%LogNormalReg$coeff)/LogNormalReg$scale)
plot(t,survx1,type='l',xlab="Time to Infection",ylab="Surv Prob",ylim=c(0,1),main="Lognormal Model")
lines(t,survx2,lty=2)
plot(PHmodelx1$time, PHmodelx1$surv, type="l", ylim=c(0,1), xlab="Time to Infection", ylab="Surv Prob",main="Cox Model and \n Lognormal Model")
lines(PHmodelx2$time, PHmodelx2$surv, lty=2)
lines(t,survx1,lty=1)
lines(t,survx2,lty=2)
#legend(2, 0.3, c("New treatment", "Routine Treatment"), lty=c(1,3), bty='n')
KM.fit <- survfit(Surv(time, status)~newtrt, conf.type="log-log")
plot(PHmodelx1$time, PHmodelx1$surv, type="l", ylim=c(0,1), xlab="Time to Infection", ylab="Surv Prob",main="Cox Model and \n Kaplan-Meier Est")
lines(PHmodelx2$time, PHmodelx2$surv)
lines(KM.fit,lty=2)

