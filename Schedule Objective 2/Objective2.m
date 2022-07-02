clear
close all

numericData = readmatrix("InputData.xlsx");
numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
nameSurnameData = readmatrix("InputData.xlsx","Range","B:C","OutputType","string");
nameSurnameData = nameSurnameData(2:98,:);

scheduledPtr = [];
scheduleMatrix = zeros([3,480]);

count = 0;
for day = 1:5
    for i = 1:3
        time = 0;
        while time < 480
            unscheduled = numericData(find(prod(1:length(numericData) ~= scheduledPtr(:),1)),:);
            unscheduled(:,7) = (7).^(4-unscheduled(:,6)) + time - unscheduled(:,4);
            ptr = find(unscheduled(:,2) == day & unscheduled(:,4) <= time & (time <= unscheduled(:,5) - unscheduled(:,3)));
            if isempty(ptr)
                time = time + 1;
            else
                [val,n] = max(unscheduled(ptr,7));
                next = ptr(n);
                scheduleMatrix(i,time+1:time+unscheduled(next,3),day) = unscheduled(next,1);
                scheduledPtr = [scheduledPtr unscheduled(next,1)];
                time = time + unscheduled(next,3);
                count = count + 1;
            end
        end
    end

    postponed = unscheduled(unscheduled(:,2) == day & unscheduled(:,6) ~= 0,:);
    if ~isempty(postponed)
        [n,m] = size(postponed);
        fprintf("\n[%d]>>>",day);
        fprintf("%d,",postponed(:,1));
        

        numericData(postponed(:,1),2) = day + 1;
        numericData(postponed(:,1),6) = 0;
        numericData(postponed(:,1),4) = 0;
        numericData(postponed(:,1),5) = numericData(postponed(:,1),3);
    end

    
    
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

