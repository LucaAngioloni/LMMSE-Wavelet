%
% TRASCIRC traslazione circolare di una sequenza
%
% Y = TRASCIRC(X,M)
%	X = segnale da traslare
% 	M = shift positivo (a destra) o negativo (a sinistra)
%
function y = trascirc(x,m)

[L N] = size(x);
y = zeros(L,N);
if ~(m-round(m) == 0)
	disp('Errore in trascirc: valore di shift non intero');
	return;
end
if m > 0
	y(:,1:m) = x(:,N-m+1:N);
	y(:,m+1:N) = x(:,1:N-m);
elseif m < 0
	m = -m;
	y(:,1:N-m) = x(:,m+1:N);
	y(:,N-m+1:N) = x(:,1:m);
else
	y=x;
end

return
