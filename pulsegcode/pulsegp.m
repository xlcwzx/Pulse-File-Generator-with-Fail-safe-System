function y=pulsegp(x)
%PULSEGP(x) is a function to generate the protecting pulse sequence
%the only parameter means the protected pulse
%%it needs two global variable: AHEADT means the specific time ahead of the protected pulse 
%sequence; ENDT means the specific time delayed after the protected pulse sequence is ended 

global AHEADT;
global ENDT;
if isnumeric(x) == 0
    error('must be a numerical array!');
end
if nargin ~= 1
    error('should provide one variable!');
end
if(mod(AHEADT,1) ~= 0)
    error('the specific time ahead of the protected pulse has to be an integer!');
end
if(mod(ENDT,1) ~= 0)
    error('the specific time delayed  has to be an integer!');
end

%set the length of protecting pulse
indexdes=length(x);
while indexdes>0
     if(x(indexdes)==0)
         indexdes=indexdes-1;
     else
         break;
     end
end
if indexdes+ENDT>=length(x)
    plength=indexdes+ENDT;
else
    plength=length(x);
end

%set the protecting pulse array
y = zeros(1,plength);

index=1;
%index's final destination is right to the last high electric Ping 
while index~=indexdes+1
    
    %set the starting point of the protecting pulse
    if x(index)~=0
       if index-1<AHEADT
            for j=1:index
                y(j)=1;
            end
        end
       if index-1>=AHEADT
           for j=index-AHEADT:index
               y(j)=1;
           end
       end
   
 
    %set the protecting pulse as the protected pulse continues
    while x(index)==1
        y(index)=1;
       if(index<length(x))
        index=index+1;
        
       elseif(index==length(x))
            index=length(x)+1;
            y(length(x))=1;
            break;
        end
    end
    
    %set the protecting pulse after the protected pulse
    for k=index:index+ENDT-1
        y(k)=1;
    end
     else
        index=index+1;
    end
 end
end
   



