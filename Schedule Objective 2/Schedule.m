%Cafer Selli 2444974
%Zeynep Beril Sahin 2587848
classdef Schedule < handle
    properties
        dailyPlanningHorizon
        planningDays
        numberOfRooms
        finalSchedule
        scheduleMatrix

        penaltyMultiplier = 7

        patients
        operations
    end

    methods

        function self = Schedule(rooms,days,horizon)
            self.dailyPlanningHorizon = horizon;
            self.planningDays = days;
            self.numberOfRooms = rooms;
            self.scheduleMatrix = zeros([rooms,horizon.getWidth(),days]);

        end


        function constructSchedule(self,inputData,inputNames)
            self.scheduleMatrix = zeros([self.numberOfRooms,self.dailyPlanningHorizon.getWidth(),self.planningDays]);

            [len,~] = size(inputData);

            unscheduledPtr = [1:len];
            scheduledPtr = [];

            self.patients = [Patient.empty];
            self.operations = [Operation.empty];
            for i = 1:len
                self.patients(i) = Patient(inputNames(i,1),inputNames(i,2),inputData(i,6),inputData(i,2));
                o = Operation();
                o.id = inputData(i,1);
                o.patient = self.patients(i);
                o.setAvailableInterval(Interval(inputData(i,4),inputData(i,5)));
                o.duration = inputData(i,3);
                self.operations(i) = o;
            end

            for day = 1:self.planningDays
                for room = 1:self.numberOfRooms
                    time = self.dailyPlanningHorizon.lt;
                    while time < self.dailyPlanningHorizon.rt
                        for j = 1:length(unscheduledPtr)
                            self.operations(unscheduledPtr(j)).updatePenalty(self.penaltyMultiplier,time);
                        end

                        ptr = [double.empty];
                        for j = 1:length(unscheduledPtr)
                            if self.patients(unscheduledPtr(j)).day == day && self.operations(unscheduledPtr(j)).availableInterval.isIncludes(Interval(time,time+self.operations(unscheduledPtr(j)).duration))
                                ptr = [ptr unscheduledPtr(j)];
                            end
                        end

                        if isempty(ptr)
                            time = time + 1;
                        else
                            maxPenalty = -inf;
                            maxPenaltyIndex = 0;
                            for j = 1:length(ptr)
                                if self.operations(ptr(j)).penalty > maxPenalty
                                    maxPenalty = self.operations(ptr(j)).penalty;
                                    maxPenaltyIndex = ptr(j);
                                end
                            end
                            self.scheduleMatrix(room,time+1:time+self.operations(maxPenaltyIndex).duration,day) = self.operations(maxPenaltyIndex).id;
                            scheduledPtr = [scheduledPtr self.operations(maxPenaltyIndex).id];
                            self.operations(maxPenaltyIndex).scheduledInterval = Interval(time,time+self.operations(maxPenaltyIndex).duration);
                            self.operations(maxPenaltyIndex).room = room;
                            self.operations(maxPenaltyIndex).operationDay = day;

                            unscheduledPtr = unscheduledPtr(unscheduledPtr ~= maxPenaltyIndex);
                            self.finalSchedule = [ self.finalSchedule self.operations(maxPenaltyIndex)];
                            time = time + self.operations(maxPenaltyIndex).duration;
                        end
                    end
                end

                postponed = [];
                for j = 1:length(unscheduledPtr)
                    if self.patients(unscheduledPtr(j)).day == day && isempty(self.operations(unscheduledPtr(j)).scheduledInterval) && self.patients(unscheduledPtr(j)).priority ~= 0
                        postponed = [postponed unscheduledPtr(j)];
                    end
                end

                if ~isempty(postponed)
                    fprintf("\n[%d]>>>",day);
                    for j = 1:length(postponed)
                        fprintf("[%d,%d]",postponed(j),self.patients(postponed(j)).priority);


                        self.patients(postponed(j)).day = self.patients(postponed(j)).day + 1;
                        self.patients(postponed(j)).priority = 0;
                        self.operations(postponed(j)).setAvailableInterval(Interval(0,self.operations(postponed(j)).duration));
                    end
                end





            end

            fprintf("\nScheduled : %d\n",length(scheduledPtr));
        end

        function printSchedule(self)
            Room_No = [double.empty];
            Available_Interval = ["doajg"];
            Duration = [double.empty];
            Sched_Interval = ["adoijg"];
            Patient_Name = ["asd"];
            Patient_Surname = ["asd"];
            Patient_Priority = [double.empty];
            Operation_Day = [double.empty];

            for i = 1:length(self.finalSchedule)
                Room_No(i) = self.finalSchedule(i).room;
                Available_Interval(i) = sprintf("(%d,%d)",self.finalSchedule(i).availableInterval.lt,self.finalSchedule(i).availableInterval.rt);
                Duration(i) = self.finalSchedule(i).duration;
                Sched_Interval(i) = sprintf("(%d,%d)",self.finalSchedule(i).scheduledInterval.lt,self.finalSchedule(i).scheduledInterval.rt);
                Patient_Name(i) = self.finalSchedule(i).patient.name;
                Patient_Surname(i) = self.finalSchedule(i).patient.surname;
                Patient_Priority(i) = self.finalSchedule(i).patient.priority;
                Operation_Day(i) = self.finalSchedule(i).operationDay;

            end
            Room_No = Room_No';
            Available_Interval = Available_Interval';
            Duration = Duration';
            Sched_Interval = Sched_Interval';
            Patient_Name = Patient_Name';
            Patient_Surname = Patient_Surname';
            Patient_Priority = Patient_Priority';
            Operation_Day = Operation_Day';

            filename = 'patientdata_objective_2.xlsx';
            t = table(Room_No,Available_Interval,Duration,Sched_Interval,Patient_Name,Patient_Surname,Patient_Priority,Operation_Day);
            writetable(t,filename,'Sheet',1,'Range','A1','WriteVariableNames',true);
            disp(t);

            avgUsage = zeros([self.numberOfRooms,self.planningDays]);
            for i = 1:self.numberOfRooms
                for j = 1:self.planningDays
                    avgUsage(i,j) = mean(self.scheduleMatrix(i,:,j) ~= 0);
                end
            end
            avgUsage(:,self.planningDays+1) = mean(avgUsage,1);
            disp(avgUsage);
            self.drawGanttChart();
        end

        function drawGanttChart(self)

            for day = 1:self.planningDays
                subplot(self.planningDays,1,day);
                title(sprintf("Day : %d",day));
                for room = 1:self.numberOfRooms
                    ptr = [double.empty];
                    for j = 1:length(self.finalSchedule)
                        if self.finalSchedule(j).operationDay == day && self.finalSchedule(j).room == room
                            ptr = [ptr j];
                        end
                    end

                    for j = ptr
                        rand('seed',self.finalSchedule(j).id);
                        c = [rand rand rand];

                        rectangle('Position',[self.finalSchedule(j).scheduledInterval.lt,room,self.finalSchedule(j).duration,1],"FaceColor",c,"EdgeColor",[0 0 0 0])
                        text(self.finalSchedule(j).scheduledInterval.lt + self.finalSchedule(j).duration/2,room + 0.5,0,sprintf("OP%d",self.finalSchedule(j).id),HorizontalAlignment="center",Color=c*0.1)
                    end
                end
            end
        end
    end

end