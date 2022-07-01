classdef Operation < handle
    properties
        id
        patient
        availableInterval
        scheduledInterval
        duration
        operationDay
    end

    methods
        function setScheduledInterval(self,interval)
            self.scheduledInterval = interval;
        end

        function setAvailableInterval(self,interval)
            self.availableInterval = interval;
        end
    end
    
end