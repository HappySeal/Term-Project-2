%Cafer Selli 2444974
%Zeynep Beril Sahin 2587848
classdef Interval < handle
% An Interval has a left endpoint and a right endpoint.
    
    properties
       lt
       rt
    end
    
    methods
        function Inter = Interval(lt, rt)
        % Constructor:  construct an Interval object
            Inter.lt= lt;
            Inter.rt= rt;
        end
        
        function w = getWidth(self)
        % Return the width of the Interval
            %%%% %MISSION Write your code below %%%%
            w = self.rt - self.lt;
            
        end
        
        function scale(self, f)
        % Scale self by a factor f
            %%%% %MISSION Write your code below %%%%
            w = self.rt - self.lt;
            self.rt = self.lt + w * f;
                    
        end
        
        function shift(self, s)
        % Shift self by constant s
            %%%% %MISSION Write your code below %%%%
            self.lt = self.lt + s;
            self.rt = self.rt + s;
            
        end
        
        function tf = isIn(self, other)
        % tf is true (1) if self is in the other Interval
            %%%% %MISSION Write your code below %%%%
            tf = self.lt >= other.lt && self.rt <= other.rt;
        
        end

        function tf = isIncludes(self,other)
            tf = self.lt <= other.lt && self.rt >= other.rt;
        end
        
        function Inter = add(self, other)
        % Inter is the new Interval formed by adding self and the 
        % the other Interval
            %%%% %MISSION Write your code below %%%%
            Inter.lt = min(self.lt,other.lt);
            Inter.rt = max(self.rt,other.rt);
            
        end
        
        function disp(self)
        % Display self, if not empty, in this format: (left,right)
        % If empty, display 'Empty <classname>'
            if isempty(self)
                fprintf('Empty %s\n', class(self))
            else
                fprintf('(%d,%d)\n', self.lt, self.rt)
            end
        end

        function inter = overlap(self,other)
            inter= Interval.empty();
            left= max(self.lt, other.lt);
            right= min(self.rt, other.rt);
            if right-left > 0
                inter= Interval(left, right);
            end
        end
        
    end %methods
    
end %classdef