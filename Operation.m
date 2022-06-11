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
        %setAvailableInterval - Description
        %
        % Syntax: setAvailableInterval(input)
        %
        % Long description
            self.availableInterval = interval;
        end
    end
    
end