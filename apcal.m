function [ap,IMPATH] = apcal(score,label,labelvalue,IMPATH)
% ap=apcal(score,label)
% average precision (AP) calculation 
% input: 
%  score - 1xn vector 
%  label - 1xn vector
%  labelvalue - value of true positives in the 'label' vector
% output: ap
if length(score)~=length(label)
    error('score and label must be equal length\n');
    pause;
end

%%%%%%% take all those in the same hash bucket and see the accuracy
M=[];
B=[];
A=[];
SLNO=1:length(score);
A=[score;label;SLNO];

B = sortrows(A.',1).';
% extract the required part
num=0;
for i=1:size(B,2)
    if B(1,i)==0 && B(2,i)==labelvalue
        M(:,i)=B(:,i);
        num=num+1;
    elseif B(1,i)==0
        num=num+1;
    else
        break;
    end
end

% delete all columns with 0 value
M(:,all(M==0,1))=[];

% Recording the path
if size(M,2)==0
    IMPATH.RESULT{labelvalue,1}={};
% elseif size(M,2)<21
%     msize = numel(M(1,:));
%     idx = randperm(msize);
%     dist = M(idx(1:20));
else
    for i=1:size(M,2)
        imnum = mod(M(3,i),100)+1;
        IMPATH.RESULT{labelvalue,i}=showpath(labelvalue,imnum);
    end
end

if num==0
    ap=0;
else
    ap=size(M,2)/num;
end