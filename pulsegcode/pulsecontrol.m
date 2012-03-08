function  pulsecontrol(pulsenumMW,pulsenumRF)
%NVPULSE(pulsenumMW,pulsenumRF) is a function to generate needed pulse sequences
%there are some global variables:
%AHEADT: the time needed before the protected pulse
%ENDT:the time needed after the protected pulse
%LENGTHMAX:the longest length of all input pulse sequences
%the parameter pulsenum means the input pulse sequence number
%needed,it is integer and do not include the supplementary pulse 
%such as the protecting pulse

global LENGTHMAX;
global PULSEDELAY;
global AHEADT;
PULSEDELAY=0;

if nargin ~= 2
    error('should provide two variables:pulsenumMW and pulsenumRF!');
end
if pulsenumMW<1&&pulsenumRF<1
    error('No input pulse at all!');
end
if pulsenumMW>1||pulsenumRF>1
    error('The input MW pulse or RF pulse can only be chosen from 0 and 1! ');
end

%generate pulse sequences and put them into an array
mode=input('Please select mode from T and C\n','s');
pulseaccarray=zeros(pulsenumMW+pulsenumRF,LENGTHMAX);

%pulseMW
if pulsenumMW==1
   x=input('Please input MW pulse sequence according to the mode you selected.\n');
   if mode=='C'
       if x(1)<AHEADT||x(2)==1
           PULSEDELAY=AHEADT;
       end
   end
   if mode=='T'
       if x(1)<AHEADT
          PULSEDELAY=AHEADT; 
       end
   end
   pulseaccarray(pulsenumMW,:)=pulseg(mode,x);    
end

%pulseRF
if pulsenumRF==1
    x=input('Please input RF pulse sequence according to the mode you selected.\n');
     if mode=='C'
       if x(1)<AHEADT||x(2)==1
           PULSEDELAY=AHEADT;
       end
     end
   if mode=='T'
       if x(1)<AHEADT
          PULSEDELAY=AHEADT; 
       end
   end
    pulseaccarray(pulsenumRF+pulsenumMW,:)=pulseg(mode,x);
end

%define a generate pulsearray considering the ahead time of the protecting
%array
pulsegccarray=zeros(pulsenumMW+pulsenumRF,LENGTHMAX+PULSEDELAY);
if PULSEDELAY==0
    pulsegccarray=pulseaccarray;
else
    for j=1:pulsenumMW+pulsenumRF
        for k=1:LENGTHMAX
            pulsegccarray(j,k+PULSEDELAY)=pulseaccarray(j,k);
        end
    end
end

%set the length of pulse sequences after considering the protecting pulse
prolength=length(pulsegp(pulsegccarray(1,:)));
for j=1:pulsenumRF+pulsenumMW
    if prolength<length(pulsegp(pulsegccarray(j,:)))
        prolength=length(pulsegp(pulsegccarray(j,:)));
    end
end

%put all sequences including supplementary ones into an array with the same
%length
pulsesequence=zeros((pulsenumMW+pulsenumRF)*2,prolength);
for j=1:pulsenumMW+pulsenumRF
    for i=1:LENGTHMAX+PULSEDELAY
    pulsesequence(2*j-1,i)=pulsegccarray(j,i);
    end
    for i=1:length(pulsegp(pulsegccarray(j,:)))
    y=pulsegp(pulsegccarray(j,:));
    pulsesequence(2*j,i)=y(i);
    end
end

%cut those sequences into pieces
pulsegcut(pulsesequence);

end

