function [ G2 ] = mediaG2( g, passo )
%mediaG2 Calcola la media di g quadro 
%   Detailed explanation goes here
g2 = g.^2;

G2 = mediaG(g2, passo);
end

