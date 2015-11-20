function [evaluation_info,IMPATH]=evaluate_SPLH_MNIST(MNIST_trndata,MNIST_trnlabel,MNIST_tstdata,MNIST_tstlabel,MNIST_vaddata,SR_M,SPLHparam,IMPATH)


tmp_T=cputime;
SPLHparam = trainSPLH(double(MNIST_trndata), SPLHparam,double(MNIST_vaddata'),SR_M);
%%% Training Time
traintime=cputime-tmp_T;
evaluation_info.trainT=traintime;

tmp_T=cputime;
[npoint,ndim,nbat] = size(MNIST_trndata);  
%%% Compression Time
[B_trn, U_trn] = compressSPLH(double(MNIST_trndata), SPLHparam);
[B_tst, U_tst] = compressSPLH(double(MNIST_tstdata), SPLHparam);
compressiontime=cputime-tmp_T;
evaluation_info.compressT=compressiontime;

% B_trn=U_trn;
% B_tst=U_tst;

%for n=1:100
for n = 1:length(MNIST_tstlabel)
    % compute your distance    
    D_code = hammingDist(B_tst(n,:),B_trn);
    check=D_code';
    % get groundtruth sorting
    D_truth =MNIST_trnlabel;
    
%     %%%%%%%% MY PRECISION CALCULATION %%%%%%%%%%
%     
%     [check,INDEX]=sort(check);
%     x=0;
%     p=0;
%     for i=1:100
%         if ((MNIST_tstlabel(n)-1)*100+1)<=INDEX(i) && INDEX(i)<=((MNIST_tstlabel(n)-1)*100+100)
%             x=x+1;
%             p=p+x/i;
%         end
%     end
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     evaluation
    [p, r, apM, ahd,ap, ph2,IMPATH] = prcal_MNIST(D_code,D_truth,MNIST_tstlabel(n),IMPATH);
    precision(n,:)=p;
    recall(n,:)=r;   
    ar_all(n,:)=apM;
    ahd_all(n,:)=ahd;
    ap_all(n)=ap;
    ph2_all(n)=ph2;
end
evaluation_info.recall=mean(recall);
evaluation_info.precision=mean(precision);
evaluation_info.AR=mean(ar_all);
evaluation_info.AHD=mean(ahd_all);
evaluation_info.AP=mean(ap_all);
evaluation_info.PH2=mean(ph2_all);
evaluation_info.SPLHparam=SPLHparam;