
%	compute graph-based features
%	input: ROI graph(graphWithROIs), 
%	ROI matrix(imageWithROIs), 
%	heterogeneity parameters(xyzStep), 
%	SUV mean parameters(SUV para)
%	output: features(21 graph-based features+heterogeneity+SUVmean)
clear

addpath('../Compute graph-based features');
addpath('../statistical analysis')
T = load('./graphWithROIs.mat');

graphWithROIs = T.res;
nPetROIs=length(graphWithROIs);

features=zeros(nPetROIs,32);
%calculate features
%min&max spanning tree
%%
fprintf('----------1+2----------');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    % max 最大生成树 会和当前case的pixel数目多少有关（通常成正比
    % 比如第一个case ROI区域边长为57，第三个case边长为654
    % 对应两者的feature也是相差一个数量级的关系
    grapht=-graphWithROIs{k};
    graph_sparse=sparse(grapht);
    [tree,pred]=graphminspantree(graph_sparse,'Method', 'Kruskal');
    features(k,1)=-sum(sum(tree)) / size(graphWithROIs{k},1);
    
    %min 最小生成树
    grapht=graphWithROIs{k};
    graph_sparse=sparse(grapht);
    [tree,~]=graphminspantree(graph_sparse,'Method', 'Kruskal');
    features(k,2)=sum(sum(tree)) / size(graphWithROIs{k},1);
end

%min&max eigenvalue
fprintf('----------3+4----------');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    graph(isnan(graph)) = 0;
    [eigvector,eigvalue_]=eig(graph);
    eigvalue=diag(eigvalue_);
    features(k,3)=max(eigvalue);
    features(k,4)=min(eigvalue);
end

%number of nodes
% sum(sum(sum(~(isnan(tmp)))))
disp('5 number of nodes');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    features(k,5)=size(graphWithROIs{k},1);
end

%max node degree & average node degree
disp('6 7 max node degree & average node degree');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    nNodes=size(graph,1);
    MaxDegree=0;TotDegree=0;
    for i=1:nNodes
        degree=0;
        for j=1:nNodes
            if (graph(i,j)>0)
            	degree=degree+1;
            end
        end
        TotDegree=TotDegree+degree;
        if degree>MaxDegree
            MaxDegree=degree;
        end
    end
    features(k,6)=MaxDegree;
    features(k,7)=TotDegree/nNodes;
end

%max node degree & average node degree(with weight)
disp('8 9max node degree & average node degree(with weight)');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    nNodes=size(graph,1);
    MaxDegree=0;TotDegree=0;
    for i=1:nNodes
        degree=0;
        for j=1:nNodes
            degree=degree+graph(i,j);
        end
        TotDegree=TotDegree+degree;
        if degree>MaxDegree
            MaxDegree=degree;
        end
    end
    features(k,8)=MaxDegree;
    features(k,9)=TotDegree/nNodes;
end

%network density
disp('10 network density');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    nNodes=size(graph,1);
    if nNodes==1
        features(k,10)=1;
        continue;
    end
    nEdges=0;
    for i=1:nNodes
        for j=1:i-1
            if graph(i,j)>0
                nEdges=nEdges+1;
            end
        end
    end
    density=2*nEdges/(nNodes*(nNodes-1));
    features(k,10)=density;
end

%weighted network density
disp('11 weighted network density');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    nNodes=size(graph,1);
    if nNodes==1
        features(k,11)=1;
        continue;
    end
    nEdges=0;
    for i=1:nNodes
        for j=1:i-1
            nEdges=nEdges+graph(i,j);
        end
    end
    density=2*nEdges/(nNodes*(nNodes-1));
    features(k,11)=density;
end

% %global efficiency
% disp('12 global efficiency');
% for k=1:nPetROIs
%     fprintf('Processing %d th records, waiting...\n',k);
%     graph=graphWithROIs{k};
%     graph(isnan(graph)) = 0;
%     graph_sparse=sparse(graph);
%     nNodes=size(graph,1);
%     if nNodes==1
%         features(k,12)=1;
%         continue;
%     end
%     dist=graphallshortestpaths(graph_sparse);
%     efficiency=0.0;
%     for i=1:nNodes
%         for j=1:i-1
%             efficiency=efficiency+1.0/dist(i,j);
%         end
%     end
%     efficiency=efficiency/((nNodes*nNodes-nNodes)/2);
%     features(k,12)=efficiency;
% end

%max, min and average betweenness
%end
% 中介中心性指的是一个结点担任其它两个结点之间最短路的桥梁的次数
% 这个要超级久的 还没跑 晚上跑吧
disp('13 14 15 max, min and average betweenness');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    nNodes=size(graph,1);
    betweenness=zeros(nNodes,1);
    dist=graph;
    path=zeros(nNodes,nNodes);
    for i=1:nNodes
        i
        %disp('first loop');
        for j=1:nNodes
            if dist(i,j)==0 && i~=j
                % 不连通就记为正无穷
                dist(i,j)=inf;
            end
            if i==j || dist(i,j)~=0
                path(i,j)=j;
            end
        end
    end
    for t=1:nNodes
        t
        % 寻找时候可以通过第三点来找到更短的路径 
        % path记录的是所经过的中间点（如果没有的话就用终点代替
        for i=1:nNodes
            for j=1:nNodes
                if dist(i,t)+dist(t,j) < dist(i,j)
                    dist(i,j)=dist(i,t)+dist(t,j);
                    path(i,j)=path(i,t);
                end
            end
        end
    end
    for i=1:nNodes
        i
        for j=1:i-1
            s=i;t=j;route=s;
            while true
                if s==t
                    break;
                end
                route=[route,path(s,t)];
                s=path(s,t);
            end
            for t=1:length(route)
                tt=route(t);
                betweenness(tt)=betweenness(tt)+1;
            end
        end
    end
    totalWay = nNodes * (nNodes-1);
    betweenness = betweenness ./ totalWay;
    
    betweennessMax=max(betweenness);
    betweennessMin=min(betweenness);
    betweennessAvg=mean(betweenness);
    features(k,13)=betweennessMax;
    features(k,14)=betweennessMin;
    features(k,15)=betweennessAvg;
end

%graph energy
disp('16 graph energy');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    graph(isnan(graph)) = 0;
    [~,e]=eig(graph);
    energy=sum(abs(real(diag(e))));
    features(k,16)=energy;
end

%modularity 
disp('17 modularity');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    graph(isnan(graph)) = 0;
    nNodes=size(graph,1);
    VV = GCModulMax3(graph);
    Q = QFModul(VV,graph);
    features(k,17)=Q;
end

%cluster coeffient max,min,average
disp('18 19 20 cluster coeffient max,min,average');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    graph(isnan(graph)) = 0;
    cluster_coeff=weighted_clust_coeff(graph);
    features(k,18)=max(cluster_coeff);
    features(k,19)=min(cluster_coeff);
    features(k,20)=mean(cluster_coeff);
end

%top 5\% eigenvalue weights
disp('21 eigenvalue weights');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    graph(isnan(graph)) = 0;
    [eigvector,eigvalue_]=eig(graph);
    eigvalue=diag(eigvalue_);
    eigvalue_abs=eigvalue;
    [sorted_eigvalue,sorted_idx_eig]=sort(eigvalue_abs,'descend');
    t=int16(length(eigvalue)*0.05);
    sorted_eigvalue_top=sorted_eigvalue(1:t,1);
    features(k,21)=sum(sorted_eigvalue_top(:))/sum(abs(sorted_eigvalue(:)));
end

%% added attributions
% degree distribution
disp('22 degree distribution');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    graph(isnan(graph)) = 0;
    nNodes=size(graph,1);
    degree = zeros(nNodes,1);
    TotDegree = 0;
    for i=1:nNodes
        for j=1:nNodes
            degree(i,1)=degree(i,1)+graph(i,j);
        end
        TotDegree=TotDegree+degree(i,1);
    end
    features(k,22) = std(degree);
    % features(k,21)=sum(sorted_eigvalue_top(:))/sum(abs(sorted_eigvalue(:)));
end

%only for comparison...
%heterogeneity
disp('23 heterogeneity');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    NaIdx=find(isnan(imageWithROIs{k}));
    PetROI=imageWithROIs{k};
    PetROI(NaIdx)=0;
    value=heterogeneityCalculateOld(PetROI,xyzStep(k,1),xyzStep(k,2),xyzStep(k,3),2);
    features(k,23)=value;
end

%SUV mean
% disp('24 SUV mean');
% for k=1:nPetROIs
%      fprintf('Processing %d th records, waiting...\n',k);
%      PetROI=imageWithROIs{k};
%      % 如果已知的已经是除以体重以后的SUV了，那么这里就直接features(k,23) = SUV就好了
%      features(k,24)=SUVmean(k,1);
% end
% save ./Data_1108/features_24.mat features -v7.3

%% 增加MIT提取network feature的代码

%edge number
disp('25 edge numbers');
for k=1:nPetROIs
     fprintf('Processing %d th records, waiting...\n',k);
     PetROI=graphWithROIs{k};
     features(k,25) = numedges(PetROI);
end

%edge number
disp('26');
for t=1:nPetROIs
     fprintf('Processing %d th records, waiting...\n',t);
     M=graphWithROIs{t};
     [rows,~]=size(M);
     won=ones(rows,1);
     k=won'*M;
     ksum=won'*k';
     ksqsum=k*k';
     xbar=ksqsum/ksum;
     num=(won'*M-won'*xbar)*M*(M*won-xbar*won);
     M*(M*won-xbar*won);
     kkk=(k'-xbar*won).*(k'.^.5);
     denom=kkk'*kkk;
     prs=num/denom;
     features(t,26) = prs;
end

disp('27 sum of products of degrees across all edges');
for k=1:nPetROIs
     fprintf('Processing %d th records, waiting...\n',k);
     PetROI=graphWithROIs{k};
     features(k,27) = sMetric(PetROI);
end

disp('28 29 30 The max and min eigenvalues of the Laplacian of the graph');
for k=1:nPetROIs
     fprintf('Processing %d th records, waiting...\n',k);
     PetROI=graphWithROIs{k};
     PetROI(isnan(PetROI)) = 0;
     eigvalue = graphSpectrum(PetROI);

     eigvalue_abs=eigvalue;
     [sorted_eigvalue,sorted_idx_eig]=sort(eigvalue_abs,'descend');
     t=int16(length(eigvalue)*0.05);
     sorted_eigvalue_top=sorted_eigvalue(1:t,1);
     
     features(k,28)=max(eigvalue);
     features(k,29)=eigvalue(length(eigvalue)-1);
     features(k,30)=sum(sorted_eigvalue_top(:))/sum(abs(sorted_eigvalue(:)));
end

%% too slow, avoid
% % 没算完！！！太慢了！！！
disp('31 diameter of the graph');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    PetROI=graphWithROIs{k};
    PetROI(isnan(PetROI)) = 0;
   % if(size(PetROI,1) > 5000)
   %    features(k,31) = 0;
   % else
       features(k,31) = diameter(PetROI);
   % end
end

disp('32 Number of star motifs of the graph');
for k=1:nPetROIs
    fprintf('Processing %d th records, waiting...\n',k);
    PetROI=graphWithROIs{k};
    PetROI(isnan(PetROI)) = 0;
    features(k,32) = avePathLength(PetROI);
end

%%
features_scaled = zeros(size(features));
features(isnan(features)) = 0;
for i = 1:size(features,2)
    MAX = max(features(:,i));
    MIN = min(features(:,i));
    features_scaled(:,i) = (features(:,i) - MIN) ./ (MAX - MIN);
end
save ./features_scaled.mat features_scaled -v7.3
