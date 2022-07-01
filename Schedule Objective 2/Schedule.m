classdef Schedule < handle
    properties
        dailyPlanningHorizon
        planningDays
        numberOfRooms
        finalSchedule
    end

    methods
        function output = constructSchedule(input)
                numericData = readmatrix(input);
                numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
                nameSurnameData = readmatrix(input,"Range","B:C","OutputType","string");
                nameSurnameData = nameSurnameData(2:98,:);
            
        end

    end

end