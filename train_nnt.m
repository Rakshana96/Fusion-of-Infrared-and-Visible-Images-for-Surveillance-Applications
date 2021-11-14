clc;
clear all;
close all;
load B_fusion
load D_fusion
load Fused_out
B_fusion = B_fusion(:);
D_fusion = D_fusion(:);
Fused_out = Fused_out(:);
input_all = [B_fusion,D_fusion];
x = input_all';
t = Fused_out';
trainFcn = 'trainlm'; 
% Create a Fitting Network
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,trainFcn);
% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
% Train the Network
[net,tr] = train(net,x,t);
save net net
% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)
% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, ploterrhist(e)
figure, plotregression(t,y)

