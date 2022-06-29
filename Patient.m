classdef Patient < handle
    properties
        name
        surname
        priority
        avalibleInterval %avalible hours of the patient
        day
        duration %duration of the patient's operation
    end

    methods
        function self = Patient(n,s,d,p,I,dur)
            self.name = n;
            self.surname = s;
            self.priority = p;
            self.day = d;
            self.avalibleInterval = I;
            self.duration = dur;
        end

        function p = getPatientPriority(self)
            p = self.priority;
        end
        function setPatientPriority(self,p)
            self.priority = p;
        end

        function d = getPatientDay(self)
            d = self.day;
        end
        function setPatientDay(self,d)
            self.day = d;
        end
        
    end
end