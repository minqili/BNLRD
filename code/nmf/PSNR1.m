function psnrValue = PSNR1(A,B)
[M,N]=size(B);

F=double(B);
G=double(A(1:M,1:N));

E = F - G; % error signal
mseValue=sum(E(:).^2)/(M*N);

if F==G   
 psnrValue=1000000000;   
else
psnrValue=10*log10(255^2/mseValue);
end
% disp(['MSE of input Image',num2str(mseValue)]);
% disp(['PSNR ',num2str(psnrValue)]);