classdef Patient < handle
    properties
        name
        surname
        priority
        day
    end

    methods
        function self = Patient(n,s,p)
            self.name = n;
            self.surname = s;
            self.priority = p;
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