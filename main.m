clear
clc

data = readcell("InputData.xlsx");
[n,m] = size(data);
data = data(2:n,:);

p = [Patient.empty];
inter = [Interval.empty];


for i = 1:n-1
    r = data(i,:);
    p(i) = Patient(r{2:4},r{8});
    inter(i) = Interval(r{6:7});
end

g = [Patient.empty];
for i = 1:n-1
    if p(i).day == 1
        g = [g p(i)];
    end
end



