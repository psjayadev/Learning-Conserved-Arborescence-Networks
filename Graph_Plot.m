%% Plotting the graph of the network

function Graph_Plot(index)
n = size(index,2);
s = [];
t = [];
Edges = [];
for i=1:n-1
    s = [s i];
    t = [t index(i)];
    Edges = [Edges index(i)];
end
treeplot(index);
[b,c]=treelayout(index);
b=b';
c=c';
name=cellstr(num2str((1:n)'));
text(b(:,1),c(:,1),name,'VerticalAlignment','bottom','HorizontalAlignment','right');