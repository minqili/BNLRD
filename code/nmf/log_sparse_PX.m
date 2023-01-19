function lp = log_sparse_PX( X,A,Z,sigma_X )
N = size(Z,2);
D = size(X,1);
lp = -trace( (X-A*Z)'*(X-A*Z) )/(2*sigma_X^2) - ...
    (N*D/2)*log(2*pi*sigma_X^2);

end

