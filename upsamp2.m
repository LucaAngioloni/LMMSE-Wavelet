function y=upsamp2(x,M)
[L N]=size(x);
y=zeros([L (N-1)*M+1]);
for k=1:L
   y(k,1:M:N*M)=x(k,:);
end
return