function lp = parallel_log_sparse_PX( X,A,W,Z,sigma_X,k )
% lp = -trace( (X-A*Z)'*(X-A*Z) )/(2*sigma_X^2) - ...
%     (N*D/2)*log(2*pi*sigma_X^2);

    B=W.*Z;
    E = A'*A;
    F = A'*X;
    N1=size(Z,1);
    N2=size(Z,2);
    n=k;
    nn = [1:n-1 n+1:N1];
    mu=( (F(n,:)-E(n,nn)*B(nn,:)) )'/E(n,n);  
    sigma=sigma_X/E(n,n);  

%             lp=-1/(2*sigma_X^2)* (Z(n,:)-mu').*(Z(n,:)-mu') - (N1/2)*log(2*pi*sigma_X^2);
    L1=1/(2*sigma_X^2);
    L2=(Z(n,:)-mu').*(Z(n,:)-mu'); 
    L3=(N2/2)*log(2*pi*sigma^2);
    lp=-L1*L2-L3;


