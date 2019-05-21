import scipy.io as sio
import numpy as np


T = sio.loadmat('./graphWithROIs_p.mat')
graphWithROIs = T.res

I = sio.loadmat('./imageWithROIs_p.mat')
imageWithROIs = I.res

nPetROIs = len(graphWithROIs)

features = np.zeros([nPetROIs, 32])

def min_max_span():
    # min&max spanning tree
    print('----------1+2----------')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        # max spanning tree always positive linear relative to the pixel of current case
        grapht=-graphWithROIs[k]
        graph_sparse = sparse(grapht)
        tree, pred = graphminspantree(graph_sparse, 'Method','Kruskal')
        features[k,0]=-tree.sum() / graphWithROIs[k].shape[0]

        grapht = graphWithROIs[k]
        graph_sparse = sparse(grapht)
        tree, _ = graphminspantree(graph_sparse, 'Method', 'Kruskal')
        features[k, 1] = tree.sum() / graphWithROIs[k].shape[0]

def min_max_eigenvalue():
    print('----------3+4----------')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        graph(np.isnan(graph)) = 0
        eigvector, eigvalue_ = np.linalg.eig(graph)[1]
        eigvalue = diag(eigvalue_)#todo []->()?
        features[k, 2] = np.max(eigvalue)
        features[k, 3] = np.min(eigvalue)

def number_of_nodes():
    print('5 number of nodes')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        features[k, 4] = graphWithROIs[k].shape[0]

def max_avg_node_degree():
    print('6 7 max node degree & average node degree')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        nNodes = graph.shape[0]
        MaxDegree = 0
        TotDegree = 0
        for i in range(0, nNodes):
            degree = 0
            for j in range(0, nNodes):
                if(graph[i,j]>0):
                    degree += 1
            TotDegree = TotDegree + degree
            if degree > MaxDegree:
                MaxDegree = degree
        features[k, 5] = MaxDegree
        features[k, 6] = TotDegree / nNodes

def max_avg_degree_w():
    print('8 9max node degree & average node degree(with weight)')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        nNodes = graph.shape[0]
        MaxDegree = 0
        TotDegree = 0
        for i in range(0, nNodes):
            degree = 0
            for j in range(0, nNodes):
                degree = degree + graph[i, j]
            TotDegree = TotDegree + degree
            if degree > MaxDegree:
                MaxDegree = degree
        features[k, 7] = MaxDegree
        features[k, 8] = TotDegree / nNodes

def network_density():
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        nNodes = graph.shape[0]
        if nNodes == 1:
            features[k, 9] = 1
        nEdges = 0
        for i in range(0, nNodes):
            for j in range(0, i-1):
                if graph[i,j]>0:
                    nEdges += 1
        density = 2 * nEdges / (nNodes * (nNodes - 1))
        features[k, 9] = density

def weighted_net_density():
    print('11 weighted network density')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        nNodes = graph.shape[0]
        if nNodes == 1:
            features[k, 10] = 1
        nEdges = 0
        for i in range(0, nNodes):
            for j in range(0, i-1):
                nEdges = nEdges + graph[i,j]
        density = 2 * nEdges / (nNodes * (nNodes - 1))
        features[k, 10] = density

# global efficiency


# max min and avg betweenness
def max_min_avg_betweenness():
    print('13 14 15 max, min and average betweenness')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        nNodes = graph.shape[0]
        betweenness = np.zeros(nNodes, 1)
        dist = graph
        path = np.zeros(nNodes, nNodes)
        for i in range(0, nNodes):
            for j in range(0, nNodes):
                if dist[i, j] == 0 and i != j:
                    dist[i, j] = inf
                if i == j or dist[i, j] != 0:
                    path[i, j] = j
        # TODO: I see a bug Find time to fix it here
        for t in range(0, nNodes):
            # TODO: this method is time costly try other algorithm to find shortest path
            for i in range(0, nNodes):
                for j in range(0, nNodes):
                    if dist[i,t] + dist[t,j] < dist[i,j]:
                        dist[i,j] = dist[i,t] + dist[t,j]
                        path[i,j] = path[i,t]
        for i in range(0, nNodes):
            for j in range(0, i-1):
                s = i
                t = j
                route = s
                
                while True:
                    if s == t:
                        break
                    route = [route, path[s,t]]
                    s = path[s,t]
                
                for t in range(0, route.shape[0]):
                    tt = route[t]
                    betweenness[tt] = betweenness[tt] + 1
        totalWay = nNodes * (nNodes - 1)
        betweenness = betweenness / totalWay

        betweennessMax = np.max(betweenness)
        betweennessMin = np.min(betweenness)
        betweennessAvg = np.mean(betweenness)
        features[k, 12] = betweennessMax
        features[k, 13] = betweennessMin
        features[k, 14] = betweennessAvg
        
def graph_energy():
    print('16 graph energy')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        graph[np.isnan(graph)] = 0
        ~, e = np.linalg.eig(graph)[1]
        energy = np.sum(np.abs(np.diag(e).real))
        features[k, 15] = energy

'''
def modularity():
    print('17 modularity')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        graph(np.isnan(graph)) = 0
        nNodes = graph.shape[0]
        VV = GCModulMax3(graph)
'''
def cluster_coefficient():
    print('18 19 20 cluster coeffient max,min,average')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        graph[np.isnan(graph)] = 0
        # TODO
        cluster_coeff = weighted_clust_coeff(graph)
        features[k, 17] = np.max(cluster_coeff)
        features[k, 18] = np.min(cluster_coeff)
        features[k, 19] = np.mean(cluster_coeff)


def eigenvalue_weights():
    print('21 eigenvalue weights')
    graph = graphWithROIs[k]
    graph(np.isnan(graph)) = 0
    eigvector, eigvalue_ = np.linalg.eig(graph)[1]
    eigvalue = np.diag(eigvalue_)
    eigvalue_abs = eigvalue #TODO? abs

    sorted_eigvalue, sorted_idx_eig = np.sort(eigvalue_abs)[::-1]
    t = np.int16(eigvalue.shape[1] * 0.05)
    sorted_eigvalue_top = sorted_eigvalue[1:t, 1]
    features[k, 20] = np.sum(sorted_eigvalue_top[:]) / np.sum(np.abs(sorted_eigvalue[:]))

def degree_distribution():
    print('22 degree distribution')
    for k in ranbe(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        graph = graphWithROIs[k]
        graph(np.isnan(graph)) = 0
        nNodes = graph.shape[0]
        degree = np.zeros([nNodes, 1])
        TotDegree = 0
        for i in range(0, nNodes):
            for j in range(0, nNodes):
                degree[i, 0] = degree[i, 0] + graph[i, j]
            TotDegree = TotDegree + degree[i, 0]
        features[k, 21] = degree.std(axis=0)

def heterogeneity():
    print('23 heterogeneity')
    for k in range(0, nPetROIs):
        print('Processing %d th records, waiting...'.format(k))
        NaIdx = np.isnan(imageWithROIs[k])
        PetROI = imageWithROIs[k]
        PetROI[NaIdx] = 0
        # TODO heterogeneityCalculateOld to python
        value = heterogeneityCalculateOld(PetROI, xyzStep[k, 0], xyzStep[k, 1], xyzStep[k, 2], 2)
        features[k, 22] = value

if __name__ == '__main__':
    



    # calculate features



