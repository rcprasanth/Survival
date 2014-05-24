Survival analysis
============================
Survival analysis is generally defined as a set of methods for analyzing data where the outcome variable 
is the time until the occurrence of an event of interest. The event can be death, occurrence of a disease, 
marriage, divorce, etc. The time to event or survival time can be measured in days, weeks, years, etc. 
For example, if the event of interest is heart attack, then the survival time can be the time in years until a 
person develops a heart attack. 
 
In survival analysis, subjects are usually followed over a specified time period and the focus is on the 
time at which the event of interest occurs. Why not use linear regression to model the survival time as a 
function of a set of predictor variables? First, survival times are typically positive numbers; ordinary 
linear regression may not be the best choice unless these times are first transformed in a way that 
removes this restriction. Second, and more importantly, ordinary linear regression cannot effectively 
handle the censoring of observations. 

#### Censoring 
Observations are called censored when the information about their survival time is incomplete; the most 
commonly encountered form is right censoring. Suppose patients are followed in a study for 20 weeks. 
A patient who does not experience the event of interest for the duration of the study is said to be right 
censored. The survival time for this person is considered to be at least as long as the duration of the 
study. Another example of right censoring is when a person drops out of the study before the end of the 
study observation time and did not experience the event. This person’s survival time is said to be 
censored, since we know that the event of interest did not happen while this person was under 
observation. Censoring is an important issue in survival analysis, representing a particular type of 
missing data. Censoring that is random and non informative is usually required in order to avoid bias in 
a survival analysis.
<hr>

Survival analysis is used to analyze data in which the time
until the event is of interest. The response is often referred to
as a failure time, survival time, or event time.

#### Censoring
- Censoring is present when we have some information about
a subject’s event time, but we don’t know the exact event time.
- For the analysis methods we will discuss to be valid, censoring
mechanism must be independent of the survival mechanism.
- There are generally three reasons why censoring might occur:
 - A subject does not experience the event before the study ends
 - A person is lost to follow-up during the study period
 - A person withdraws from the study
 - *These are all examples of right-censoring.*
