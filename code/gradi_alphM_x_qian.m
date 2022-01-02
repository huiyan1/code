 function M=gradi_alphM_x_qian(X,alph)
[m,n]=size(X);
 M=zeros(m,m);
for i=1:m 
    for  k=2:m-1
        M(i,i)=(-1)*gamma(alph+1)/(gamma(1+1)*gamma(alph-1+1));
        if i+1<=m
            M(i,i+1)=1+gamma(alph+1)/(gamma(2+1)*gamma(alph-2+1));
        end
           if i+k<=m
           M(i,i+k)=(-1)^(k+1)*gamma(alph+1)/(gamma(k+2)*gamma(alph-k));
           end
    end 
end
end