%Cafer Selli 2444974
%Zeynep Beril Sahin 2587848
classdef Patient < handle
    properties
        name
        surname
        priority
        day
    end

    methods
        function self = Patient(n,s,p,d)
            self.name = n;
            self.surname = s;
            self.priority = p;
            self.day = d;
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