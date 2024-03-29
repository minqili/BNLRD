function  Theta0 = InitialPara_random(X,K)
if nargin<2
    K=150;
end
[P,N]=size(X);   

%--------Initialize Parameter D,S,Z,Delta,Tao,Pi,gamma_epsi,gamma_s,S2,Z2,Pi2-----------------
D=zeros(P,K);
for k=1:K
%     D(:,k)=randn(P,1)*sqrt(1/P);
    D(:,k)=randn(P,1);
end


S=zeros(K,N);
for n=1:N
    S(:,n)=randn(K,1);
end


Z = zeros(K,1);
Delta = ones(K,1);
Tao = ones(K,1);
Pi = 0.5*ones(K,1);       
% gamma_epsi =  1e3;    
gamma_epsi =  1e3*ones(1,N);  
%sampe sparse component
gamma_s = 1e-3;  % It's used for simulation
%gamma_s = 1;
S2 = randn(P,N);
Z2 = zeros(P,N);
Pi2 = 0.5*ones(P,1);


Theta0.D = D;
Theta0.S = S;
Theta0.Z = Z;
Theta0.Delta = Delta;
Theta0.Tao = Tao;
Theta0.Pi = Pi;
Theta0.gamma_epsi = gamma_epsi;
Theta0.S2 = S2;
Theta0.Z2 = Z2;
Theta0.gamma_s = gamma_s;
Theta0.Pi2 = Pi2;
end