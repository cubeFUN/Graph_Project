clear

addpath('./Compute graph-based features');
addpath('./statistical analysis');
addpath('../Network Analysis');

disp('features scaled');
%T = xlsread('/Users/c-ten/Desktop/test.xlsx','BS:DT');
T=load('features_combine_noscale_nobig.mat');
features = T.X;


features_scaled = zeros(size(features));
features(isnan(features)) = 0;
for i = 1:size(features,2)
    MAX = max(features(:,i));
    MIN = min(features(:,i));
    features_scaled(:,i) = (features(:,i) - MIN) ./ (MAX - MIN);
end


disp('save')
save ./features_combine_scale_nobig_PET.mat features_scaled -v7.3
