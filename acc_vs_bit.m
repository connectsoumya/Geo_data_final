clear;
% To normalise the data
load('RefSamplesSIFT.mat')
load('RefSamplesLabelsSIFT.mat')

format long

X=mean(RefSamplesSIFT);
for i=1:size(RefSamplesSIFT,1)
    RefSamplesSIFT(i,:)=RefSamplesSIFT(i,:)-X;
end

% for i=1:size(RefSamplesSIFT,1)
%     RefSamplesSIFT(i,:)=RefSamplesSIFT(i,:)./sum(RefSamplesSIFT(i,:));
% end

count=1;
testim_no=1;
ip_image_no = 6:5:100;%[41 56 67 78 89 90];
for j = ip_image_no
    
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
        IMPATH.TESTIMAGE{i,1}=showpath(i,j);

        MNIST_vaddata=[MNIST_vaddata; [RefSamplesSIFT(((i-1)*100+t_strt):((i-1)*100+t_end),:); RefSamplesSIFT(((i-1)*100+j),:)]];
        MNIST_vadlabel=[MNIST_vadlabel [RefSamplesLabelsSIFT(:,((i-1)*100+t_strt):((i-1)*100+t_end)) RefSamplesLabelsSIFT(:,((i-1)*100+j))]];
    end

    C_tstlabel=mat2cell(MNIST_tstlabel, 1, repmat(1,21,1));
    C_tstdata=mat2cell(MNIST_tstdata, repmat(1,21,1), 150);

    path(path,'S3PLH');
    path(path,'SH');

    nbits_set=[24];
    MNIST_vadd=MNIST_vaddata;
    MNIST_vadl=MNIST_vadlabel;
    
    i_row = 1;
    for i=[2 4 12]
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
        i_cell=1;
        for ii=1:length(nbits_set)    
            nbits=nbits_set(ii);  
            SPLHparam.nbits=nbits;
            SPLHparam.eta=0.0683;
            [SPLH_eva_info{ii},IMPATH] = evaluate_SPLH_MNIST(MNIST_trndata,MNIST_trnlabel,MNIST_tstdata,MNIST_tstlabel,MNIST_vaddata,SR_M,SPLHparam,IMPATH);
            AP_SPLH(ii)=SPLH_eva_info{ii}.AP;
            perf{i_cell}(i_row,count)=AP_SPLH(i_cell);
            i_cell = i_cell+1;
        end
        
        MNIST_vaddata=MNIST_vadd;
        MNIST_vadlabel=MNIST_vadl;
        i_row=i_row+1;
    end
    count=count+1;
    clc;j
    RES(testim_no)=struct(IMPATH);
    testim_no=testim_no+1;
end
save RES RES
for i=1:length(perf)
    perf_mean=mean(perf{i}');
    subplot(1,length(perf),i)
    bar (perf_mean)
    set(gca,'XTick',[1:3]) 
    set(gca,'XTickLabel',{'agricultural', 'forest', 'chaparral'})
end