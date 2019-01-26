clear all

% Parametri della decomposizione wavelet non decimata
filter_type = 'bior4.4';
%filter_type = 'db4';
%symmetry_type = 'pari';    % per filtri con due campioni centrali di simmetria (es. 'haar', bior3.3, bior1.3, bior1.5)
symmetry_type = 'disp';     % per filtri con un campione centrale di simmetria (es. bior4.4, bior5.5, bior6.8, ...)
linearphase_flag = 1;       % flag = 1 per bior 4.4, 0 per db4
nliv = 5;

passo_mean = 7; %Passo per la finestra nella media di g^2

Looks = 4;

sigma = 0.52227/sqrt(Looks);
sig2_u = sigma^2;

% Lettura immagine
%original = imread('../Immagini/05f35a6a-2c42-4f6a-9bad-a5f500ebe9eb.00.jpg');
%original = imread('barbara.png');
original = imread('05f35a6a-2c42-4f6a-9bad-a5f500ebe9eb.00.jpg');
%original = imread('../Clean Test Images/lena.png');
original = original(:,:,1); %Rendo immagine bianco e nero (1 Channel)
original = cast(original, 'double');

% Aggiunta speckle artificiale
%g = sqrt(speckleNoise(original.^2,Looks));
g = original;

% Inizializzo la variabile con immagine ricostruita finale
RIC = zeros(size(g));

G = mediaG2(g,passo_mean); %Media di g^2

for liv = 1:nliv
    
    % Analisi del segnale di livello liv
    if liv < nliv
        [H, V, D] = udwt_dec(g, liv, filter_type, linearphase_flag);
    else
        [H, V, D, L] = udwt_dec(g, liv, filter_type, linearphase_flag);
    end
    
    % Qui va inserita la parte di elaborazione dei segnali dettaglio (per
    % esempio denoising mediante un metodo di stima)
    
    passo_coefficienti = 9+2*liv; % Parte da 11 e sale di 2 ogni livello
    
    H_mean = mediaG2(H,passo_coefficienti);
    V_mean = mediaG2(V,passo_coefficienti);
    D_mean = mediaG2(D,passo_coefficienti);
    
    [H_vtilde, V_vtilde, D_vtilde] = v2tilde(g, liv, G, sig2_u, filter_type, linearphase_flag);
    
    H_diff = H_mean - H_vtilde;
    V_diff = V_mean - V_vtilde;
    D_diff = D_mean - D_vtilde;
    
    H_clean = ((H_diff) > 0) .* H_diff .* H ./H_mean;
    V_clean = ((V_diff) > 0) .* V_diff .* V ./V_mean;
    D_clean = ((D_diff) > 0) .* D_diff .* D ./D_mean;
    
    % Sintesi del segnale di livello liv
    if liv < nliv
        W = udwt_rec(H_clean, V_clean, D_clean, liv, filter_type, linearphase_flag, symmetry_type);
    else
        W = udwt_rec(H_clean, V_clean, D_clean, liv, filter_type, linearphase_flag, symmetry_type, L);
    end
    
    % Sommo al segnale finale il segnale ricostruito al livello liv
    RIC = RIC + W;
    
end

mse = sum(sum(original-RIC).^2)/(numel(original))
PSNR = 20*log10(255^2/mse)

snr = mean(mean(original ./ (original-RIC)))

figure, imshow(original/255)
figure, imshow(g/255)
figure, imshow(RIC/255)
%figure, imshow(abs(RIC-g))

figure;
subplot(1,2,1);
imagesc(g); colormap gray; axis off;
title('Noisy Image');
subplot(1,2,2);
imagesc(RIC); colormap gray; axis off;
title('Denoised Image');
