clearvars;
load('origmatrix.mat');
files=dir('*.csv');

finalmatrix=origmatrix;

for i=2:13
    fileID=fopen(files(i).name);
    orderedlog=get_ranks(fileID);
    tocheck=orderedlog(:,1:2);
    if isequal(origmatrix,tocheck)
        toadd=orderedlog(:,3:8);
        finalmatrix=[finalmatrix,toadd];
    else
        fprintf('Wrong pairs for subject %d',i);
    end
end

%matrix_disrupted=finalmatrix;
%save('group2_matrix.mat','matrix_disrupted');

save('matrix_all.mat','finalmatrix');
