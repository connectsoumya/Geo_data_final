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

% RefSamplesSIFT=zscore(RefSamplesSIFT);
MNIST_trndata=[];
MNIST_trnlabel=[];
MNIST_tstdata=[];
MNIST_tstlabel=[];
MNIST_vaddata=[];
MNIST_vadlabel=[];

%%% Normalisation
% for i=1:2100
%     RefSamplesSIFT(i,:)=RefSamplesSIFT(i,:)./sum(RefSamplesSIFT(i,:));
% end

for i=1:size(RefSamplesSIFT,1)
    RefSamplesSIFT(i,:)=RefSamplesSIFT(i,:)./norm(RefSamplesSIFT(i,:));
end
%%%

for i=1:21
    t_strt=21;
    t_end =25;
    MNIST_trndata=[MNIST_trndata; RefSamplesSIFT(((i-1)*100+1):((i-1)*100+80),:)];
    MNIST_trnlabel=[MNIST_trnlabel RefSamplesLabelsSIFT(:,((i-1)*100+1):((i-1)*100+80))];

    MNIST_tstdata=[MNIST_tstdata; [RefSamplesSIFT(((i-1)*100+1):((i-1)*100+8),:); RefSamplesSIFT(((i-1)*100+25):((i-1)*100+26),:); ...
        RefSamplesSIFT(((i-1)*100+41):((i-1)*100+48),:); RefSamplesSIFT(((i-1)*100+65):((i-1)*100+66),:)]];
    MNIST_tstlabel=[MNIST_tstlabel [RefSamplesLabelsSIFT(:,((i-1)*100+1):((i-1)*100+8)) RefSamplesLabelsSIFT(:,((i-1)*100+25):((i-1)*100+26)) ...
        RefSamplesLabelsSIFT(:,((i-1)*100+41):((i-1)*100+48)) RefSamplesLabelsSIFT(:,((i-1)*100+65):((i-1)*100+66))]];

%     MNIST_tstdata=[MNIST_tstdata; RefSamplesSIFT(((i-1)*100+81):((i-1)*100+100),:)];
%     MNIST_tstlabel=[MNIST_tstlabel RefSamplesLabelsSIFT(:,((i-1)*100+81):((i-1)*100+100))];
    
    MNIST_vaddata=[MNIST_vaddata; RefSamplesSIFT(((i-1)*100+t_strt):((i-1)*100+t_end),:)];
    MNIST_vadlabel=[MNIST_vadlabel RefSamplesLabelsSIFT(:,((i-1)*100+t_strt):((i-1)*100+t_end))];
end
    
% MNIST_vaddata=[RefSamplesSIFT(15:50:end,:); RefSamplesSIFT(35:50:end,:); RefSamplesSIFT(55:50:end,:); RefSamplesSIFT(75:50:end,:); RefSamplesSIFT(95:50:end,:)];
% MNIST_vadlabel=[RefSamplesLabelsSIFT(:,15:50:end) RefSamplesLabelsSIFT(:,35:50:end) RefSamplesLabelsSIFT(:,55:50:end) RefSamplesLabelsSIFT(:,75:50:end) RefSamplesLabelsSIFT(:,95:50:end)];

SR_M=zeros(length(MNIST_vadlabel));

for i=1:length(MNIST_vadlabel)
    for j=1:length(MNIST_vadlabel)
    if MNIST_vadlabel(:,i)==MNIST_vadlabel(:,j) && i~=j
        SR_M(i,j)=1;
    elseif i==j
        SR_M(i,j)=0;
    else
        SR_M(i,j)=-1;
    end
    end
end

C_tstlabel=mat2cell(MNIST_tstlabel, 1, repmat(20,21,1));
C_tstdata=mat2cell(MNIST_tstdata, repmat(20,21,1), 250);

%  save MNIST_gnd_release2 MNIST_trndata MNIST_tstdata MNIST_vaddata MNIST_trnlabel MNIST_tstlabel MNIST_vadlabel SR_M
 save MNIST_gnd_release MNIST_trndata C_tstdata MNIST_vaddata MNIST_trnlabel C_tstlabel MNIST_vadlabel SR_M