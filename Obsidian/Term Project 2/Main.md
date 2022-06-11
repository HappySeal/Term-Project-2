# Term Project 2
---

In this project we are going to have lots of fun with my darling ZBS, and this is the start of the journey ❤

---

# [[Kanban]]
# [[TP2.pdf|PDF]]

---

# OVERVIEW
```ad-abstract
title: Properties

- Certain number of surgery rooms, one surgery per room ( Number is given)
- Enough doctors for any schedule
- Interval = \[9:00 - 17:00] = \[0,480] (in minutes)
- Priority = {1,2,3,4}, 1st: Hightest => 4th: Lowest

```
![[Pasted image 20220611162432.png]]
```ad-example
title: Intervals

If a surgery
-> Duration = 10 min;
-> Interval = \[0,30];
Latest it can start = **20th minute** !
```
```ad-example
title: Priorities
- Surgery_1 and Surgery_2 have same interval => Higher priority will be done first.
```
```ad-example
title: Postponing
- If a surgery cant be scheduled on that day, it can be postponed to the next day with priority 0;
- This number only valid for postponed surgeries
- Start time of surgery will be equal to **9:00**
- 
```
