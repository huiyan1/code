clear all
close all
clc
IN1= imread('source_images/pair1_1.tif');
IN2= imread('source_images/pair1_2.tif');
% IN1=rgb2gray(IN1);
% IN2=rgb2gray(IN2);
I1=im2double(IN1);
I2=im2double(IN2);
F=Fusion(I1,I2);
fusion_indeices(I1,I2,F)
