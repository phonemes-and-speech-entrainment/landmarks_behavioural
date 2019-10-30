clearvars;

origmatrix=zeros(73,2);

indices1=[1:3:16,20:3:35];
for i=indices1
    origmatrix(i,:)=[i,i+1];
    origmatrix(i+1,:)=[i,i+2];
    origmatrix(i+2,:)=[i+1,i+2];
end

origmatrix(19,:)=[];

for i=37:54
    origmatrix(i,:)=[i-36,19];
end

for i=55:72
    origmatrix(i,:)=[i-35,38];
end

origmatrix=[origmatrix;[1,10];[2,11];[3,12];[20,29];[21,30];[22,31]];

%save('origmatrix.mat','origmatrix');

    