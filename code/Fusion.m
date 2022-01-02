function FF=Fusion(I1,I2)
[m,n]=size(I1);
%% B-Base layer; D-Detail layer
K1_1=Filter(I1,1.5,0.05,1.3,5,0.01);
K1_2=Filter(I2,1.5,0.05,1.3,5,0.01);
B1=K1_1;
B2=K1_2;
D1=I1-K1_1;
D2=I2-K1_2;

%% fusion
%Base layer
g_b=guidedfilter(B2,B2,1, 0.001);
g_b=(g_b)./max(g_b(:));
k2_B=ones(m,n)-g_b;
F_B=k2_B.*B1+g_b.*B2;

%Detail layer
M1=guidedfilter(I2,I2,8,0.1);
M2=zeros(m,n);
for i=4:m-4
    for j=4:n-4
        M2(i,j)=I2(i,j)-(I2(i+1,j)+I2(i,j+1)+I2(i-1,j)+I2(i,j-1)+I2(i,j)+I2(i+1,j-1)+I2(i-1,j+1)+I2(i-1,j-1)+I2(i+1,j+1))/9;
    end
end
K1=I2-M1+M2;
im= imfilter(M1, fspecial('gaussian',15, 15), 'symmetric', 'conv');
lm = mean(mean(im));%整幅图片的l均值
sm = (im-lm).^2;%像素的显著度
s=max(sm(:));
sm=sm./s;
K1=K1+sm;
K1=max(K1,zeros(m,n));
K1=K1./max(K1(:));
K2=guidedfilter(K1,K1,1,0.001)+mean(I2(:)).*I2;
F_L=D1+K2.*D2;

%% Reconstruction + Information Refinement
Q=F_B+F_L;
Z=max(I2-I1,zeros(m,n));
K_Z=guidedfilter(Z,Z,1,0.001);
K_Z=(K_Z)./max(K_Z(:));
FF=(ones(m,n)-K_Z).*Q+K_Z.*I2;

 figure(1), imshow(FF);