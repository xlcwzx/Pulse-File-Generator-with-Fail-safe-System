function pulsegcut(x)
%PULSEGCUT(x) cuts the pulsegsequence
%the only parameter x is the wanted-cut pulse sequence
%x is a matrix.dimx=h*l 
%this function will write the specific cut pieces into a file named
%pulsepieces

%define needed parameters
[h,l]=size(x);

%line index
xindex=1;

%an array to save the compared line
pulsearray=zeros(1,h);

fid=fopen('pulsepieces.txt','wt');
fprintf(fid,'Channel MW     =1\n');
fprintf(fid,'Channel MW_PROT=2\n');
fprintf(fid,'Channel RF     =3\n');
fprintf(fid,'Channel RF_PROT=4\n');
fprintf(fid,'\n');

%the length of one certain piece
piecerepeat=1;

%compare one line with the next line to find if there is a difference
while xindex<l
for j=1:h
    pulsearray(j)=x(j,xindex);
end
    xindex=xindex+1;
    loop=true;
    for i=1:h
        if pulsearray(i)~=x(i,xindex)
            fprintf(fid,'%d :',piecerepeat);
            for k=1:h
                if pulsearray(k)==0
                    fprintf(fid,'        ');
                else
                  fprintf(fid,channeljudge(k));  
                end
            
            end
            fprintf(fid,'\n');
            piecerepeat=1;
            loop=false;
            break;
       end
    end
    if(loop==true)
        piecerepeat=piecerepeat+1;
    end
end

    %write the result of last line into file
    fprintf(fid,'%d :',piecerepeat);
    for j=1:h
        if x(j,l)==0
        fprintf(fid,'        ');
        else
         fprintf(fid,channeljudge(j)); 
        end
    end

 end



