clc;
clear all;
close all;
load net
addpath('Database')
addpath('functions')
IR=imread('Database\Athena_images\2_men_in_front_of_house\IR_meting003_g.bmp');
VIS=imread('Database\Athena_images\2_men_in_front_of_house\VIS_meting003_r.bmp');
figure;imshow(IR);title('Input Infrared image-1')
figure;imshow(VIS);title('Input Visible Image image-1')
irgf_d1 = im2double(imgaussfilt(IR,0.01));
visgf_d1=im2double(imgaussfilt(VIS,0.01));
ir_jbf_d1=im2double(jbfltGray(irgf_d1,irgf_d1,0.1,0.2,1));
vis_jbf_d1=im2double(jbfltGray(visgf_d1,visgf_d1,0.1,0.5,1));
%====================Iteration 2===========================================
irgf_d2 = im2double(imgaussfilt(ir_jbf_d1,0.01));
visgf_d2=im2double(imgaussfilt(vis_jbf_d1,0.01));
ir_jbf_d2=im2double(jbfltGray(irgf_d2,irgf_d2,0.1,0.2,1));
vis_jbf_d2=im2double(jbfltGray(visgf_d2,visgf_d2,0.1,0.1,1));
%====================Iteration 3===========================================
irgf_d3 = im2double(imgaussfilt(ir_jbf_d2,0.01));
visgf_d3=im2double(imgaussfilt(vis_jbf_d2,0.01));
ir_jbf_d3=im2double(jbfltGray(irgf_d3,irgf_d3,0.1,0.2,1));
vis_jbf_d3=im2double(jbfltGray(visgf_d3,visgf_d3,0.1,0.2,1));
%====================Iteration 4===========================================
irgf_d4 = im2double(imgaussfilt(ir_jbf_d3,0.01));
visgf_d4=im2double(imgaussfilt(vis_jbf_d3,0.01));
ir_jbf_d4=im2double(jbfltGray(irgf_d4,irgf_d4,0.1,0.2,1));
vis_jbf_d4=im2double(jbfltGray(visgf_d4,visgf_d4,0.1,0.2,1));
%===================================high-pass image========================
HP_ir = locallapfilt(IR, 0.4, 0.5);
HP_vis= locallapfilt(VIS, 0.4, 0.5);
%===================================Low-pass image==========+==============
SM_ir=HP_ir;
SM_vis=HP_vis;
%==================================Initial Weight MAp======================
IWP_ir=zeros(size(SM_ir,1),size(SM_ir,2));
for i=1:size(SM_ir,1)
    for j=1:size(SM_ir,2)
        if(SM_ir(i,j)>(SM_vis(i,j)))
            IWP_ir(i,j)=1;
        else
            IWP_ir(i,j)=0;
        end
    end
end
IWP_vis=zeros(size(SM_vis,1),size(SM_vis,2));
for i=1:size(SM_vis,1)
    for j=1:size(SM_vis,2)
        if(SM_ir(i,j)<(SM_vis(i,j)))
            IWP_vis(i,j)=1;
        else
            IWP_vis(i,j)=0;
        end
    end
end
%==========================Final Weight Map================================
FWP_ir=imguidedfilter(IWP_ir,IR);
FWP_vis=imguidedfilter(IWP_vis,VIS);
%=========================Base Layer Fusion================================
B_fusion=FWP_ir.*im2double(irgf_d4)+FWP_vis.*im2double(visgf_d4);
%=========================Detailed Layer Fusion============================
A=padarray(ir_jbf_d4,[1,1],0,'both');
for m=2:size(A,1)-1
    for n=2:size(A,2)-1
        temp=A(m-1:m+1,n-1:n+1);
        avg_ir(m-1,n-1)=mean2(temp);
    end
end
I=padarray(vis_jbf_d4,[1,1],0,'both');
for m=2:size(I,1)-1
    for n=2:size(I,2)-1
        temp=I(m-1:m+1,n-1:n+1);
        avg_vis(m-1,n-1)=mean2(temp);
    end
end
en_devil=zeros(size(avg_ir,1),size(avg_ir,2));
for i=1:size(avg_ir,1)-1
    for j=1:size(avg_ir,2)-1
        en_devil(i,j)=((avg_ir(i,j))/(avg_ir(i,j)+avg_vis(i,j)));
    end
end
Th=0.6;
alpha=(Th/1+Th);
beta=((1/1)+Th);
a=zeros((size(en_devil,1)),(size(en_devil,2)));
for m=1:size(en_devil,1)
    for n=1:size(en_devil,2)
        if((en_devil(m,n))>=0.5 && (en_devil(m,n))<=beta)
            a(m,m)=(0.5+0.5*((1-2*en_devil(m,n) / (1-2*beta))));
        elseif((en_devil(m,n))>=0.5 && (en_devil(m,n))<=alpha)
            a(m,m)=(0.5-0.5*((1-2*en_devil(m,n) / (1-2*beta))));
        elseif((en_devil(m,n))>=0 && (en_devil(m,n))>=alpha)
            a(m,m)=0;
        elseif((en_devil(m,n))>= 1 && (en_devil(m,n))<=beta)
            a(m,m)=1;
        end
    end
    D_fusion=zeros((size(en_devil,1)),(size(en_devil,2)));
    for i=1:(size(en_devil,1))
        for j=1:(size(en_devil,2))
            D_fusion(i,j)=((1-(en_devil(i,j).*vis_jbf_d3(i,j))+((en_devil(i,j).*ir_jbf_d3(i,j)))));
        end
    end
end
IR = im2double(IR);
VIS = im2double(VIS);
B_fusion = NormalizeData(B_fusion);
D_fusion = NormalizeData(D_fusion);
B_fusion = B_fusion(:);
D_fusion = D_fusion(:);
input_all = [B_fusion,D_fusion];
x = input_all';
Fused_out = net(x);
Fused_out = reshape(Fused_out,size(IR,1),size(IR,2));
figure;imshow(Fused_out,[]);title('Fused image output');
en = entropy(Fused_out);
q_val = Qabf(IR, VIS, Fused_out);
opinionScores = 100*rand(1,1);
model = brisqueModel(rand(10,1),47,rand(10,36),0.25);
xc = XC(VIS,Fused_out);
imse = immse(VIS,Fused_out);
peaksnr = psnr(VIS,Fused_out);
ssimval = ssim(VIS,Fused_out);
iscore_brisque = brisque(VIS,model);
niqe_model = niqe(Fused_out);
brisqueInoise = brisque(Fused_out);
mi = MutualInformation(VIS,Fused_out);
fprintf('%s\n',['1)En------------------->',num2str(en)])
fprintf('%s\n',['2)Qe------------------->',num2str(q_val)])
fprintf('%s\n',['3)IMMSE---------------->',num2str(imse)])
fprintf('%s\n',['4)XC------------------->',num2str(xc)])
fprintf('%s\n',['5)PEAK_SNR------------->',num2str(peaksnr)])
fprintf('%s\n',['6)SSIMVAL-------------->',num2str(ssimval)])
fprintf('%s\n',['7)BRISQUE-------------->',num2str(iscore_brisque)])
fprintf('%s\n',['8)NIQE----------------->',num2str(niqe_model)])
fprintf('%s\n',['9)BRISQUE_INOISE------->',num2str(brisqueInoise)])
fprintf('%s\n',['10)Mutual Information------->',num2str(mi)])
save B_fusion B_fusion
save D_fusion D_fusion
save Fused_out Fused_out

