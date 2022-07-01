clear
clc
close all


numericData = readmatrix("InputData.xlsx");
numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
[n,m] = size(numericData);
nameSurnameData = readmatrix("InputData.xlsx","Range","B:C","OutputType","string");
nameSurnameData = nameSurnameData(1:n,:);

s = Schedule();
s.planningDays = 5;
s.numberOfRooms = 3;
s.dailyPlanningHorizon = Interval(0,480);

s.constructSchedule(numericData,nameSurnameData);
s.printSchedule();

