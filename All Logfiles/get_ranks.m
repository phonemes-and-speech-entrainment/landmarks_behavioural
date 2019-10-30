function orderedlog=get_ranks(fileID)
%fileID=fopen('p_1_logfile.csv');
textscan(fileID,'%D%D','Delimiter',',');
C2=textscan(fileID,'%s%s%s','Delimiter',',');

firststim=C2{1,1};
firststim=firststim(4:end);
firststim=cellfun(@str2double,firststim);
secondstim=C2{1,2};
secondstim=secondstim(4:end);
secondstim=cellfun(@str2double,secondstim);
response=C2{1,3};
response=response(4:end);
response=cellfun(@str2double,response);
logmatrix=[firststim,secondstim,response];

%change "1" or "2" with description of the stimulus
newlogmatrix=logmatrix;
for i=1:length(newlogmatrix)
    if newlogmatrix(i,3)>2
        y=num2str(newlogmatrix(i,3));
        out=str2double(y(1));
        newlogmatrix(i,3)=out;
    end
    if newlogmatrix(i,3)==1
        newlogmatrix(i,3)=newlogmatrix(i,1);
    end
    if newlogmatrix(i,3)==2
        newlogmatrix(i,3)=newlogmatrix(i,2);
    end
end

%rewrite counterbalanced pairs as regular ones
newlog=newlogmatrix;

for i=2:length(newlog)
    if newlog(i,1)>newlog(i,2)
        a=newlog(i,1);
        b=newlog(i,2);
        newlog(i,1)=b;
        newlog(i,2)=a;
    end
end

%order by first column
[~,ind]=sort(newlog,1);
indcol=ind(:,1);
newlog2=newlog(indcol,:);

%order each row with the same element in the first column by second colum
oldi=1;
for i=2:length(newlog2)
    if newlog2(i-1,1)~=newlog2(i,1)
        tocut=newlog2(oldi:i-1,:);
        [~,inds]=sort(tocut,1);
        indcol2=inds(:,2);
        c = tocut(indcol2,:);
        newlog2(oldi:i-1,:)=c;
        oldi=i;
    end
end

%sort last rows of matrix with the same element in the first column by second column
tocut=newlog2(oldi:length(newlog2),:);
[~,inds]=sort(tocut,1);
indcol2=inds(:,2);
c = tocut(indcol2,:);
newlog2(oldi:length(newlog),:)=c;
      
%write responses for the same pairs in one row only
newlog3=zeros(1,8);
newlog3(1,1:3)=newlog2(1,:);

inew=1;
count=0;

for i=2:length(newlog2)
    if newlog2(i-1,2)~=newlog2(i,2)
        inew=inew+1;
        newlog3(inew,1:3)=newlog2(i,:);
        count=0;
    elseif newlog2(i-1,1)~=newlog2(i,1) && newlog2(i-1,2)==newlog2(i,2)
        inew=inew+1;
        newlog3(inew,1:3)=newlog2(i,:);
        count=0;
    else
        count=count+1;
        if count==1
            newlog3(inew,4)=newlog2(i,3);
        elseif count==2
            newlog3(inew,5)=newlog2(i,3);
        elseif count==3
            newlog3(inew,6)=newlog2(i,3);
        elseif count==4
            newlog3(inew,7)=newlog2(i,3);
        elseif count==5
            newlog3(inew,8)=newlog2(i,3);
        end
    end
end

%move controls towards the bottom of the matrix
[row,~]=find(newlog3(:,2)==19 | newlog3(:,2)==38);

controls=newlog3(row,:);
newlog3(row,:)=[];
newlog4=[newlog3;controls];

%move comparisons between white noise and click after controls

[row2,~]=find((newlog4(:,1)==1 & newlog4(:,2)==10)| (newlog4(:,1)==2 & newlog4(:,2)==11) |...
                 (newlog4(:,1)==3 & newlog4(:,2)==12)| (newlog4(:,1)==20 & newlog4(:,2)==29) |...
                 (newlog4(:,1)==21 & newlog4(:,2)==30)| (newlog4(:,1)==22 & newlog4(:,2)==31));
             
wnclick=newlog4(row2,:);
newlog4(row2,:)=[];
orderedlog=[newlog4;wnclick];


