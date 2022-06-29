clear
clc
close all

numericData = readmatrix("InputData.xlsx");
numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
nameSurnameData = readmatrix("InputData.xlsx","Range","B:C","OutputType","string");
nameSurnameData = nameSurnameData(2:98,:);

scheduledPtr = [];
scheduleMatrix = zeros([3,480,5]);

scheduling = -1;
left = 0;

for day = 1:1
    dailySurgeries = numericData(numericData(:,2) == day,1);
    waiting = [];
    for i = 1:3
        time = 0;
        while time < 480
            if left == 0

                atTime = numericData(numericData(dailySurgeries,4) <= time & numericData(dailySurgeries,5) >= time + numericData(dailySurgeries,3) ,1);
                waiting = [waiting atTime'];

                [pr,n] = min(numericData(waiting,6));
                scheduling = waiting(n);
                dailySurgeries = dailySurgeries(dailySurgeries ~= waiting(n));
                
                waiting = waiting(waiting ~= waiting(n));
                scheduleMatrix(i,time+1,day) = scheduling;
                left = numericData(scheduling,3) - 1;
            else
                scheduleMatrix(i,time+1,day) = scheduling;
                left = left - 1;
            end
            time = time + 1;
        end
    end
end
            

for day = 1:5
    subplot(1,5,day);
    axis square;
    for i = 1:3
        for j = 1:480
            if scheduleMatrix(i,j,day)
                rand('seed',scheduleMatrix(i,j,day));
                c = [rand rand rand];
            else
                c = [0 0 0 0];
            end
            rectangle("Position",[j,i,1,1],"FaceColor",c,"EdgeColor",[0 0 0 0]);
        end
    end
end
