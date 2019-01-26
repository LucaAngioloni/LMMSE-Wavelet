function [ G ] = mediaG( g, passo )
%UNTITLED4 Media locale matrice g
%   Detailed explanation goes here

G = zeros(size(g));

half_p = floor(passo/2);

%--------------------------------------------------------------------
%Costruisco una matrice ausiliaria per evitare il problema dei bordi
%rendendo l'immagine sferica
g1 = zeros(size(g) + (2*half_p));

s1 = size(g,1);
s2 = size(g,2);

g1(half_p+1:s1+half_p, half_p+1:s2+half_p) = g; %center g
g1(half_p+1:s1+half_p, 1:half_p) = g(:,s2-half_p+1:s2); %left g1 mirrors right g
g1(1:half_p, half_p+1:s2+half_p) = g(s1-half_p+1:s1,:); %top g1 mirror bottom g
g1(half_p+1:s1+half_p, s2+half_p+1:size(g1,2)) = g(:,1:half_p); %right g1 mirrors left g
g1(s1+half_p+1:size(g1,1), half_p+1:s2+half_p) = g(1:half_p,:); %bottom g1 mirror top g

g1(1:half_p, 1:half_p) = g(s1-half_p+1:s1, s2-half_p+1:s2); %top left corner
g1(1:half_p, s2+half_p+1:size(g1,2)) = g(s1-half_p+1:s1,1:half_p); %top right corner
g1(s1+half_p+1:size(g1,1), 1:half_p) = g(1:half_p, s2-half_p+1:s2); %bottom left corner
g1(s1+half_p+1:size(g1,1), s2+half_p+1:size(g1,2)) = g(1:half_p, 1:half_p); %bottom right corner

%--------------------------------------------------------------------

h = window(@rectwin,passo); %anche a box
h = h/sum(h);
h2 = h*h';

G = filter2(h2,g1);
G = G(half_p+1:end-half_p,half_p+1:end-half_p);

% integralImage = cumsum(cumsum(double(g1)),2);
% 
% 
% 
% for i=1:size(g,1)
%     for j=1:size(g,2)
%         I = i+half_p;
%         J = j+half_p;
%         sum = integralImage(I+half_p,J+half_p) - integralImage(I+half_p,J-half_p) - integralImage(I-half_p,J+half_p) + integralImage(I-half_p,J-half_p);
%         G(i,j) = sum/(passo^2);
%     end
% end
% end
% 
% 
% 
% 
% % Altro possibile modo per gestire i bordi
% %
% % integralImage = cumsum(cumsum(double(g)),2);
% %
% % for i=1:size(g,1)
% %     for j=1:size(g,2)
% %         sum = 0;
% %         if (i>floor(passo/2) && j>floor(passo/2) && i< size(g,1)-floor(passo/2) && j< size(g,2)-floor(passo/2))
% %             sum = integralImage(i+floor(passo/2),j+floor(passo/2)) - integralImage(i+floor(passo/2),j-floor(passo/2)) - integralImage(i-floor(passo/2),j+floor(passo/2)) + integralImage(i-floor(passo/2),j-floor(passo/2));
% %         else
% %             for i1 = i-floor(passo/2):i+floor(passo/2)
% %                 for j1 = j-floor(passo/2):j+floor(passo/2)
% %                     %Circolare
% %                     sum = sum + g(mod(size(g,1)+i1-1,size(g,1))+1,mod(size(g,2)+j1-1,size(g,2))+1);
% %                 end
% %             end
% %         end
% %         G(i,j) = sum/(passo^2);
% %     end
% % end
% % end
% 
