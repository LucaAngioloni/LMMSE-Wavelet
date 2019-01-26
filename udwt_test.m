clear all
load ../Immagini/lenna512.mat;
filter_type = 'bior4.4';
%symmetry_type = 'pari';    % per filtri con due campioni centrali di simmetria (es. 'haar', bior3.3, bior1.3, bior1.5)
symmetry_type = 'disp';     % per filtri con un campioni centrali di simmetria (es. bior4.4, bior5.5, bior6.8, ...)
linearphase_flag = 1;
x = lenna512;
nliv = 3;

%
if nliv == 1
    [H1 V1 D1 L1] = udwt_dec(x, 1, filter_type, linearphase_flag);
    RIC = udwt_rec(H1,V1,D1,1,filter_type,linearphase_flag,symmetry_type,L1);
elseif nliv == 2
    [H1 V1 D1] = udwt_dec(x, 1, filter_type, linearphase_flag);
    [H2 V2 D2 L2] = udwt_dec(x, 2, filter_type, linearphase_flag);
    W1 = udwt_rec(H1,V1,D1,1,filter_type,linearphase_flag,symmetry_type);
    W2 = udwt_rec(H2,V2,D2,2,filter_type,linearphase_flag,symmetry_type,L2);
    RIC = W1 + W2;
elseif nliv == 3
    [H1 V1 D1] = udwt_dec(x, 1, filter_type, linearphase_flag);
    [H2 V2 D2] = udwt_dec(x, 2, filter_type, linearphase_flag);
    [H3 V3 D3 L3] = udwt_dec(x, 3, filter_type, linearphase_flag);
    W1 = udwt_rec(H1,V1,D1,1,filter_type,linearphase_flag,symmetry_type);
    W2 = udwt_rec(H2,V2,D2,2,filter_type,linearphase_flag,symmetry_type);
    W3 = udwt_rec(H3,V3,D3,3,filter_type,linearphase_flag,symmetry_type, L3);
    RIC = W1 + W2 + W3;
end

mse=sum(sum(x-RIC).^2)/(numel(x))
PSNR = 10*log10(255^2/mse)
%
figure, imshow(x/255)
figure, imshow(RIC/255)
figure, imshow(abs(RIC-x))
