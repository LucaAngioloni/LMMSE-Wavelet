%
% 2D separable filtering
%
% Y = FILTRO2DSPRT(X,HR,HC,DR,DC,LP_FLAG)
%
% X = input image
% HR = impulse response along rows
% HC = impulse response along columns
% DR = delay rows
% DC = delay columns
% LP_FLAG = linear phase extension flag
%
% Y = filtered image
% 
function y = filtro1dsprt(x, hr, dr, LP_FLAG, SYM_FLAG)

% Dimensione immagine input, output e filtri

[Mx Nx] = size(x);
[Nf] = size(hr,2);
%My = Mx+Mf-1;
%Ny = Nx+Nf-1;
y = zeros(Mx,Nx);
p = length(hr);

if LP_FLAG == 0

	% filtro per righe
	for k=1:size(x,1)
        v = x(k,:);
        v = [v(Nx-Nf+2:Nx) v];
        v1 = filter(hr,1,v);
        y(k,:) = trascirc(v1(Nf:Nx+Nf-1),-dr);
	end
	
elseif LP_FLAG == 1

        v = x;
        if SYM_FLAG == 0
            v = [v(Nf:-1:2) v v(Nx-1:-1:Nx-Nf)];
        elseif SYM_FLAG == 1
            v = [v(Nf+1:-1:2) v(2:end) v(Nx:-1:Nx-Nf+1)];
        elseif SYM_FLAG == -1
            v = [-v(Nf+1:-1:2) v(2:end) -v(Nx:-1:Nx-Nf+1)];
        end
        v1 = filter(hr,1,v);
        y = v1(Nf+dr:Nx+Nf-1+dr);

end

return