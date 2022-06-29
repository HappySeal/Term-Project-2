clear
clc
close all;

numericData = readmatrix("InputData.xlsx");
numericData = numericData(:,1:8 ~= 2 & 1:8 ~=3);
nameSurnameData = readmatrix("InputData.xlsx","Range","B:C","OutputType","string");
nameSurnameData = nameSurnameData(2:98,:);

numericData(:,7) =  (numericData(:,5) - numericData(:,4))./(numericData(:,3));

scheduledPtr = [];
scheduleMatrix = zeros([3,480,5]);

bussinessMatrix = zeros([1,480]);


% for day = 1:5
%     ptr = numericData(numericData(:,2) == day);
%     for index = 1:length(ptr)
%         i = ptr(index);
%         bussinessMatrix(day,(numericData(i,4)+1):numericData(i,5)) = bussinessMatrix(day,(numericData(i,4)+1):numericData(i,5)) + 1;
%     end
% end

for day = 1:5
    ptr = numericData(numericData(:,2) == day);
    ptr = sortrows(numericData(ptr,:),[6,7]);
    ptr = ptr(:,1);

    for index = 1:length(ptr)
        i = ptr(index);
        bussinessMatrix((numericData(i,4)+1):numericData(i,5)) = bussinessMatrix((numericData(i,4)+1):numericData(i,5)) + 1;
    end

    for index = 1:length(ptr)
        i = ptr(index);
        startTime = numericData(i,4)+1;
        minCollision = inf;
        for time = numericData(i,4)+1 : numericData(i,5)-numericData(i,3)
            totalCollision = sum(bussinessMatrix(time:time+numericData(i,3)));
            if totalCollision < minCollision
                minCollision = totalCollision;
                startTime = time;
            end
        end

        fprintf("[%2d,%3d,%3d]\n",i,minCollision,startTime);
        rand('seed',i);
        rectangle(Position=[startTime 0 numericData(i,3) 1],FaceColor=[rand rand rand],EdgeColor=[0 0 0 0]);
%         bussinessMatrix((numericData(i,4)+1):numericData(i,5)) = bussinessMatrix((numericData(i,4)+1):numericData(i,5)) - 1;


    end
    break
end
            

