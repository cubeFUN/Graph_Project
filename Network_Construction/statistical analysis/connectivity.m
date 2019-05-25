function [x,visited] = connectivity( graph )
%	compute connectivity of a graph
%   x is number of isolated parts
%   "visited" marks each isolated parts
n=size(graph,1);
visited=zeros(n,1);
x=0;
for k=1:n
    if visited(k)==0
        x=x+1;
        visited(k)=x;
        queue=zeros(n,1);
        head=1;rear=1;queue(head)=k;
        while head<=rear
            i=queue(head);
            for j=1:n
                if graph(i,j)~=0 && visited(j)==0
                    visited(j)=x;
                    rear=rear+1;
                    queue(rear)=j;
                end
            end
            head=head+1;
        end
    end
end

end
