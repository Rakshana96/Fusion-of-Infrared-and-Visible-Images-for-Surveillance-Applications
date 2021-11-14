function [ESSIM_index] = XC(Ref_img, Dis_img)
% ========================================================================
% ESSIM Index with automatic downsampling
% Copyright(c) 2012 Xuande Zhang, Xiangchu Feng, Weiwei Wang and Wufeng Xue
% All Rights Reserved.
%----------------------------------------------------------------------
% This is an implementation of the algorithm presented in the following
% paper: 
% Xuande Zhang, Xiangchu Feng, Weiwei Wang, and Wufeng Xue, Edge Strength Similarity for Image
% Quality Assessment,IEEE SIGNAL PROCESSING LETTERS, VOL. 0, NO. , 2013
%----------------------------------------------------------------------
%
%Input : (1) Ref_img: reference image
%        (2) Dis_img: distorted image
%
%Output: (1) ESSIM_index : the objective score given by using ESSIM IQA metric
%        
%-----------------------------------------------------------------------
% Email: love_truth@126.com 
% 2013-02-02
Ref_img = double(Ref_img);
Dis_img = double(Dis_img);
if size(Ref_img,3)==3 
    Ref_img = 0.299 * double(Ref_img(:,:,1)) + 0.587 * double(Ref_img(:,:,2)) + 0.114 * double(Ref_img(:,:,3));
    Dis_img = 0.299 * double(Dis_img(:,:,1)) + 0.587 * double(Dis_img(:,:,2)) + 0.114 * double(Dis_img(:,:,3));
end
% automatic downsampling
[M,N]=size(Ref_img);
f = max(1,round(min(M,N)/256));
%downsampling by f
%use a simple low-pass filter 
if(f>1)
    lpf = ones(f,f);
    lpf = lpf/sum(lpf(:));
    Ref_img = imfilter(Ref_img,lpf,'symmetric','same');
    Dis_img = imfilter(Dis_img,lpf,'symmetric','same');
    Ref_img = Ref_img(1:f:end,1:f:end);
    Dis_img = Dis_img(1:f:end,1:f:end);
end
[m,n]=size(Ref_img);
% Fractional gradient
[g1]=directional_gradient(Ref_img);
[g2]=directional_gradient(Dis_img);
L=255;
alfa=0.5;
K(1)=10;
C1 = (K(1)*L).^(2*alfa);
grad1=abs(g1(:,:,[1,3])-g1(:,:,[2,4])).^alfa;
grad2=abs(g2(:,:,[1,3])-g2(:,:,[2,4])).^alfa;
[Y X]=meshgrid(1:n,1:m);
[x ind3]=max(grad1,[],3);
ind=sub2ind([m,n,2],X(:),Y(:),ind3(:));
map=(2*grad1(ind).*grad2(ind)+C1)./(grad1(ind).^2+grad2(ind).^2+C1);
ESSIM_index=mean(map(:));
function  [g]=directional_gradient(f)
% Compute the Gradient of the Image with Kernel Specified by the type
% f:    the image
% type: the string specified the kernel
% 2012-07-09
[m,n]=size(f);
g=zeros(m,n,4);
K1=zeros(5);K2=K1; K3=K1; K4=K1;
Kt=1/16*[3 10 3;0 0 0; -3 -10 -3];
K1(2:4,2:4)=Kt;  K2=K1';
K3=1/16*[ 0     0     3     0     0;
    0    10     0     0     0;
    3     0     0     0    -3;
    0     0     0   -10     0;
    0     0    -3     0     0];
K4=rot90(K3);
g(:,:,1)=filter2(K1,f,'same');
g(:,:,2)=filter2(K2,f,'same');
g(:,:,3)=filter2(K3,f,'same');
g(:,:,4)=filter2(K4,f,'same');