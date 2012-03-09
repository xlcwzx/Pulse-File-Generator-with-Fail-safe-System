function y=pulseg(mode,x)
% PULSEG£¨MODE,X£©generate pulse sequence, support two modes
% the first parameter is mode,choose from 'T' and 'C'
% the second parameter is 1D numerical array
% the third parameter is the longest length of all input pulse sequences 
% Mode 'T':[starting time, sequence duration]
% Mode 'C':[sequence duration,electric Ping(high:1,low:0)]
% it needs global variables AHEADT and Lengthmax
% LENGTHMAX:the longest length of all input pulse sequences

global LENGTHMAX;
if mode ~= 'T' && mode ~= 'C'
    error(' choose from mode T and C!');
end
if isnumeric(x) == 0
    error('must be a numerical array!');
end
if nargin ~= 2
    error('should provide two variables!');
end
if(mod(length(x),2) ~= 0)
    error('input array must have an even number of elements!');
end

if mode == 'T'


%check the time order   
for k=2:length(x)/2
    if x(2*k-1) < x(2*k-3)
        error('time order must be ascending!');
    end
end

%check if the sequence is overlapped
for k=2:length(x)/2
    if x(2*k-1) <= (x(2*k-3) + x(2*k-2) - 1)
        error('Overlap!');
    end
end

%define output array
y=zeros(1,LENGTHMAX);

%set the output 1 as the electric Ping is high
for k = 1:length(x)/2
    for j = 1:x(2*k)
        y(x(2*k-1) + j) = 1;
    end
end

%set the last output 0 if the sequence is not the longest
if x(length(x)-1)+x(length(x))<LENGTHMAX
    for i=x(length(x)-1)+x(length(x))+1:LENGTHMAX
        y(i)=0;
    end
end

elseif mode == 'C'
    
    
    %check the effectiveness of given electric Ping
    for k = 1:length(x)/2
        if x(2*k) ~= 0 && x(2*k) ~= 1
            error('must provided 0 or 1!');
        end
    end
    
    %define output array
    y = zeros(1,LENGTHMAX);
   
    %set the last output 0 if the sequence is not the longest 
    sum = 0;
    for k = 1:length(x)/2
        sum = sum + x(2*k-1);
    end
   if sum<LENGTHMAX
      for i=sum+1:LENGTHMAX
        y(i)=0;
      end
  end
    
    %set output 1 according to the electric Ping
    sumx = 0;
    for k=1:length(x)/2
        for j=1:x(2*k-1)
            y(sumx + j) = x(2*k);
        end
        sumx = sumx + x(2*k-1);
    end 

end




    
    