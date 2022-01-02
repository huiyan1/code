function OUT = Filter(IN1,a,lambda1,lambda2, beta, em)
%a-fractional order
if(~exist('lambda1', 'var')),
    lambda1 = 0.01;
end
if(~exist('lambda2', 'var')),
    lambda2 = 1;
end
if(~exist('beta', 'var')),
    beta = 5;
end
if(~exist('e', 'var')),
    em= 0.01;
end

[m,c]=size(IN1);
k=m*c;
IN=reshape(IN1,k,1);
d1_old=zeros(k,1);
b1_old=zeros(k,1);
z_old=IN;

%% W
Dx=gradi_alphM_x_qian(IN1,a);  
Dy=gradi_alphM_x_qian(IN1',a);
fy=abs(Dx*IN1);
fy(m,1:end)=0;
fx=abs(IN1*Dy');
fx(1:end,m)=0;
f=fx+fy;
f1=sobel(f);
f1=medfilt2(f1,[2,2]);
dx=-lambda1./(f1+0.0001);
dx = dx(:);


%% X 
g1=guidedfilter(IN1,IN1,3,0.01); 
G1=reshape(g1,k,1);
G=spdiags(G1.*G1,0,k,k);
G1=spdiags(G1,0,k,k);


%% Construct a five-point spatially inhomogeneous Laplacian matrix
B(:,1) = dx;%B为2列矩阵，第一列为dx,第二列为dy
B(:,2) = dx;
d = [-m,-1];
A = spdiags(B,d,k,k); %A = spdiags（B，D ,m, n），产生一个m×n稀疏矩阵A，其元素是B中的列元素放在由D指定的对角线位置上。

e = dx;
w = padarray(dx, m, 'pre'); %前面加0
w = w(1:end-m);
s = dx;
n = padarray(dx, 1, 'pre');
n = n(1:end-1);

D = 1-(e+w+s+n);
A = A + A' + spdiags(D, 0, k, k)+lambda2.^2*beta/2.*G;
j=0;
%% SB
while true
    V=IN+lambda2*beta/2.*G1'*(d1_old-b1_old);
    z_new=A\V;
    d1_new=shrink(lambda2.*G1*z_new+b1_old,1/beta);
    b1_new=b1_old+lambda2.*G1*z_new-d1_new;

    if norm(z_new-z_old,2)<=em
        OUT=reshape(z_new,m,c);
        j        %Iteration number
         return
    end
    j=j+1;
   z_old=z_new;
   d1_old=d1_new;
   b1_old=b1_new;
end

end