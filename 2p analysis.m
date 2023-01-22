%%
% active cell list from python code
% Data_1 : SO, Data_2 : SA of the first mouse,/ Data_3: SO, Data_4; SA of
% the second mouse ... : 5 mice total

Data_1=[]
Data_2=[]
Data_3=[]
Data_4=[]
Data_5=[]
Data_6=[]
Data_7=[]
Data_8=[]
Data_9=[]
Data_10=[]

% firstLick, bef, aft should be in frame (hz)
% timepoint of stimuli (lick, infusion .. ) in each mice
firstlicks=[]


bef = 5*60*2;
aft = 5*60*11;

%% get Z-score from the responses of each mice & align to the first lick
% draw heatmap plot of stimulus 1 (eg. SO), stimulus 2 (eg.SA)
% you can draw calcium trace of individual cells (ex Fig 3C) by manually picking the
% cell and command like this.

% caclium_trace = zscore_1(i); %i is the index of the selected cells
% figure; plot(caclium_trace);

firstLicks=floor(firstlicks*5);

[zscore_1,zscore_norm_1] = zscoredraw(Data_1,bef,firstLicks(1));
zscore_aligned_1 = alignFirstLick(zscore_1,firstLicks(1),bef,aft);

[zscore_2,zscore_norm_2] = zscoredraw(Data_2,bef,firstLicks(2));
zscore_aligned_2 = alignFirstLick(zscore_2,firstLicks(2),bef,aft);

[zscore_3,zscore_norm_3] = zscoredraw(Data_3,bef,firstLicks(3));
zscore_aligned_3 = alignFirstLick(zscore_3,firstLicks(3),bef,aft);

[zscore_4,zscore_norm_4] = zscoredraw(Data_4,bef,firstLicks(4));
zscore_aligned_4 = alignFirstLick(zscore_4,firstLicks(4),bef,aft);

[zscore_5,zscore_norm_5] = zscoredraw(Data_5,bef,firstLicks(5));
zscore_aligned_5 = alignFirstLick(zscore_5,firstLicks(5),bef,aft);

[zscore_6,zscore_norm_6] = zscoredraw(Data_6,bef,firstLicks(6));
zscore_aligned_6 = alignFirstLick(zscore_6,firstLicks(6),bef,aft);

[zscore_7,zscore_norm_7] = zscoredraw(Data_7,bef,firstLicks(7));
zscore_aligned_7 = alignFirstLick(zscore_7,firstLicks(7),bef,aft);

[zscore_8,zscore_norm_8] = zscoredraw(Data_8,bef,firstLicks(8));
zscore_aligned_8 = alignFirstLick(zscore_8,firstLicks(8),bef,aft);

[zscore_9,zscore_norm_9] = zscoredraw(Data_9,bef,firstLicks(9));
zscore_aligned_9 = alignFirstLick(zscore_9,firstLicks(9),bef,aft);

[zscore_10,zscore_norm_10] = zscoredraw(Data_10,bef,firstLicks(10));
zscore_aligned_10 = alignFirstLick(zscore_10,firstLicks(10),bef,aft);


Data_SO = [zscore_aligned_1; zscore_aligned_3; zscore_aligned_5; zscore_aligned_7; zscore_aligned_9];
Data_SA = [zscore_aligned_2; zscore_aligned_4; zscore_aligned_6; zscore_aligned_8; zscore_aligned_10];


drawHM_aligned(Data_SO,'zscore',bef,aft);
title('Dglu');

drawHM_aligned(Data_SA,'zscore',bef,aft);
title('Lipid');


%% sort by average & draw heatmap ex) Fig S3C
zscore_avg_1 = mean(Data_SO(:,bef+1:end),2);
zscore_avg_2 = mean(Data_SA(:,bef+1:end),2);

[XXX,ii]=sortrows(zscore_avg_1,'Ascend');
r(ii) = 1:length(ii);

     
empty_1 = zeros(size(Data_SO));
empty_2 = zeros(size(Data_SO));


for j=1:size(Data_SO,1)
    sorted_ind = r(j);
    cell_1 = Data_SO(j,:);
    empty_1(sorted_ind,:)=cell_1;
    
     cell_2 = Data_SA(j,:);
    empty_2(sorted_ind,:)=cell_2;
end
drawHM_aligned(empty_1,'zscore',bef,aft);
title('Fasted D glucose');
drawHM_aligned(empty_2,'zscore',bef,aft);
title('Fasted Protein');


%% divide into k means & draw each heatmap and pie graph; ex) Fig 3B, 3D
sortKmeans_multi_eval(Data_SA,Data_SO,bef,aft);


%% divide according to response to two stimuli; Fig 3G
% clust 1 : data1 inh and data2 activated
% clust2 : data1 inh and data2 not act
% clust 3: data 1 not inh and data2 act
% clust 4: data1 not inh and data2 not act

[data1_clust1,data1_clust2, data1_clust3, data1_clust4,data2_clust1,data2_clust2, data2_clust3, data2_clust4 ] = getResponsiveSort(Data_SO,Data_SA,bef);
data1_mean1 = data1_clust1(bef:bef+10*5*60);

%% tuning preference curve; ex) Fig 3J
tuningPreference(Data_SO,Data_SA,bef);
ylabel('Percent of cells (%)');


comparison=[]
comp_SO=[]
comp_SA=[]
for x=1:size(Data_SO,1)
    rowcell = Data_SO(x,:);
    baseline = rowcell(1:bef);
    res = rowcell(bef+1:aft);
    mu = mean(baseline);
    sig = std(baseline);
    meanZ = mean((res-mu)/sig);
   
     rowcell_SA = Data_SA(x,:);
    baseline_SA = rowcell_SA(1:bef);
    res_SA = rowcell_SA(bef+1:aft);
    mu_SA = mean(baseline_SA);
    sig_SA = std(baseline_SA);
    meanZ_SA = mean((res_SA-mu_SA)/sig_SA);
       comp_SO=[comp_SO; meanZ];
    comp_SA=[comp_SA; meanZ_SA];

    comp = [meanZ meanZ_SA];
    comparison=[comparison; comp];
end
figure;
x = comp_SO;
y = comp_SA;
inh_idx =  find(x<-1);

x=x(inh_idx);
y=y(inh_idx);
X = [ones(length(x),1) x];

b = X\y;
yCalc2 = X*b;
figure;

plot(x,yCalc2,'--')
hold on;
scatter(comp_SO,comp_SA,'k');
hold on;
scatter(x,y,'red')

 xlabel("sucrose");
 ylabel("sucralose");



%% divide by average reponse to two different stimuli; ex) Fig S3A
SO_inh=[]
SO_act=[]
SO_nores=[]

SO_inh_match=[]
SO_act_match=[]
SO_nores_match=[]

SA_inh=[]
SA_act=[]
SA_nores=[]

for c = 1:size(Data_SO,1)
    cell = Data_SO(c,:);
    cell_match = Data_SA(c,:);
    res = cell(bef:end);
    res_mean = mean(res);
    if(res_mean<-1)
        SO_inh=[SO_inh;cell];
        SO_inh_match=[SO_inh_match;cell_match];
        
    elseif(res_mean>1)
       SO_act=[SO_act;cell];
       SO_act_match=[SO_act_match;cell_match];
 
    else
        SO_nores=[SO_nores;cell];
        SO_nores_match=[SO_nores_match;cell_match];

    end
end

 


for c = 1:size(Data_SA,1)
    cell = Data_SA(c,:);
    res = cell(bef:end);
    res_mean = mean(res);
    if(res_mean<-2)
        SA_inh=[SA_inh;cell];
    elseif(res_mean>2)
       SA_act=[SA_act;cell];
    else
        SA_nores=[SA_nores;cell];
    end
end

inh_color = [0/255 86/255 191/255];
act_color = [255/255, 73/255, 56/255];
no_res_color = [0.5 0.5 0.5];
figure;
avgplot(SO_inh,inh_color,bef)
avgplot(SO_act,act_color,bef)
avgplot(SO_nores,no_res_color,bef)

avgplot(SO_inh_match,inh_color,bef)
avgplot(SO_act_match,act_color,bef)
avgplot(SO_nores_match,no_res_color,bef)

avgplot(SA_inh,inh_color,bef)
avgplot(SA_act,act_color,bef)
avgplot(SA_nores,no_res_color,bef)

drawpie(SO_act,SO_inh,SO_nores);
drawpie(SA_act,SA_inh,SA_nores);

avgplot(Data_SO,no_res_color,bef)
avgplot(Data_SA,no_res_color,bef)



%% draw pie chart from data 1; ex) Fig 3E
[ses1_act, ses1_inh, ses1_nores] = getResponsive(Data_SO,bef);
if(length(ses1_act))
    avgplot(ses1_act,act_color,bef)
end
if(length(ses1_inh))
    avgplot(ses1_inh,inh_color,bef)
end
if(length(ses1_nores))
    avgplot(ses1_nores,no_res_color,bef)
end
drawpie(ses1_act,ses1_inh,ses1_nores);





%% draw pie chart from data 2; ex) Fig 3E

[ses2_act, ses2_inh, ses2_nores] = getResponsive(empty_2,bef);
if(length(ses2_act))
    avgplot(ses2_act,act_color,bef)
end
if(length(ses2_inh))
    avgplot(ses2_inh,inh_color,bef)
end
if(length(ses2_nores))
    avgplot(ses2_nores,no_res_color,bef)
end

drawpie(ses2_act,ses2_inh,ses2_nores);




%% scatter plot of response of each cell to two stimuli; ex) Fig 3F
comparison=[]
comp_1=[];
comp_2=[];

comp_1_inh=[];
comp_1_inh_2=[];
comp_2_act=[];
comp_2_act_1=[];
biphasic_1=[];
biphasic_2=[];

for x=1:size(empty_1,1)
    rowcell = empty_1(x,:);
    baseline = rowcell(1:bef);
    res = rowcell(bef:end);
%     mu = mean(baseline);
%     sig = std(baseline);
%     meanZ = mean((res-mu)/sig);
        meanZ = mean(res);

     rowcell_2 = empty_2(x,:);
    baseline_2 = rowcell_2(1:bef);
    res_2 = rowcell_2(aft-60*5:aft);
    mu_2 = mean(baseline_2);
    sig_2 = std(baseline_2);
    meanZ_2 = mean((res_2-mu_2)/sig_2);
            meanZ_2 = mean(res_2);

            
   if(meanZ<-1 & meanZ_2>1)
       biphasic_1=[biphasic_1; meanZ];
       biphasic_2=[biphasic_2; meanZ_2];
   
   elseif(meanZ<-1)
       comp_1_inh=[comp_1_inh; meanZ];
       comp_1_inh_2=[comp_1_inh_2; meanZ_2];
   
  elseif(meanZ_2>1)
       comp_2_act=[comp_2_act; meanZ_2];
       comp_2_act_1=[comp_2_act_1; meanZ];
   else
   comp_1=[comp_1; meanZ];
    comp_2=[comp_2; meanZ_2];
   end

    comp = [meanZ meanZ_2];
    comparison=[comparison; comp];
end
figure;
 scatter(comp_1,comp_2,'o','MarkerEdgeColor',[64, 64, 64]/255); hold on;
 scatter(comp_1_inh,comp_1_inh_2,'filled','MarkerFaceColor',[49, 96, 235]/255); hold on;
 scatter(comp_2_act_1,comp_2_act,'filled','MarkerFaceColor',[227, 102, 102]/255); hold on;
 scatter(biphasic_1,biphasic_2,'filled','MarkerFaceColor',[0, 173, 58]/255); hold on;
legend("other","D glu inh ","Lipid glu act ","biphasic");
 

 xlabel("fasted D glucose ");
 ylabel("fasted L glucose ");
 line([-5 5],[1 1],'Color','k','LineStyle','--')
line([-1 -1],[-10 30],'Color','k','LineStyle','--')



xlim([-5 5])
ylim([-5 15])


 line([-10 10],[0 0],'Color','k','LineStyle','-')
line([0 0],[-10 30],'Color','k','LineStyle','-')


line([-10 10],[10 -10],'Color','r','LineStyle','-')



 x = comp_1;
 y = comp_2;
  
mdl = fitlm(x,y)
mdl.Rsquared.Ordinary



%% SVM-decoder time bin; ex) Fig 3H
window = 5;
accuracies=[];
acc1 = svmDecoderTimebin(zscore_aligned_1,zscore_aligned_2,window);
accuracies=[accuracies acc1];
acc2 = svmDecoderTimebin(zscore_aligned_3,zscore_aligned_4,window);
accuracies=[accuracies acc2];
acc3 = svmDecoderTimebin(zscore_aligned_5,zscore_aligned_6,window);
accuracies=[accuracies acc3];
acc4 = svmDecoderTimebin(zscore_aligned_7,zscore_aligned_8,window);
accuracies=[accuracies acc4];
acc5 = svmDecoderTimebin(zscore_aligned_9,zscore_aligned_10,window);
accuracies=[accuracies acc5];


shuffle_accuracies=[];
shuffle_acc1 = svmDecoderTimebinShuffle(zscore_aligned_1,zscore_aligned_2,window);
shuffle_accuracies=[shuffle_accuracies shuffle_acc1];
shuffle_acc2 = svmDecoderTimebinShuffle(zscore_aligned_3,zscore_aligned_4,window);
shuffle_accuracies=[shuffle_accuracies shuffle_acc2];
shuffle_acc3 = svmDecoderTimebinShuffle(zscore_aligned_5,zscore_aligned_6,window);
shuffle_accuracies=[shuffle_accuracies shuffle_acc3];
shuffle_acc4 = svmDecoderTimebinShuffle(zscore_aligned_7,zscore_aligned_8,window);
shuffle_accuracies=[shuffle_accuracies shuffle_acc4];
shuffle_acc5 = svmDecoderTimebinShuffle(zscore_aligned_9,zscore_aligned_10,window);
shuffle_accuracies=[shuffle_accuracies shuffle_acc5];


avgplot(accuracies',[14 84 165]/255,bef)
ylabel('accuracy')
title('Dglu-Lipid decoder accuracy');
hold on;
avgplot_2(shuffle_accuracies',[0.5 0.5 0.5],bef)
ylabel('accuracy')
xticks([0:12:156]);
xticklabels(num2cell([-2:1:11]));
title('Dglu-Lglu decoder shuffle accuracy');
legend('Dglu vs Lglu','shuffled');
ylim([30 100]);

%% SVM decoder without specific k-means clusters; ex) Fig 3I

acc_clust1 = svmDecoderTimebin_clust_wo(zscore_aligned_1,zscore_aligned_2,bef,window);
acc_clust2 = svmDecoderTimebin_clust_wo(zscore_aligned_3,zscore_aligned_4,bef,window);
acc_clust3 = svmDecoderTimebin_clust_wo(zscore_aligned_5,zscore_aligned_6,bef,window);
acc_clust4 = svmDecoderTimebin_clust_wo(zscore_aligned_7,zscore_aligned_8,bef,window);
acc_clust5 = svmDecoderTimebin_clust_wo(zscore_aligned_9,zscore_aligned_10,bef,window);
acc_clusters = [acc_clust1; acc_clust2; acc_clust3; acc_clust4; acc_clust5];

acc_all1 = svmDecoderTimebin(zscore_aligned_1,zscore_aligned_2,window);
acc_all2 = svmDecoderTimebin(zscore_aligned_3,zscore_aligned_4,window);
acc_all3 = svmDecoderTimebin(zscore_aligned_5,zscore_aligned_6,window);
acc_all4 = svmDecoderTimebin(zscore_aligned_7,zscore_aligned_8,window);
acc_all5 = svmDecoderTimebin(zscore_aligned_9,zscore_aligned_10,window);
acc_all = [mean(acc_all1); mean(acc_all2); mean(acc_all3); mean(acc_all4); mean(acc_all5)];


