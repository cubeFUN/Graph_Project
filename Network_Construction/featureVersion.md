# AJCC staging
#radiomic PET features
with big size no NAN
features_AJCC_v1.txt
label_AJCC.txt
1000epoch
Label0: 5 fold accuracy is 		0.8469696975115573
Label0: 5 fold specificity is 	0.9722943722943722
Label0: 5 fold sensitivity is 	0.7216450216450216
Label0: 5 fold auc is 			0.8469696969696969

Label0: 5 fold accuracy is 		0.8378787887173814
Label0: 5 fold specificity is 	0.9632034632034632
Label0: 5 fold sensitivity is 	0.7125541125541126
Label0: 5 fold auc is 			0.8378787878787879

2000epoch
Label0: 5 fold accuracy is 		0.8374458874200845
Label0: 5 fold specificity is 	0.9627705627705627
Label0: 5 fold sensitivity is 	0.7121212121212122
Label0: 5 fold auc is 			0.8374458874458874

# recurrence prediction
#network features
old features no big size no NAN
1000epoch
Label0: 5 fold accuracy is 		0.6826923131942749
Label0: 5 fold specificity is 	0.9064102564102564
Label0: 5 fold sensitivity is 	0.458974358974359
Label0: 5 fold auc is 			0.6826923076923076


**old features with big size no NAN**
1000epoch
Label0: 5 fold accuracy is 		0.7800000131130218
Label0: 5 fold specificity is 	0.8104761904761905
Label0: 5 fold sensitivity is 	0.7495238095238095
Label0: 5 fold auc is 			0.78

2000epoch
Label0: 5 fold accuracy is 		0.8014285862445831
Label0: 5 fold specificity is 	0.8514285714285714
Label0: 5 fold sensitivity is 	0.7514285714285714
Label0: 5 fold auc is 			0.8014285714285714

all samples in data
feature 1-11 feature 16-23 feature 25-30
Extrat 2019/5/23
{...}
save ./features_scaled_v1.mat features_scaled -v7.3
save ./features_noscaled_v1.mat features -v7.3
ignore 
all features except for annotated ones
Extrat 2019/5/23 8:30-10:00


2000 epoch
Label0: 5 fold accuracy is 		0.727142870426178
Label0: 5 fold specificity is 	0.8257142857142858
Label0: 5 fold sensitivity is 	0.49523809523809514
Label0: 5 fold auc is 			0.6604761904761905
Label1: 5 fold accuracy is 		0.8022586107254028
Label1: 5 fold specificity is 	0.5599999999999999
Label1: 5 fold sensitivity is 	0.8911764705882353
Label1: 5 fold auc is 			0.7255882352941176

without ignore case
2000 epoch
Label0: 5 fold accuracy is 		0.7969040274620056
Label0: 5 fold specificity is 	0.8791208791208792
Label0: 5 fold sensitivity is 	0.55
Label0: 5 fold auc is 			0.7145604395604396
Label1: 5 fold accuracy is 		0.8910216808319091
Label1: 5 fold specificity is 	0.5666666666666667
Label1: 5 fold sensitivity is 	0.9723809523809525
Label1: 5 fold auc is 			0.7695238095238095

**without nan and ignore @recurrence label**
2000epoch
Label0: 5 fold accuracy is 		0.8467032968997955
Label0: 5 fold specificity is 	0.9857142857142858
Label0: 5 fold sensitivity is 	0.7076923076923076
Label0: 5 fold auc is 			0.8467032967032967

Label0: 5 fold accuracy is 		0.7324175834655762
Label0: 5 fold specificity is 	0.910989010989011
Label0: 5 fold sensitivity is 	0.5538461538461539
Label0: 5 fold auc is 			0.7324175824175824

Label0: 5 fold accuracy is 		0.7247252702713013
Label0: 5 fold specificity is 	0.9417582417582417
Label0: 5 fold sensitivity is 	0.5076923076923077
Label0: 5 fold auc is 			0.7247252747252747

1000 epoch
Label0: 5 fold accuracy is 		0.754945057630539
Label0: 5 fold specificity is 	0.956043956043956
Label0: 5 fold sensitivity is 	0.5538461538461539
Label0: 5 fold auc is 			0.7549450549450549

2000epoch
Label0: 5 fold accuracy is 		0.7939560413360596
Label0: 5 fold specificity is 	0.9417582417582417
Label0: 5 fold sensitivity is 	0.6461538461538462
Label0: 5 fold auc is 			0.793956043956044

Label0: 5 fold accuracy is 		0.7247252702713013
Label0: 5 fold specificity is 	0.9263736263736264
Label0: 5 fold sensitivity is 	0.523076923076923
Label0: 5 fold auc is 			0.7247252747252747

**features_v1new.txt**
1000epoch
Label0: 5 fold accuracy is 		0.6401098847389222
Label0: 5 fold specificity is 	0.8670329670329672
Label0: 5 fold sensitivity is 	0.41318681318681316
Label0: 5 fold auc is 			0.6401098901098902

2000epoch
Label0: 5 fold accuracy is 		0.7846153855323792
Label0: 5 fold specificity is 	0.9714285714285715
Label0: 5 fold sensitivity is 	0.5978021978021978
Label0: 5 fold auc is 			0.7846153846153846

Label0: 5 fold accuracy is 		0.7703296720981598
Label0: 5 fold specificity is 	0.9714285714285715
Label0: 5 fold sensitivity is 	0.5692307692307692
Label0: 5 fold auc is 			0.7703296703296704
# radiomics feature PET
features_r_PET_v1.txt
label_r_PET_2_v1.txt
WITH BIG SIZE
features_radiomics_PETd
1000epoch
Label0: 5 fold accuracy is 		0.8576190590858459
Label0: 5 fold specificity is 	0.9333333333333332
Label0: 5 fold sensitivity is 	0.7819047619047619
Label0: 5 fold auc is 			0.8576190476190476

Label0: 5 fold accuracy is 		0.8376190543174744
Label0: 5 fold specificity is 	0.9466666666666667
Label0: 5 fold sensitivity is 	0.7285714285714285
Label0: 5 fold auc is 			0.8376190476190477

Label0: 5 fold accuracy is 		0.9
Label0: 5 fold specificity is 	0.9199999999999999
Label0: 5 fold sensitivity is 	0.8800000000000001
Label0: 5 fold auc is 			0.9

Label0: 5 fold accuracy is 		0.8200000047683715
Label0: 5 fold specificity is 	0.8933333333333333
Label0: 5 fold sensitivity is 	0.7466666666666666
Label0: 5 fold auc is 			0.82

Label0: 5 fold accuracy is 		0.8333333253860473
Label0: 5 fold specificity is 	0.9199999999999999
Label0: 5 fold sensitivity is 	0.7466666666666667
Label0: 5 fold auc is 			0.8333333333333334

2000epoch
Label0: 5 fold accuracy is 		0.8066666722297668
Label0: 5 fold specificity is 	0.9333333333333332
Label0: 5 fold sensitivity is 	0.6799999999999999
Label0: 5 fold auc is 			0.8066666666666666

1500epoch
Label0: 5 fold accuracy is 		0.8242857217788696
Label0: 5 fold specificity is 	0.9333333333333332
Label0: 5 fold sensitivity is 	0.7152380952380952
Label0: 5 fold auc is 			0.8242857142857142

**no bigsize**
label_c_v1.txt
features_r_PET_v1nobig.txt
1000epoch
Label0: 5 fold accuracy is 		0.8543955981731415
Label0: 5 fold specificity is 	0.9417582417582417
Label0: 5 fold sensitivity is 	0.767032967032967
Label0: 5 fold auc is 			0.8543956043956044

Label0: 5 fold accuracy is 		0.8686813116073608
Label0: 5 fold specificity is 	0.9703296703296704
Label0: 5 fold sensitivity is 	0.767032967032967
Label0: 5 fold auc is 			0.8686813186813186

[32 8 2]
Label0: 5 fold accuracy is 		0.860988998413086
Label0: 5 fold specificity is 	0.9703296703296704
Label0: 5 fold sensitivity is 	0.7516483516483516
Label0: 5 fold auc is 			0.8609890109890109

1500epoch
Label0: 5 fold accuracy is 		0.8994505405426025
Label0: 5 fold specificity is 	0.9703296703296704
Label0: 5 fold sensitivity is 	0.8285714285714285
Label0: 5 fold auc is 			0.8994505494505495

Label0: 5 fold accuracy is 		0.9
Label0: 5 fold specificity is 	0.9714285714285715
Label0: 5 fold sensitivity is 	0.8285714285714285
Label0: 5 fold auc is 			0.9

#combine features scaled concat scaled(not together scaled)
no NAN label value case & no big size case
label_c_v1.txt
features_combine_p_v1
1000 epoch
Label0: 5 fold accuracy is 		0.8769230723381043
Label0: 5 fold specificity is 	0.9714285714285715
Label0: 5 fold sensitivity is 	0.7824175824175824
Label0: 5 fold auc is 			0.876923076923077

Label0: 5 fold accuracy is 		0.8543955981731415
Label0: 5 fold specificity is 	0.9263736263736263
Label0: 5 fold sensitivity is 	0.7824175824175824
Label0: 5 fold auc is 			0.8543956043956044

1500epoch
Label0: 5 fold accuracy is 		0.792307686805725
Label0: 5 fold specificity is 	0.9406593406593406
Label0: 5 fold sensitivity is 	0.643956043956044
Label0: 5 fold auc is 			0.7923076923076924

#combine features no scaled concat -> scale
2000epoch
Label0: 5 fold accuracy is 		0.8093406558036804
Label0: 5 fold specificity is 	0.8978021978021978
Label0: 5 fold sensitivity is 	0.7208791208791209
Label0: 5 fold auc is 			0.809340659340659

1000epoch
Label0: 5 fold accuracy is 		0.7868131756782532
Label0: 5 fold specificity is 	0.9120879120879121
Label0: 5 fold sensitivity is 	0.6615384615384615
Label0: 5 fold auc is 			0.7868131868131868