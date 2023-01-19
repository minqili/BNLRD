function Z_ = parallel_sample_NMF_Z(Z,k,X,A,sigma_X,W,Pi)
Z_ = Z;
N = size(X,2);
Z_(k,:) = 1;  
C=W.*Z_ ;
if Pi==-1
   log_p1 = parallel_log_sparse_PX( X ,A, W, Z_, sigma_X,k);
else
    log_p1 =log(Pi(k))+ parallel_log_sparse_PX( X ,A, W, Z_, sigma_X,k);
end

mm=sum(Z)-Z(k,:);
log_p1 = log( mm./N) + log_p1;
Z_(k,:) = 0;
C=W.*Z_ ;
log_p0 = parallel_log_sparse_PX( X ,A, W, Z_, sigma_X,k);
mm=sum(Z)-Z(k,:);
log_p0 = log( 1 - mm./sum(Z) ) + log_p0;
proba1 = 1./( 1 + exp([ log_p0 - log_p1 ]));

Z_(k,:) = binornd(1,proba1);

end


