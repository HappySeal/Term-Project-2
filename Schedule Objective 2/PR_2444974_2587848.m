clear
clc
close all


numericData = readmatrix("InputData.xlsx");
numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
[n,m] = size(numericData);
nameSurnameData = readmatrix("InputData.xlsx","Range","B:C","OutputType","string");
nameSurnameData = nameSurnameData(2:n+1,:);

s = Schedule(3,5,Interval(0,480));
s.penaltyMultiplier = 7;
    
s.constructSchedule(numericData,nameSurnameData);
s.printSchedule();