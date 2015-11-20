clear;
% To normalise the data
load('RefSamplesSIFT.mat')
load('RefSamplesLabelsSIFT.mat')

% for i=1:size(RefSamplesSIFT,1)
%     RefSamplesSIFT(i,:)=RefSamplesSIFT(i,:)./norm(RefSamplesSIFT(i,:));
% end

format long
X=mean(RefSamplesSIFT);
for i=1:size(RefSamplesSIFT,1)
    RefSamplesSIFT(i,:)=RefSamplesSIFT(i,:)-X;
end

count=1;
testim_no=1;
for j=[1 6 7 8 9 10]
    
    MNIST_trndata=[];
    MNIST_trnlabel=[];
    MNIST_tstdata=[];
    MNIST_tstlabel=[];
    MNIST_vaddata=[];
    MNIST_vadlabel=[];


    for i=1:21
        t_strt=2;
        t_end =5;
        RSS = RefSamplesSIFT(((i-1)*100+1):((i-1)*100+100),:);
        RSS = RSS(1:end ~=j,:);
        MNIST_trndata=[MNIST_trndata; RSS];
        RSLS = RefSamplesLabelsSIFT(:,((i-1)*100+1):((i-1)*100+100));
        RSLS = RSLS(1:end ~=j);
        MNIST_trnlabel=[MNIST_trnlabel RSLS];
        MNIST_tstdata=[MNIST_tstdata; RefSamplesSIFT(((i-1)*100+j),:)];
        MNIST_tstlabel=[MNIST_tstlabel RefSamplesLabelsSIFT(:,((i-1)*100+j))];
        IMPATH.TESTIMAGE{i,testim_no}=showpath(i,j);

        MNIST_vaddata=[MNIST_vaddata; [RefSamplesSIFT(((i-1)*100+t_strt):((i-1)*100+t_end),:); RefSamplesSIFT(((i-1)*100+j),:)]];
        MNIST_vadlabel=[MNIST_vadlabel [RefSamplesLabelsSIFT(:,((i-1)*100+t_strt):((i-1)*100+t_end)) RefSamplesLabelsSIFT(:,((i-1)*100+j))]];
    end

    C_tstlabel=mat2cell(MNIST_tstlabel, 1, repmat(1,21,1));
    C_tstdata=mat2cell(MNIST_tstdata, repmat(1,21,1), 250);

    path(path,'S3PLH');
    path(path,'SH');

    nbits_set=[24];
    MNIST_vadd=MNIST_vaddata;
    MNIST_vadl=MNIST_vadlabel;

    for i=1:21
        MNIST_tstdata=C_tstdata{i,1};
        MNIST_tstlabel=C_tstlabel{1,i};

    %     % Irrelevant Class
        MNIST_vaddata_C=MNIST_vaddata([1:5:end],:);
        MNIST_vaddata_C(i,:)=[];
        MNIST_vadlabel_C=MNIST_vadlabel(:, [1:5:end]);
        MNIST_vadlabel_C(:,i)=[];

    %     % Relevant Class
        MNIST_vaddata_M=MNIST_vaddata([(i-1)*5+1:(i-1)*5+5], :);
        MNIST_vadlabel_M=MNIST_vadlabel(:, [(i-1)*5+1:(i-1)*5+5]);


        MNIST_vaddata=[MNIST_vaddata_C;MNIST_vaddata_M];
        MNIST_vadlabel=[MNIST_vadlabel_C MNIST_vadlabel_M];


        SR_M=zeros(length(MNIST_vadlabel));

        for isr=1:length(MNIST_vadlabel)
            for jsr=1:length(MNIST_vadlabel)
                if MNIST_vadlabel(:,isr)==MNIST_vadlabel(:,jsr) && isr~=jsr
                    SR_M(isr,jsr)=1;
                elseif isr==jsr
                    SR_M(isr,jsr)=0;
                else
                    SR_M(isr,jsr)=-1;
                end
            end
        end

        for ii=1:length(nbits_set)    
            nbits=nbits_set(ii);  
            SPLHparam.nbits=nbits;
            SPLHparam.eta=0.0683;
            [SPLH_eva_info{ii},IMPATH] = evaluate_SPLH_MNIST(MNIST_trndata,MNIST_trnlabel,MNIST_tstdata,MNIST_tstlabel,MNIST_vaddata,SR_M,SPLHparam,IMPATH);
            AP_SPLH(ii)=SPLH_eva_info{ii}.AP;
        end
        perf(i,count)=AP_SPLH; 
        MNIST_vaddata=MNIST_vadd;
        MNIST_vadlabel=MNIST_vadl;
    end
    count=count+1;
    clc;j
%     RES(testim_no)=struct(IMPATH);
    testim_no=testim_no+1;
end

perf_mean=mean(perf');
bar (perf_mean)
set(gca,'XTick',[1:21]) 
set(gca,'XTickLabel',{'beach', 'agricultural', 'buildings', 'forest', 'river', 'harbor', 'denseresi', 'sparseresi', 'freeway', 'airplane', 'baseball',...
    'chaparral', 'golfcourse', 'mobilehome', 'intersection', 'mediumresi', 'overpass', 'parkinglot', 'runway', 'storagetanks', 'tenniscourt'})