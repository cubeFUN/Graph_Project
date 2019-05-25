
%	compute graph-based features
%	input: ROI graph(graphWithROIs), 
%	ROI matrix(imageWithROIs), 
%	heterogeneity parameters(xyzStep), 
%	SUV mean parameters(SUV para)
%	output: features(21 graph-based features+heterogeneity+SUVmean)
clear

addpath('./Compute graph-based features');
addpath('./statistical analysis')
addpath('../Network Analysis')
T = load('./graphWithROIs_all.mat');
S = load('./imageWithROIs_all.mat');
graphWithROIs = T.dataset.graphWithROIs;
imageWithROIs = S.dataset.imageWithROIs;

rootPath = './lung data_latest version/radiogenomics_CT.mat';
lung_data = load(rootPath);
xyzStep = lung_data.dataset.xyzStep;

nPetROIs=length(graphWithROIs);

features=zeros(nPetROIs,32);
%calculate features
%min&max spanning tree
%%
ignore_case = [10,22,28,35,39,51,59,60,62,85,92,94,115,119,124,125,127,128,129,130,132,136];
%ignore_case = [];
fprintf('----------1+2----------');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
    fprintf('Processing %d th records, waiting...\n',k);
    % max ??????????????? ????????????case???pixel????????????????????????????????????
    % ???????????????case ROI???????????????57????????????case?????????654
    % ???????????????feature????????????????????????????????????
    grapht=-graphWithROIs{k};
    graph_sparse=sparse(grapht);
    [tree,pred]=graphminspantree(graph_sparse,'Method', 'Kruskal');
    features(k,1)=-sum(sum(tree)) / size(graphWithROIs{k},1);
    
    %min ???????????????
    grapht=graphWithROIs{k};
    graph_sparse=sparse(grapht);
    [tree,~]=graphminspantree(graph_sparse,'Method', 'Kruskal');
    features(k,2)=sum(sum(tree)) / size(graphWithROIs{k},1);
end

%min&max eigenvalue
fprintf('----------3+4----------');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
    fprintf('Processing %d th records, waiting...\n',k);
    features(k,5)=size(graphWithROIs{k},1);
end

%max node degree & average node degree
disp('6 7 max node degree & average node degree');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
%{
disp('12 global efficiency');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    graph(isnan(graph)) = 0;
    graph_sparse=sparse(graph);
    nNodes=size(graph,1);
    if nNodes==1
        features(k,12)=1;
        continue;
    end
    dist=graphallshortestpaths(graph_sparse);
    efficiency=0.0;
    for i=1:nNodes
        for j=1:i-1
            efficiency=efficiency+1.0/dist(i,j);
        end
    end
    efficiency=efficiency/((nNodes*nNodes-nNodes)/2);
    features(k,12)=efficiency;
end
%}

%max, min and average betweenness
%end
% ?????????????????????????????????????????????????????????????????????????????????????????????
% ????????????????????? ????????? ????????????


disp('13 14 15 max, min and average betweenness');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
    fprintf('Processing %d th records, waiting...\n',k);
    graph=graphWithROIs{k};
    nNodes=size(graph,1);
    betweenness=zeros(nNodes,1);
    dist=graph;
    %graph_sparse=sparse(graph);
    %dist = graphallshortestpaths(graph_sparse);
    path=zeros(nNodes,nNodes);%not connected

    % undirected graph no need to scan all i j & j i
    for i=1:nNodes
        for j=i:nNodes
            if dist(i,j)==0 && i~=j
                dist(i,j)=inf;
                dist(j,i)=inf;
            else
                dist(i,j) = abs(dist(i,j)); %??????????????????????????????????????????
                dist(j,i) = dist(i,j);
                path(i,j)=j; %initial path
                path(j,i)=i;
            end
        end
    end

    %floyd algorithm
    for t=1:nNodes
        for i=1:nNodes
            for j=1:nNodes
                if dist(i,t) + dist(t,j) < dist(i,j)
                    dist(i,j) = dist(i,t) + dist(t,j);
                    path(i,j) = path(i,t);
                end
            end
        end
    end

    %{            
    for i=1:nNodes
        i
        %disp('first loop');
        for j=1:nNodes
            if dist(i,j)==0 && i~=j
                % ???????????????????????????
                dist(i,j)=inf;
            end
            if i==j || dist(i,j)~=0
                path(i,j)=j;
            end
        end
    end
    
    %dist = sparse(dist)
    %dist = graphallshortestpaths(dist)

    for t=1:nNodes
        t
        % ????????????????????????????????????????????????????????? 
        % path????????????????????????????????????????????????????????????????????????
        for i=1:nNodes
            for j=1:nNodes %1:nNodes->i:nNodes
                if dist(i,t)+dist(t,j) < dist(i,j)
                    dist(i,j)=dist(i,t)+dist(t,j);
                    path(i,j)=path(i,t);
                end
            end
        end
    end
    %}
    
    for i=1:nNodes
        %i
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
    
    totalWay = nNodes * (nNodes-1) / 2; % /2
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
    fprintf('Processing %d th records, waiting...\n',k);
    NaIdx=find(isnan(imageWithROIs{k}));
    PetROI=imageWithROIs{k};
    PetROI(NaIdx)=0;
    value=heterogeneityCalculateOld(PetROI,xyzStep(k,1),xyzStep(k,2),xyzStep(k,3),2);
    features(k,23)=value;
end

%SUV mean
%{
disp('24 SUV mean');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
     fprintf('Processing %d th records, waiting...\n',k);
     PetROI=imageWithROIs{k};
%     ?????????????????????????????????????????????SUV???????????????????????????features(k,23) = SUV?????????
     features(k,24)=SUVmean(k,1);
end
%save ./Data_1108/features_24.mat features -v7.3

%??????MIT??????network feature?????????
%}
%edge number
disp('25 edge numbers');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
    fprintf('Processing %d th records, waiting...\n',k);
    PetROI=graphWithROIs{k};
    features(k,25) = numedges(PetROI);
end

%pearsondegreeCorr
disp('26');
for t=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
     fprintf('Processing %d th records, waiting...\n',k);
     PetROI=graphWithROIs{k};
     features(k,27) = s_metric(PetROI);
end


disp('28 29 30 The max and min eigenvalues of the Laplacian of the graph');
for k=1:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
     fprintf('Processing %d th records, waiting...\n',k);
     PetROI=graphWithROIs{k};
     PetROI(isnan(PetROI)) = 0;
     eigvalue = graph_spectrum(PetROI);

     eigvalue_abs=eigvalue;
     [sorted_eigvalue,sorted_idx_eig]=sort(eigvalue_abs,'descend');
     t=int16(length(eigvalue)*0.05);
     sorted_eigvalue_top=sorted_eigvalue(1:t,1);
     
     features(k,28)=max(eigvalue);
     features(k,29)=eigvalue(length(eigvalue)-1);
     features(k,30)=sum(sorted_eigvalue_top(:))/sum(abs(sorted_eigvalue(:)));
end

%% too slow, avoid
% % ????????????????????????????????????

disp('31 diameter of the graph');
for k=nPetROIs:nPetROIs
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
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
    if ismember(k, ignore_case)
        fprintf('Ignoring %d th records, next...\n',k);
        continue;
    end
    fprintf('Processing %d th records, waiting...\n',k);
    PetROI=graphWithROIs{k};
    PetROI(isnan(PetROI)) = 0;
    features(k,32) = ave_path_length(PetROI);
end

%%
disp('features scaled')
features_scaled = zeros(size(features));
features(isnan(features)) = 0;
for i = 1:size(features,2)
    MAX = max(features(:,i));
    MIN = min(features(:,i));
    features_scaled(:,i) = (features(:,i) - MIN) ./ (MAX - MIN);
end


disp('save')
save ./features_scaled_CT_v0.mat features_scaled -v7.3
save ./features_noscaled_CT_v0.mat features -v7.3
