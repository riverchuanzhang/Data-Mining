% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 29-Sep-2015 18:03:36
%
% This script assumes these variables are defined:
%
%   cancerInputs - input data.
%   cancerTargets - target data.

clear;
% load the cleared data
load('data.mat','Datac_all','Datac_train','Datac_test','Evaluatec');
[r_Datac_trian,c_Datac_train] = size(Datac_train);
[r_Datac_test,c_Datac_test] = size(Datac_test);
train_label = Datac_train(:,c_Datac_train);
train_feature = Datac_train(:,1:c_Datac_train-1);
test_label_predict = zeros(r_Datac_test,1);
test_feature = Datac_test(1:end,1:c_Datac_test-1);
% mapped the original data to range of [-1,1]
% [mapped_features,PS] = mapminmax(features);
m = length(train_label);
nn_train_label = zeros(m,2);
% transform the target lables to the Neural Network trainning format
for i = 1:m
    nn_train_label(i,(train_label(i,1)+1)) = 1;
end;

x = train_feature';
t = nn_train_label';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.

trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
j = 1;
accuracy = zeros(10,1);
for i = 11:20
    hiddenLayerSize = i;
    net = patternnet(hiddenLayerSize,trainFcn);

    % Setup Division of Data for Training, Validation, Testing
    net.divideParam.trainRatio = 80/100;
    net.divideParam.valRatio = 20/100;

    % Train the Network
    [net,tr] = train(net,x,t);

    % Test the Network
    test_label_predict = net(test_feature');
    test_label_predict_ind = vec2ind(test_label_predict)-1;
    accuracy(j) = mean(double(test_label_predict_ind == Evaluatec'));
    j = j + 1;
%     e = gsubtract(t,y);
%     performance = perform(net,t,y);
%     tind = vec2ind(t);
%     yind = vec2ind(y);
%     percentErrors = sum(tind ~= yind)/numel(tind);

    % View the Network
    % view(net)

    % Plots
    % Uncomment these lines to enable various plots.
    % figure, plotperform(tr)
    % figure, plottrainstate(tr)
    % figure, ploterrhist(e)
%     figure, plotconfusion(t,y)
    % figure, plotroc(t,y)
end;
save('accuracy_NN_test','accuracy');

