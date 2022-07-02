%Cafer Selli 2444974
%Zeynep Beril Sahin 2587848
classdef Operation < handle
    properties
        id
        patient
        availableInterval
        scheduledInterval
        duration
        operationDay
        penalty
        room
    end

    methods
        function setScheduledInterval(self,interval)
            self.scheduledInterval = interval;
        end

        function setAvailableInterval(self,interval)
            self.availableInterval = interval;
        end

        function updatePenalty(self,penaltyMultiplier,time)
            self.penalty = (penaltyMultiplier).^(4-self.patient.priority) + time - self.availableInterval.lt;
        end
    end
    
end