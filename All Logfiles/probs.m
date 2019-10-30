clearvars;
load('group1_matrix.mat');
%load('group2_matrix.mat');
%load('matrix_all.mat');

countmatrix=zeros(size(matrix_notice,1),4);
countmatrix(:,1:2)=matrix_notice(:,1:2);
count1=0;
count2=0;


for i=1:length(matrix_notice)
    for j=3:size(matrix_notice,2)
        if matrix_notice(i,j)==matrix_notice(i,1)
            count1=count1+1;
        elseif matrix_notice(i,j)==matrix_notice(i,2)
            count2=count2+1;
        end
    end
    countmatrix(i,3)=count1;
    countmatrix(i,4)=count2;
    count1=0;
    count2=0;
end

probmatrix=zeros(size(countmatrix));
probmatrix(:,1:2)=countmatrix(:,1:2);

for i=1:length(probmatrix)
    probmatrix(i,3)=binopdf(countmatrix(i,3),36,0.5);
    probmatrix(i,4)=binopdf(countmatrix(i,4),36,0.5);
end
%}


%{
countmatrix=zeros(size(matrix_disrupted,1),4);
countmatrix(:,1:2)=matrix_disrupted(:,1:2);

for i=1:length(matrix_disrupted)
    for j=3:size(matrix_disrupted,2)
        if matrix_disrupted(i,j)==matrix_disrupted(i,1)
            count1=count1+1;
        elseif matrix_disrupted(i,j)==matrix_disrupted(i,2)
            count2=count2+1;
        end
    end
    countmatrix(i,3)=count1;
    countmatrix(i,4)=count2;
    count1=0;
    count2=0;
end

probmatrix=zeros(size(countmatrix));
probmatrix(:,1:2)=countmatrix(:,1:2);

for i=1:length(probmatrix)
    probmatrix(i,3)=binopdf(countmatrix(i,3),36,0.5);
    probmatrix(i,4)=binopdf(countmatrix(i,4),36,0.5);
end
%}

%{
countmatrix=zeros(size(finalmatrix,1),4);
countmatrix(:,1:2)=finalmatrix(:,1:2);

for i=1:length(finalmatrix)
    for j=3:size(finalmatrix,2)
        if finalmatrix(i,j)==finalmatrix(i,1)
            count1=count1+1;
        elseif finalmatrix(i,j)==finalmatrix(i,2)
            count2=count2+1;
        end
    end
    countmatrix(i,3)=count1;
    countmatrix(i,4)=count2;
    count1=0;
    count2=0;
end

probmatrix=zeros(size(countmatrix));
probmatrix(:,1:2)=countmatrix(:,1:2);

for i=1:length(probmatrix)
    probmatrix(i,3)=binopdf(countmatrix(i,3),72,0.5);
    probmatrix(i,4)=binopdf(countmatrix(i,4),72,0.5);
end
%}


figure('Renderer', 'painters', 'Position', [10 10 600 550]);
subplot(2,2,1);
bardata1 = [countmatrix(1,3);countmatrix(3,3);countmatrix(2,4)];
b1 = bar(diag(bardata1),0.6,'stacked');
set(b1(2),'FaceColor',[0.30, 0.75, 0.93]);%blue
set(b1(3),'FaceColor',[0.70, 0.25, 1]);   %purple
set(b1(1),'FaceColor',[0.47, 0.67, 0.19]);%green
mysigstar(gca,[0.9 1.1],bardata1(1) + 0.9,probmatrix(1,3));
mysigstar(gca,[1.9 2.1],bardata1(2) + 0.9,probmatrix(3,3));
mysigstar(gca,[2.9 3.1],bardata1(3) + 0.9,probmatrix(2,4));
axis([0 4 0 36]);
xticks([1 2 3]);
xticklabels({'O:C','C:M','M:O'});
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
xlabel('Pairs','FontSize',13);
ylabel('Probability of success','FontSize',13);
yline(18,'-.','LineWidth',1);
%title('"Disrupted" Group: Da Click 0.4');
%saveas(gcf,'disrupted_da_click.bmp');
title('Da Click 0.4','FontSize',14);
set(gca,'linewidth',1);
%saveas(gcf,'noticeable_da_click.bmp');

subplot(2,2,2);
bardata2 = [countmatrix(10,3);countmatrix(12,3);countmatrix(11,4)];
b2 = bar(diag(bardata2),0.6,'stacked');
set(b2(2),'FaceColor',[0.30, 0.75, 0.93]);
set(b2(3),'FaceColor',[0.70, 0.25, 1]);
set(b2(1),'FaceColor',[0.47, 0.67, 0.19]);
mysigstar(gca,[0.9 1.1],bardata2(1) + 0.9,probmatrix(10,3));
mysigstar(gca,[1.9 2.1],bardata2(2) + 0.9,probmatrix(12,3));
mysigstar(gca,[2.9 3.1],bardata2(3) + 0.9,probmatrix(11,4));
axis([0 4 0 36]);
xticks([1 2 3]);
xticklabels({'O:C','C:M','M:O'});
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
xlabel('Pairs','FontSize',13);
ylabel('Probability of success','FontSize',13);
yline(18,'-.','LineWidth',1);
%title('"Disrupted" Group: Da White Noise 45 dB');
%saveas(gcf,'disrupted_da_wn.bmp');
title('Da White Noise 45 dB','FontSize',14);
set(gca,'linewidth',1);
%saveas(gcf,'noticeable_da_wn.bmp');

subplot(2,2,3);
bardata3 = [countmatrix(19,3);countmatrix(21,3);countmatrix(20,4)];
b3 = bar(diag(bardata3),0.6,'stacked');
set(b3(2),'FaceColor',[0.30, 0.75, 0.93]);
set(b3(3),'FaceColor',[0.70, 0.25, 1]);
set(b3(1),'FaceColor',[0.47, 0.67, 0.19]);
mysigstar(gca,[0.9 1.1],bardata3(1) + 0.9,probmatrix(19,3));
mysigstar(gca,[1.9 2.1],bardata3(2) + 0.9,probmatrix(21,3));
mysigstar(gca,[2.9 3.1],bardata3(3) + 0.9,probmatrix(20,4));
axis([0 4 0 36]);
xticks([1 2 3]);
xticklabels({'O:C','C:M','M:O'});
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
xlabel('Pairs','FontSize',13);
ylabel('Probability of success','FontSize',13);
yline(18,'-.','LineWidth',1);
%title('"Disrupted" Group: Ta Click 0.4');
%saveas(gcf,'disrupted_ta_click.bmp');
title('Ta Click 0.4','FontSize',14);
set(gca,'linewidth',1);
%saveas(gcf,'noticeable_ta_click.bmp');

subplot(2,2,4);
bardata4 = [countmatrix(28,3);countmatrix(30,3);countmatrix(29,4)];
b4 = bar(diag(bardata4),0.6,'stacked');
set(b4(2),'FaceColor',[0.30, 0.75, 0.93]);
set(b4(3),'FaceColor',[0.70, 0.25, 1]);
set(b4(1),'FaceColor',[0.47, 0.67, 0.19]);
mysigstar(gca,[0.9 1.1],bardata4(1) + 0.9,probmatrix(28,3));
mysigstar(gca,[1.9 2.1],bardata4(2) + 0.9,probmatrix(30,3));
mysigstar(gca,[2.9 3.1],bardata4(3) + 0.9,probmatrix(29,4));
axis([0 4 0 36]);
xticks([1 2 3]);
xticklabels({'O:C','C:M','M:O'});
vec_pos = get(get(gca, 'XLabel'), 'Position');
set(get(gca, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
xlabel('Pairs','FontSize',13);
ylabel('Probability of success','FontSize',13);
yline(18,'-.','LineWidth',1);
%title('"Disrupted" Group: Ta White Noise 45 dB');
%saveas(gcf,'disrupted_ta_wn.bmp');
title('Ta White Noise 45 dB','FontSize',14);
set(gca,'linewidth',1);

sgtitle('"Noticeable Noise" Group','FontSize',15,'FontWeight','bold');
%saveas(gcf,'noticeable_ta_wn.bmp');
%}

