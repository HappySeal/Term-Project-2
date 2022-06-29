clear
clc
close all;

numericData = readmatrix("InputData.xlsx");
numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
nameSurnameData = readmatrix("InputData.xlsx","Range","B:C","OutputType","string");
nameSurnameData = nameSurnameData(2:98,:);

scheduledPtr = [];
scheduleMatrix = zeros([3,480,5]);
numericData(:,7) =  (numericData(:,5) - numericData(:,4))./(numericData(:,3));

nomberOfScheduled = 0;

for day = 1:5       
    nomnomberOfUnscheduled = 0;
    for p = min(numericData(:,6)):max(numericData(:,6))
        priorityFiltered = numericData(numericData(:,6) == p & numericData(:,2) == day,1);
        while priorityFiltered
            index = 0;
            maxDur = 0;
            for i = 1:length(priorityFiltered)
                if numericData(priorityFiltered(i),7) > maxDur
                    maxDur = numericData(priorityFiltered(i),7);
                    index = priorityFiltered(i);
                end
            end
%             fprintf("[%d,%d]",index,numericData(index,3));
            
            room = 1;
            unscheduled = 1;
            while room <= 3 && unscheduled
                time = numericData(index,4);
                while time <= numericData(index,5) - numericData(index,3) && unscheduled
                    if all(scheduleMatrix(room,(time+1):time+numericData(index,3),day) == 0)
                        scheduleMatrix(room,((time+1):(time+numericData(index,3))),day) = index;
                        unscheduled = 0;
                    end
                    time = time + 1;
                end
                room = room + 1;
            end

            if unscheduled && numericData(index,6)
                numericData(index,6) = 0;
                numericData(index,2) = day + 1;
                numericData(index,4) = 0;
                numericData(index,5) = numericData(index,3);
            end

            priorityFiltered = priorityFiltered(priorityFiltered ~= index);
            nomberOfScheduled = nomberOfScheduled + ~unscheduled;
            if unscheduled
                fprintf("%d,",index);
            end
            nomnomberOfUnscheduled = nomnomberOfUnscheduled + unscheduled;
        end
        fprintf("\n");
    end
    fprintf("---DAY:%d | Postponed: %d---\n",day,nomnomberOfUnscheduled);
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
