%
% UDWR undecimated wavelet decomposition
%
% RIC = udwt(H,V,D,L,NLIV,FILTER_TYPE,LINEARPHASE_TYPE)
%
% H, V, D, [L]= horizontal, diagonal, diagonal lowpass wavelets
%   coefficients and approximation
% NLIV = level number
% FILTER_TYPE = wavelet filter type
% LINEARPHASE_TYPE = linear phase flag
%
% RIC = reconstructed image
%
function RIC = udwt_1D_rec( H, nliv, FILTER_TYPE, LINEARPHASE_FLAG, L)

DISPLAY_FLAG = 0;
%
% Inizializzazioni
%
[M N] = size(H);			% Dimensioni immagini
%
%
[Lo_D,Hi_D] = wfilters(FILTER_TYPE,'d');
Lo_D = Lo_D/sqrt(2);
Hi_D = Hi_D/sqrt(2);
[Lo_R,Hi_R] = wfilters(FILTER_TYPE,'r');   % FILTRI di RICOSTRUZIONE
Lo_R = Lo_R/sqrt(2);
Hi_R = Hi_R/sqrt(2);

% calcolo filtro equivalente

for liv = 1:nliv
    lp_eq = 1;
    lp_eq_r = 1;
    for k = 0:liv-2
        lp_eq = conv(Lo_D, upsamp2(lp_eq, 2));
        lp_eq_r = conv(Lo_R, upsamp2(lp_eq_r,2));
    end
    lp_filt = conv(lp_eq, upsamp2(Lo_D, 2^(liv-1)));
    hp_filt = conv(lp_eq, upsamp2(Hi_D, 2^(liv-1)));
    lp_filt_r = conv(lp_eq_r, upsamp2(Lo_R,2^(liv-1)));
    hp_filt_r = conv(lp_eq_r, upsamp2(Hi_R,2^(liv-1)));
    Nlp = size(lp_filt,2);
    Nhp = size(hp_filt,2);
    Nlpr = size(lp_filt_r,2);
    Nhpr = size(hp_filt_r,2);
    
    [maxlp,delay_lowpass] = max(abs(lp_filt));
    [maxlp,delay_highpass] = max(abs(hp_filt));
    delay_lowpass = delay_lowpass - 1;
    delay_highpass = delay_highpass - 1;
end
if DISPLAY_FLAG == 1
    figure(1)
    plot(lp_filt)
    pause
    plot(hp_filt)
    pause
    [Hl W] = freqz(lp_filt,1,512);
    plot(W,abs(Hl))
    pause
    [Hh W] = freqz(hp_filt,1,512);
    plot(W,abs(Hh))
    pause
end


% ricostruisco con wavelet non decimata

H = filtro1dsprt(H, hp_filt_r, Nhp - delay_highpass - 1, LINEARPHASE_FLAG, -1);
RIC = H

if nargin == 5
    L = filtro1dsprt(L, lp_filt_r, Nlp - delay_lowpass - 1, LINEARPHASE_FLAG, 1)
    RIC = RIC + L;
end
% Sommo le sottobande


return