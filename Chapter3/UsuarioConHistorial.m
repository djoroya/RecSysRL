clear 
load('MoviesDataSet.mat')

%% Selecion de usuario con historial previo
userIds_train = unique(MAcceptTest.userId);
iUsedId = userIds_train(10);
%%
for iUsedId = userIds_train'
nrows_test  = 1+sum(MAcceptTest.userId  == iUsedId);
nrows_train = 1+sum(MAcceptTrain.userId == iUsedId);

frac = nrows_test/nrows_train;

if 0.0 < frac && frac < 4.0
    frac
nrows_test
nrows_train
end
end
%%
iMRTrain = MoviesRatingTrain(MoviesRatingTrain.userId == iuser,:);
iMRTest  = MoviesRatingTest (MoviesRatingTest.userId  == iuser,:);
%%
xt = table2array(iMRTrain(:,5:end));
rt = table2array(iMRTrain(2:end,3));
ut = table2array(iMRTrain(2:end,5:end));

%%
Ndim = 40;
lgraph = layerGraph();
layers = [
            sequenceInputLayer(Ndim,'Name','InputLayer')
            fullyConnectedLayer(20,'Name','hidden','Weights',ones(20,1),'Bias',ones(20,1))
            reluLayer('Name','relu1')
            fullyConnectedLayer(1,'Name','OutputLayer','Weights',ones(1,1),'Bias',ones(1,1))
            regressionLayer('Name','soft1')
            ];
   
lgraph = addLayers(lgraph,layers);
%%
options = trainingOptions('sgdm', ...
    'MaxEpochs',8, ...
    'Shuffle','every-epoch', ...
    'ValidationFrequency',30, ...
    'Verbose',true, ...
    'Plots','none');

%
%%
alpha = 0.1;
gamma = 0.9;
%%
[~,T] = size(xt);
for it = 1:T-1
   xu = [xt(it,:) ut(it,:)];
   r  = rt(it);
   %%
   [net,info] = trainNetwork(xu,r,lgraph,options);

end
