function [A,Z,statsMCMC,W]=parallel_inference_NMF(X,chains,dd,varargin)
% =========================================
% In this script  X=A*B   X=A*(W@Z)

[d1 d2]=size(X);
trace_plots = false;

fix_K=1;
if dd==0
    fix_K=0;
    dd=90;
    K_new=2;
end

% =================================
% Initialization
A=rand(d1,dd);
% Z=randint(dd,d2,2);
Z=randi([0 1],dd,d2);
W=rand(dd,d2);
sigma=1;
sigma_proposal_alpha =  0.000001;
alpha0=sigma_proposal_alpha;

a=zeros(size(X));
beta=zeros(size(X));

P_max=-1e20;

statsMCMC.PZX = -1e+10;
statsMCMC.K = 0;
statsMCMC.sigma_A = 1;
statsMCMC.sigma_X = 1;
statsMCMC.alpha = 0.000001;

N=size(X,2);   
Pi=SamplePi(Z,N,2,1);
B=W.*Z;

for mcmc_i = 1:chains
% =================================
% sample A                
%     Z0=Z;
    B=W.*Z;
    if mcmc_i<1000
            C = double(B)*double(B');
            D = X*double(B');
            N0=K_active(B');
         for n = 1:K_active(Z') % FOR ALL ACTIVE FEATURES           
                    nn = [1:n-1 n+1:N0];
                    A(:,n) = randr((D(:,n)-A(:,nn)*C(nn,n))/C(n,n), ...
                        sigma/C(n,n), a(:,n));   %ref Michael
         end
     end
%    Z=Z0;

% =================================
%%  parallel sample Z when fix K

%      for i = 1:N %FOR ALL EXAMPLES
       if fix_K==1
            for k = 1:K_active(Z') 
%                 if m_(i,k,Z') > 0    
%                     if fix_K==1
                        Z = parallel_sample_NMF_Z(Z,k,X,A,sigma,W,-1);   
%                     else
%                         Z = parallel_sample_NMF_Z(Z,k,X,A,sigma,W,Pi); 
%                         aa=010
%                     end
%                 else
%                     Z(k,i) = 0;
%                 end
            end
            test_Z =  sum(sum(Z));
            Z3=Z;  %  Z = cleanZ(Z');   %2021
            Z=Z';
            Z=logical(Z'); 
            if  size(Z,1)~=size(Z3,1)
                stop=2
            end

            B=W.*Z;
            B3=B;           
            B = cleanZ(B'); 
            B=logical(B'); 
            if  size(B,1)~=size(B3,1)
                stop=3
            end
            test_B=  sum(sum(B));
       end
%===========================================
%% Sample B

    B=W.*Z;

    E = A'*A;
    F = A'*X;
    N1=size(Z,1);
    for n = 1:N1
            zz1=find(Z(n,:)==1);
            W0=W;
            B=Z.*W;
            nn = [1:n-1 n+1:N1];
            mu=( F(n,:)-(E(n,nn)*B(nn,:)) )'/E(n,n);      
            W(n,:) = randr(mu, ...
                sigma/E(n,n), beta(n,:)');
            W0(n,zz1)=W(n,zz1);
            W=W0;

            zz0=find(Z(n,:)==0);
            W0=W;
            W(n,zz0)=exprnd(0.0001,1,size(zz0,2));
            W0(n,zz0)=W(n,zz0);
            W=W0;
                    
    end

        
% ===========================================
%% Sample SIGMA_X            
   C0 = double(Z.*W)*double((W.*Z)');
   D0 = X*double((W.*Z)');          
   sigma = 1;%NMF_sampleSigmaX_lin(X,A,0,C0,D0,B);
   

%%===========================================
% Metropolis sample of a
%     alpha0 = NMF_sampleAlpha(alpha0, sigma_proposal_alpha, Z');
    alpha0=0.000001;

    img_V2=A*(W.*Z);
    psnrValue_bayesian = PSNR1(X,img_V2);
    Value_l0=sum(Z(:)~=0);

    sparse_sum=0;
    H=W.*Z;
    for i0=1:size(H,1)
    Q=H(i0,:);
    sparse_sum=sparse_sum+ (  sqrt(size(H,2))-norm(Q, 1)/ norm(Q,2)  )/ ( sqrt(size(H,2))-1 );
    end
    sparseness=sparse_sum/size(H,1);

    statsMCMC.PZX(mcmc_i+1) =log_sparse_PX( X ,A, W.*Z ,sigma);
    statsMCMC.K(mcmc_i+1) = K_active(Z');
    statsMCMC.alpha(mcmc_i+1) = alpha0;
    statsMCMC.sigma_X(mcmc_i+1) = sigma;
    statsMCMC.sumZ(mcmc_i+1) = sum(sum(Z));

    if P_max<statsMCMC.PZX(mcmc_i+1)
        P_max=statsMCMC.PZX(mcmc_i+1);
        statsMCMC.A = [];
        statsMCMC.Z = [];
        statsMCMC.W= [];
        statsMCMC.A = A;
        statsMCMC.Z = Z;
        statsMCMC.W= W;
        statsMCMC.mcmc_max=mcmc_i;   
    end
     
    statsMCMC.PSNR(mcmc_i+1) =psnrValue_bayesian;
    statsMCMC.Residual(mcmc_i+1) =norm((X-A*(W.*Z)),'fro')/norm(X,'fro');
    statsMCMC.Value_l0(mcmc_i+1) =Value_l0;
    statsMCMC.sparseness(mcmc_i+1) =sparseness;

    if trace_plots == 10
        figure(2);
        subplot(4,1,1);
        plot(statsMCMC.PZX,'black','LineWidth',2);
        axis([0 200 -1e09 -100]);
        ylabel('log p(X)');

        subplot(4,1,2);
        plot(statsMCMC.Residual,'black','LineWidth',2);
        axis([0 200 0 6]);
        ylabel('Residual');

        subplot(4,1,3);
        plot(statsMCMC.sparseness,'black','LineWidth',2);
        axis([0 200 0 1]);
        ylabel('Sparseness ');       
        
        subplot(4,1,4);
        plot(statsMCMC.K,'black','LineWidth',2);
        axis([0 200 0 100]);
        ylabel('K');
        xlabel('Iteration');

        pause(0.001);
        drawnow;
    end
       
end
        

%=======================================
function x = randr(m, s, l)
% RANDR Random numbers from 
%   p(x)=K*exp(-(x-m)^2/s-l'x), x>=0 
% Usage
%   x = randr(m,s,l)
A = (l.*s-m)./(sqrt(2*s));
a = A>26;
x = zeros(size(m));
y = rand(size(m));
x(a) = -log(y(a))./((l(a).*s-m(a))./s);

R = erfc(abs(A(~a)));
x(~a) = erfcinv(y(~a).*R-(A(~a)<0).*(2*y(~a)+R-2)).*sqrt(2*s)+m(~a)-l(~a).*s;

x(isnan(x)) = 0;
x(x<0) = 0;
x(isinf(x)) = 0;
x = real(x);