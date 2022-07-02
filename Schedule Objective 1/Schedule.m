%Cafer Selli 2444974
%Zeynep Beril Sahin 2587848
classdef Schedule < handle
    properties
        dailyPlanningHorizon
        planningDays
        numberOfRooms
        finalSchedule
        scheduleMatrix
        occupancyMatrix

        penaltyMultiplier = 0.5;

        patients
        operations
    end

    methods

        function self = Schedule(rooms,days,horizon)
            self.dailyPlanningHorizon = horizon;
            self.planningDays = days;
            self.numberOfRooms = rooms;
            self.scheduleMatrix = zeros([rooms,horizon.getWidth(),days]);
            self.occupancyMatrix = zeros([rooms,horizon.getWidth(),days]);

        end

        %         RECURSIVE APPROACH
        %         function output = scheduleOperation(self,operation)
        %             zone = self.scheduleMatrix(operation.operationDay,:,operation.availableInterval.lt:operation.availableInterval.lt);
        %             for i = 1:self.numberOfRooms
        %                 occupants = unique(zone(:,i,:));
        %                 occupants = occupants(occupants ~=  0);
        %                 if isempty(occupants)
        %                     operation.scheduledInterval = Interval(operation.availableInterval.lt,operation,availableInterval.lt + operation.duration);
        %                 else
        %                     for j = occupants
        %
        %                     end
        %                 end
        %             end



        %         end


        function constructSchedule(self,inputData,inputNames,printDebug)
            [len,~] = size(inputData);

            %             nomberOfScheduled = 0;

            self.patients = [Patient.empty];
            self.operations = [Operation.empty];
            for i = 1:len
                self.patients(i) = Patient(inputNames(i,1),inputNames(i,2),inputData(i,6),inputData(i,2));
                o = Operation();
                o.id = inputData(i,1);
                o.patient = self.patients(i);
                o.availableInterval = Interval(inputData(i,4),inputData(i,5));
                self.occupancyMatrix(:,(inputData(i,4)+1:inputData(i,5)),inputData(i,2)) = self.occupancyMatrix(:,(inputData(i,4)+1:inputData(i,5)),inputData(i,2))+self.penaltyMultiplier^(4 - inputData(i,6));
                o.duration = inputData(i,3);
                self.operations(i) = o;
            end


            for day = 1:self.planningDays
                %                 nomnomberOfUnscheduled = 0;
                for p = 0:4
                    ptr = [double.empty];
                    for i = 1:len
                        if self.patients(i).priority == p && self.patients(i).day == day
                            ptr = [ptr i];
                        end
                    end

                    while ptr
                        index = 0;
                        maxDursun = 0;
                        for i = 1:length(ptr)
                            durations_i = self.operations(ptr(i)).duration;
                            if durations_i > maxDursun
                                maxDursun = durations_i;
                                index = ptr(i);
                            end
                        end
                        %             fprintf("[%d,%d]",index,self.opertations(index).duration);

                        room = 1;
                        unscheduled = 1;

                        minCollision = inf;
                        minCollisionTime = 0;
                        minCollisionRoom = 0;

                        while room <= self.numberOfRooms
                            time = self.operations(index).availableInterval.lt;
                            while time <= self.operations(index).availableInterval.rt - self.operations(index).duration
                                totalCollision = sum(self.occupancyMatrix(room,time+1:time+self.operations(index).duration,day),'all');
                                if totalCollision < minCollision
                                    minCollision = totalCollision;
                                    minCollisionTime = time;
                                    minCollisionRoom = room;
                                end
                                time = time + 1;
                            end
                            room = room + 1;
                        end

                        %                         fprintf("[%d,%d,%d]\n",index,minCollisionRoom,minCollisionTime);
                        if minCollision < inf
                            self.occupancyMatrix(minCollisionRoom,minCollisionTime+1:minCollisionTime+self.operations(index).duration,day) = inf;
                            self.operations(index).scheduledInterval = Interval(minCollisionTime,minCollisionTime+self.operations(index).duration);
                            self.occupancyMatrix(1:self.numberOfRooms,self.operations(index).availableInterval.lt+1:self.operations(index).availableInterval.rt,day) =...
                                self.occupancyMatrix(1:self.numberOfRooms,self.operations(index).availableInterval.lt+1:self.operations(index).availableInterval.rt,day) - self.penaltyMultiplier^(4 - self.patients(index).priority);
                            self.scheduleMatrix(minCollisionRoom,((minCollisionTime+1):(minCollisionTime+self.operations(index).duration)),day) = index;
                            self.operations(index).operationDay = day;
                            self.operations(index).scheduledInterval = Interval(minCollisionTime,minCollisionTime+self.operations(index).duration);
                            self.operations(index).room = minCollisionRoom;

                            self.finalSchedule = [ self.finalSchedule self.operations(index)];
                            unscheduled = 0;
                        else
                            self.occupancyMatrix(1:self.numberOfRooms,self.operations(index).availableInterval.lt+1:self.operations(index).availableInterval.rt,day) =...
                                self.occupancyMatrix(1:self.numberOfRooms,self.operations(index).availableInterval.lt+1:self.operations(index).availableInterval.rt,day) - self.penaltyMultiplier^(4 - self.patients(index).priority);
                            self.patients(index).day = self.patients(index).day+ 1 * (self.patients(index).priority ~= 0) ;
                            self.patients(index).priority = 0;
                            self.operations(index).setAvailableInterval(Interval(0,self.operations(index).duration));

                        end

                        ptr = ptr(ptr ~= index);
                        %                         nomberOfScheduled = nomberOfScheduled + ~unscheduled;
                        %                         if unscheduled && printDebug
                        %                             fprintf("%d,",index);
                        %                         end
                        %                         nomnomberOfUnscheduled = nomnomberOfUnscheduled + unscheduled;
                    end
                    %                     if printDebug
                    %                         fprintf("\n");
                    %                     end
                end
                %                 if printDebug
                %                     fprintf("---DAY:%d | Postponed: %d---\n",day,nomnomberOfUnscheduled);
                %                 end
            end
            %             if printDebug
            %                 disp(nomberOfScheduled);
            %             end
            %             output = nomberOfScheduled;


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

            filename = 'patientdata_objective_1.xlsx';
            t = table(Room_No,Available_Interval,Duration,Sched_Interval,Patient_Name,Patient_Surname,Patient_Priority,Operation_Day);
            writetable(t,filename,'Sheet',1,'Range','A1','WriteVariableNames',true)
            disp(t);
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