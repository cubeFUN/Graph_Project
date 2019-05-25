function [unconnectedList,connectedList,graphWithROIs_independent,labels_independent]=splitGraph(graphWithROIs,labels)
unconnectedList=[];
connectedList=[];
graphWithROIs_independent={};
labels_independent=[];
nPetROIs=size(graphWithROIs,1);
for i=1:nPetROIs
    graph=graphWithROIs{i};
    [conn, segmented]=connectivity(graph);
    if conn>1
        fprintf('unconnected: %d,%d\n',i,conn);
        unconnectedList=[unconnectedList;i];
        for k=1:conn
            vertices=[];
            for t=1:length(segmented)
                if segmented(t)==k
                    vertices=[vertices;t];
                end
            end
            nVertices=length(vertices);
            if nVertices>30
                new_graph=zeros(nVertices,nVertices);
                for t1=1:nVertices
                    for t2=1:nVertices
                        new_graph(t1,t2)=graph(vertices(t1),vertices(t2));
                    end
                end
                graphWithROIs_independent=[graphWithROIs_independent;new_graph];
                labels_independent=[labels_independent;labels(i)];
            end
        end
    else
        fprintf('connected: %d, %d\n',i,conn);
        connectedList=[connectedList;i];
        graphWithROIs_independent=[graphWithROIs_independent;graphWithROIs{i}];
        labels_independent=[labels_independent;labels(i)];
    end
end

end
