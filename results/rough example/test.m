X= [1 2;
    3 4;
    4 3;
    2 4;
    3 2;
    2 3;
    1 4]';

Xl=[1 5;
     2 3;
     2 4]';
 
 S=[0 1 -1;
    1 0 -1;
    -1 -1 0];

W1=[1 0]';
W2=[0 1]';
W3=[0 -1]';
W4=[-1 0]';

W=[W1 W2 W3 W4];

M=Xl*S*Xl'+X*X';

JW=trace(W'*M*W)

beta=6.7823;
alpha=1/beta;

for k=1:4
    M=Xl*S*Xl'+X*X';
    [e,e2] = PCA(M);
    W(:,k)=e(:,1);
    
    Sk=Xl'*W(:,k)*W(:,k)'*Xl;
    for i=1:3
        for j=1:3
            if S(i,j)*Sk(i,j)<0
                T(i,j)=Sk(i,j);
            else
                T(i,j)=0;
            end
        end
    end
    
    S=S-alpha*T
    X=X-W(:,k)*W(:,k)'*X;
end

% JW=trace(W'*M*W);
% plot(X(1,:),X(2,:),'o');
% axes