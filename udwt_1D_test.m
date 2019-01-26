clear all
filter_type = 'bior1.1';
linearphase_flag = 1;
x =1:40;

%
% [H1 L1] = udwt_1D_dec(x, 1, filter_type, linearphase_flag);
% RIC = udwt_1D_rec(H1,1,filter_type,linearphase_flag,L1);

[H1 L1] = udwt_1D_dec(x, 1, filter_type, linearphase_flag);
[H2 L2] = udwt_1D_dec(x, 2, filter_type, linearphase_flag);
W1 = udwt_1D_rec(H1,1,filter_type,linearphase_flag);
W2 = udwt_1D_rec(H2,2,filter_type,linearphase_flag,L2);
RIC = W1+W2;
% %
mse=sum(sum(x-RIC).^2)/(numel(x))
PSNR = 10*log10(255^2/mse)

