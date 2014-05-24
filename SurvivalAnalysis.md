Survival analysis
============================
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
