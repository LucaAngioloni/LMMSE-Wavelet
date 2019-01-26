% original = imread('../Clean Test Images/lena.png');
original = imread('05f35a6a-2c42-4f6a-9bad-a5f500ebe9eb.00.jpg');
original = original(:,:,1); %Rendo immagine bianco e nero (1 Channel)
original = cast(original, 'double');

% noisy = sqrt(speckleNoise(original.^2,Looks));
noisy = original;

lognoisy = zeros(size(noisy));

for i=1:size(original,1)
    for j=1:size(original,2)
        if noisy(i,j) <= 0
            lognoisy(i,j) = 0;
        else
            lognoisy(i,j) = log(noisy(i,j));
        end
    end
end

%wname = 'bior3.5';
wname = 'bior4.4';
level = 1;
[C,S] = wavedec2(lognoisy,level,wname);


type1 = 'heursure';
type2 = 'penalhi';
thr = wthrmngr('dw2ddenoLVL',type2,C,S,3);
sorh = 's';
[XDEN,cfsDEN,dimCFS] = wdencmp('lvd',C,S,wname,level,thr,sorh);

XDEN = exp(XDEN);

mse = sum(sum(original-XDEN).^2)/(numel(original))
PSNR = 20*log10(255^2/mse)

figure;
subplot(1,2,1);
imagesc(noisy); colormap gray; axis off;
title('Noisy Image');
subplot(1,2,2);
imagesc(XDEN); colormap gray; axis off;
title('Denoised Image');

figure;
imshow(original/255);
% 
% figure;
% imshow(noisy/255);

figure;
imshow(XDEN/255);