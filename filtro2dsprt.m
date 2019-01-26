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
function y = filtro2dsprt(x, hr, hc, dr, dc, LP_FLAG, SYM_FLAG_R, SYM_FLAG_C)

% Dimensione immagine input, output e filtri

[Mx Nx] = size(x);
[Nf] = size(hr,2);
[Mf] = size(hc,2);
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
	
	%filtro per colonne
	for k=1:size(y,2)
        v = y(:,k);
        v = [v(Mx-Mf+2:Mx); v]';
        v1 = filter(hc,1,v);
        y(:,k) = trascirc(v1(Mf:Mx+Mf-1),-dc)';
	end

elseif LP_FLAG == 1

	% filtro per righe
	for k=1:size(x,1)
        v = x(k,:);
        if SYM_FLAG_R == 0
            v = [v(Nf:-1:2) v v(Nx-1:-1:Nx-Nf)];
        elseif SYM_FLAG_R == 1
            v = [v(Nf+1:-1:2) v(2:end) v(Nx:-1:Nx-Nf+1)];
        elseif SYM_FLAG_R == -1
            v = [-v(Nf+1:-1:2) v(2:end) -v(Nx:-1:Nx-Nf+1)];
        end
        v1 = filter(hr,1,v);
        y(k,:) = v1(Nf+dr:Nx+Nf-1+dr);
	end
	
	%filtro per colonne
	for k=1:size(y,2)
        v = y(:,k);
        if SYM_FLAG_C == 0
            v = [v(Mf:-1:2); v; v(Mx-1:-1:Mx-Mf)];
        elseif SYM_FLAG_C == 1
            v = [v(Mf+1:-1:2); v(2:end); v(Mx:-1:Mx-Mf+1)];
        elseif SYM_FLAG_C == -1
            v = [-v(Mf+1:-1:2); v(2:end); -v(Mx:-1:Mx-Mf+1)];
        end
        v1 = filter(hc,1,v);
        y(:,k) = v1(Mf+dc:Mx+Mf-1+dc);
	end
    
end

return