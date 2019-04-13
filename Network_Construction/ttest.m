fpath = './data/features_PET_network.txt';
featuresALL = load(fpath);

lpath = './data/label_2_1013.txt';
labelALL = load(lpath);

% 0=recurrence, 3=AJCC
tt_label = 3;

label = labelALL(:, tt_label);
features = featuresALL(~isnan(label), :);
label = label(~isnan(label));

sz = size(features);
pvalue = zeros(1,sz(2));
for i = 1:sz(2)
	X = rescale(features(:,i),0,1);
	Y = label;
	[pvalue(i),h(i),stats(i)] = ranksum(Y,X);
end
