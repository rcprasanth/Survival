Cox Regression
=========================
http://socserv.mcmaster.ca/jfox/Books/Companion/appendix/Appendix-Cox-Regression.pdf

The coxph Function
The Cox proportional-hazards regression model is t in R with the coxph function (located in the
survival package):
> library(survival)
> args(coxph)

function (formula, data, weights, subset, na.action, init, control,
method = c("efron", "breslow", "exact"), singular.ok = TRUE,
robust = FALSE, model = FALSE, x = FALSE, y = TRUE, ...)
NULL

<hr>

> url <- "http://socserv.mcmaster.ca/jfox/Books/Companion/data/Rossi.txt"
> Rossi <- read.table(url, header=TRUE)
> Rossi[1:5, 1:10]
week arrest fin age race wexp mar paro prio educ
1 20 1 no 27 black no not married yes 3 3
2 17 1 no 18 black no not married yes 8 4
3 25 1 no 19 other yes not married yes 13 3
4 52 0 yes 23 black yes married yes 1 5
5 52 0 no 19 other yes not married yes 3 3
