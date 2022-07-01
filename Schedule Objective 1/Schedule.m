classdef Schedule < handle
    properties
        dailyPlanningHorizon
        planningDays
        numberOfRooms
        finalSchedule
    end

    methods
        function output = constructSchedule(self,inputData,inputNames)
            [len,~] = size(inputData);
            scheduleMatrix = zeros([3,480,5]);
            
            nomberOfScheduled = 0;
            
            patients = [Patient.empty];
            operations = [Operation.empty];
            for i = 1:len
               patients(i) = Patient(inputNames(i,1),inputNames(i,2),inputData(i,6),inputData(i,2));
               o = Operation();
               o.id = inputData(i,1);
               o.patient = patients(i);
               o.availableInterval = Interval(inputData(i,4),inputData(i,5));
               o.duration = inputData(i,3);
               operations(i) = o;
            end


            for day = 1:self.planningDays       
                nomnomberOfUnscheduled = 0;
                for p = 0:4
                    ptr = [double.empty];
                    for i = 1:len
                        if patients(i).priority == p && patients(i).day == day
                            ptr = [ptr i];
                        end
                    end

                    while ptr
                        index = 0;
                        minFlex = 2;
                        for i = 1:length(ptr)
                            flexibility = operations(ptr(i)).duration / (operations(ptr(i)).availableInterval.getWidth());
                            if flexibility < minFlex
                                minFlex = flexibility;
                                index = ptr(i);
                            end
                        end
        %             fprintf("[%d,%d]",index,operations(index).duration);
                        
                        room = 1;
                        unscheduled = 1;
                        while room <= self.numberOfRooms && unscheduled
                            time = operations(index).availableInterval.lt;
                            while time <= operations(index).availableInterval.rt - operations(index).duration && unscheduled
                                if all(scheduleMatrix(room,(time+1):time+operations(index).duration,day) == 0)
                                    scheduleMatrix(room,((time+1):(time+operations(index).duration)),day) = index;
                                    unscheduled = 0;
                                end
                                time = time + 1;
                            end
                            room = room + 1;
                        end
            
                        if unscheduled && patients(index).priority
                            patients(index).priority = 0;
                            patients(index).day = patients(index).day+1;
                            operations(index).availableInterval.shift(-operations(index).availableInterval.lt);
                        end
            
                        ptr = ptr(ptr ~= index);
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
            disp(nomberOfScheduled);
        end


        function printSchedule(self)

        end
    end

end