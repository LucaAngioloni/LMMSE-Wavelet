function [speckledImg] = speckleNoise(originalImg, L)
%Where L is the number of looks needed for the multilooking and originalImg
%must be the quadratic of the signal (so remember to put the result under
%the square root.
% Getting image size
[m,n] = size(originalImg);

% Generating Gamma pdf
U = gamrnd(L,1/L,[m n]);
speckledImg = (originalImg.*U); %è giusto, sennò mi fa il prodotto matriciale e non ha senso, ogni pixel avrà il suo rumore.
