function y=shrink(IN,r)
[m,n]=size(IN);
k=IN./abs(IN);
k1=max(abs(IN)-r,zeros(m,n));
y=k.*k1;
end