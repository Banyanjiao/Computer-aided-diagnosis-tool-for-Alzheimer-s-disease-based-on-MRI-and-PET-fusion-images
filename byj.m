clear all

rootFolder = 'D:\matlab\my\2DPET\'; 

% Load pretrained network

% Net 1
%google_net = googlenet;
% Net 2
%shuffle_net = shufflenet;
% Net 3
%squeeze_netp = squeezenet;
% Net 4
%res18_net = resnet18;
% Net 5
res50_netp = resnet50; 
% Net 6
%res101_net = resnet101;
% Net 7
%dense201_netp = densenet201;


% Create image datastore and read labels of sub-folders
imds = imageDatastore(rootFolder, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 

% Initialize results
ACC=[];
KAPPA=[];

for i =1:5
    
% Randomly divide the data into training and validation data sets. 
% Use 80% of the images for training and 20% for validation.

[imdsTrain,imdsValidation] = splitEachLabel(imds,0.8,'randomize');

% Display an interactive visualization of the network architecture and 
% detailed information about the network layers.

%analyzeNetwork(net)

% The first element of the Layers property of the network is the image input layer.
inputSize = res50_netp.Layers(1).InputSize;

% Extract the layer graph from the trained network. 
% If the network is a SeriesNetwork object, such as AlexNet, 
% then convert the list of layers in net.Layers to a layer graph.

if isa(xception_netp,'SeriesNetwork') 
  lgraph = layerGraph(res50_netp.Layers); 
else
  lgraph = layerGraph(res50_netp);
end 

% Find the names of the two layers to replace
 [learnableLayer,classLayer] = findLayersToReplace(lgraph);


numClasses = numel(categories(imdsTrain.Labels));

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);


% The classification layer specifies the output classes of the network. 
% Replace the classification layer with a new one without class labels. 
% trainNetwork automatically sets the output classes of the layer at training time. 

newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

% Train Network

% Use an augmented image datastore to automatically resize the training images. 
% Specify additional augmentation operations to perform on the training images: 
% randomly flip the training images along the vertical axis and randomly translate them 
% up to 30 pixels and scale them up to 10% horizontally and vertically. 
% Data augmentation helps prevent the network from overfitting and memorizing 
% the exact details of the training images.  

%{
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);

augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter, 'ColorPreprocessing','gray2rgb');
%}

augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
    %'ColorPreprocessing','gray2rgb'); % NO augmentation


% To automatically resize the validation images without performing further data augmentation, 
% use an augmented image datastore without specifying any additional preprocessing operations.

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
    %'ColorPreprocessing','gray2rgb');


% Specify the training options

miniBatchSize = 10;
valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',false, ...
    'Plots','training-progress');

% Train the network using the training data. By default, trainNetwork uses a GPU 
% if one is available (requires Parallel Computing Toolbox� and a CUDA enabled GPU 
% with compute capability 3.0 or higher). Otherwise, trainNetwork uses a CPU.

res50_netp = trainNetwork(augimdsTrain,lgraph,options);

% Classify the validation images using the fine-tuned network, 
% and calculate the classification accuracy.

[YPred,probs] = classify(res50_netp,augimdsValidation);
% accuracy = mean(YPred == imdsValidation.Labels);


% Get the known labels
testLabels = imdsValidation.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, YPred);

% Display the mean accuracy
accuracy = (sum(diag(confMat))/sum(sum(confMat)))*100;
p0 = sum(diag(confMat))/sum(sum(confMat));
pe = (sum(confMat(:,1))*sum(confMat(1,:)) + sum(confMat(:,2))*sum(confMat(2,:)) + sum(confMat(:,3))*sum(confMat(3,:)))/(sum(sum(confMat))*sum(sum(confMat)));
kappa = (p0-pe)/(1-pe); % AD

ACC=[ACC,accuracy];
KAPPA=[KAPPA,kappa];

end 

%save res50_netp res50_netp

%--------------------------
mACC = mean(ACC);
mKAPPA = mean(KAPPA);

sACC = std(ACC);  %算出ACC的标准偏差
sKAPPA = std(KAPPA);

display(mACC);
display(mKAPPA);

display(sACC);
display(sKAPPA);

display(ACC);
display(KAPPA);

