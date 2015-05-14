# http://stat.ethz.ch/education/semesters/ss2011/seminar/diez.pdf
install.packages(’survival’)
install.packages(’KMsurv’)

library(survival)
library(KMsurv)

##############################################
data(tongue); attach(tongue)
my.surv <- Surv(time[type==1], delta[type==1])
survfit(my.surv)

######################################################
my.fit <- survfit(my.surv)
summary(my.fit)$surv # outputs the Kaplan-Meier estimate at each t_i
summary(my.fit)$time # {t_i}
summary(my.fit)$n.risk # {Y_i}
summary(my.fit)$n.event # {d_i}
summary(my.fit)$std.err # standard error of the K-M estimate at {t_i}
summary(my.fit)$lower # lower pointwise estimates (alternatively, $upper)

#######################################################

lifetimes <- rexp( 25, rate = 0.2)
censtimes <- 5 + 5*runif(25)
ztimes <- pmin(lifetimes, censtimes)
status <- as.numeric(censtime > lifetimes)

