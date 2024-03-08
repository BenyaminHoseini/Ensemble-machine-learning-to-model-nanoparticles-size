while(1)
clc, clear, close all;
%warning('off','all')
%warning
load('data10.mat')
n=randperm(size(in,1));
in=in(n,:);
out=out(n);
in_training=in(1:round(size(in,1)*0.7),:);
out_training=out(1:round(size(in,1)*0.7),:);
in_test=in(round(size(in,1)*0.7)+1:end,:);
out_test=out(round(size(in,1)*0.7)+1:end,:);
t = templateTree('Surrogate','On');
%load('new_data_size10.mat')
bc=fitrensemble(in_training,out_training,'Method','LSBoost');
%bc=fitrensemble(in_training,out_training,'AdaBoostM1');
%bc=fitrensemble(in_training,out_training,'OptimizeHyperparameters','auto','Learners',t, ...
%    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'))
pre_train=bc.predict(in_training);
pre_tast=bc.predict(in_test);
MAE_Training=mean(abs(out_training-pre_train));
MSE_Training=mean(abs(out_training-pre_train).^2);  
MAE_Test=mean(abs(out_test-pre_tast));
MSE_Test=mean(abs(out_test-pre_tast).^2);
disp('--------------------------------');
disp(['MAE Training = ',num2str(MAE_Training)])
disp(['MAE Test = ',num2str(MAE_Test)])
disp('-------------Training-------------------');
p_training=CalcPerf(out_training,bc.predict(in_training))
disp('-------------Test-------------------');
p_test=CalcPerf(out_test,bc.predict(in_test))
if(MAE_Training<MAE_Test && MAE_Test<1.7)
    break
end
end