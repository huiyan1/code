function fusion_indeices(A1,A2,R)
%Q_M1
nmi1=normal_mutinf(double(A1),R);
nmi2=normal_mutinf(double(A2),R);
Q_MI=2*(nmi1+nmi2)

%Q(AB/F)
Q_ABF=Qabf(A1,A2,R) 

%FSIM
F1=FeatureSIM(A1,R);
F2=FeatureSIM(A2,R);
FSIM=(F1+F2)/2

%MS-SSIM
MS1=msssim(A1,R);
MS2=msssim(A2,R);
MS_SSIM=(MS1+MS2)/2


%VIFF
VIFF=VIFF_Public(A1,A2,R)
end