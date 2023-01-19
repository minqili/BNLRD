function Pi = SamplePi(Z,N,a0,b0)
a0=10*N;
b0=10*N;
sumZ = full(sum(Z,1)');
K=size(Z,1);
Pi = betarnd(sumZ+a0/K, b0*(K-1)/K+N-sumZ);
end