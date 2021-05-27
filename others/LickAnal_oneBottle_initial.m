function [Results]=LickAnal_oneBottle(directory,filename)
    Results=[];
    filename=horzcat(directory,filename,'.txt');
    T =readtable(filename);
    select=T{:,2};

    countA=length(find(strcmp(select,'LickA')));
    countB=length(find(strcmp(select,'LickB')));

    time=T{:,3};
%     A_id=strcmp(select,'LickA');
    B_id=strcmp(select,'LickB');

%     LickA=zeros(1,time(end));
    LickB=zeros(1,time(end));

%     Atime=time(A_id);
    Btime=time(B_id);


    diffBtime=diff(Btime);
    endB=find(diffBtime>1000);
    Bduration=[];
    B_IBI=[];
    BLickperBout=[];
    if(isempty(endB))
        Bduration(1,1) = Btime(end)-Btime(1);
    else
         Bduration(1,1)=Btime(endB(1))-Btime(1);
    end
    
    Bduration(1,1)=Btime(endB(1))-Btime(1);
    for i=2:1:length(endB)
        if endB(i)>endB(i-1)+1
            Bduration(i,1)=Btime(endB(i))-Btime(endB(i-1)+1);  
            BLickperBout(i,1)=(endB(i)-endB(i-1))/Bduration(i,1)*1000;
        end

    end
    meanB=mean(Bduration(find(Bduration~=0)));
    Bfreq=length(Bduration(find(Bduration~=0)));
    BSpeed=mean(BLickperBout(find(BLickperBout~=0)));
    
    B_IBI=mean(diffBtime(find(diffBtime>1000)))/1000;
    B_ILI=mean(diffBtime(find(diffBtime<1000)))/1000;
    tmp = Bduration(find(Bduration~=0));
    meanInitial = mean(tmp(1:3))
   
    
    h=1;
%     Results(h,1) = meanA/1000;
    Results(h,2) = meanB/1000;
%     Results(h,3) = Afreq;
    Results(h,4) = Bfreq;
%     Results(h,5) = ASpeed;
    Results(h,6) = BSpeed;
%     Results(h,7) = A_IBI;
    Results(h,8) = B_IBI;
%     Results(h,9) = A_ILI;
    Results(h,10)= B_ILI;
    Results(h,11)= meanInitial;

    
    
end