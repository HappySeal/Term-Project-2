clear
clc
close all;

numericData = readmatrix("InputData.xlsx");
numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
nameSurnameData = readmatrix("InputData.xlsx","Range","B:C","OutputType","string");
nameSurnameData = nameSurnameData(2:98,:);

numericData(:,7) =  numericData(:,6) + (numericData(:,5) - numericData(:,4))./(numericData(:,3)) - 1;

scheduledPtr = [];
scheduleMatrix = zeros([3,480,5]);



for day = 1:5
    time = [0,0,0];
    while any(time < 480)
        for i = 1:3        
            unscheduled = numericData(find(prod(1:length(numericData) ~= scheduledPtr(:),1)),:);
            ptr = find(unscheduled(:,2) == day & unscheduled(:,4) <= time(i) & (time(i) <= unscheduled(:,5) - unscheduled(:,3)));
            if isempty(ptr)
                time(i) = time(i) + 1;
            else
                [minFlexibility,n] =  min(unscheduled(ptr,7));
%                 ptr = ptr(unscheduled(ptr,7) == minFlexibility);
%                 [minPriority,m] =  min(unscheduled(ptr,6));
                next = ptr(n);
                scheduleMatrix(i,time(i)+1:time(i)+unscheduled(next,3),day) = unscheduled(next,1);
                scheduledPtr = [scheduledPtr unscheduled(next,1)];
                time(i) = time(i) + unscheduled(next,3);
            end
        end
    end

    postponed = unscheduled(unscheduled(:,2) == day & unscheduled(:,6) ~= 0,:);
    if ~isempty(postponed)
        [n,m] = size(postponed);
        fprintf("[%d,{",day);
        fprintf("%d,",postponed(:,1));
        fprintf("}");

        numericData(postponed(:,1),2) = day + 1;
        numericData(postponed(:,1),6) = 0;
        numericData(postponed(:,1),4) = 0;
        numericData(postponed(:,1),5) = numericData(postponed(:,1),3);
        numericData(postponed(:,1),7) = 0;

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

