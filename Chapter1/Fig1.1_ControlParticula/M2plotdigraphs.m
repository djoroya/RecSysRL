function fig = M2plotdigraphs(M,parent)
%M2PLOTDIGRAPHS Summary of this function goes here
%   Detailed explanation goes here

if ~exist('parent')
   fig = gcf; 
else
   fig = parent;
end
[~ ,n,m] = size(M);         

fig.Units = 'norm';

fig.Position = [0.1 0.1 0.4 0.4];


YY = zeros(n,1);
XX = 1:n;
%
options = {'MarkerSize',10,'LineWidth',2, ...
           'ArrowSize',12,'XData',XX,'YData',YY, ...
           'NodeLabel',{'$s_1$','$s_2$','$s_3$'}  ...
           'NodeFontSize',21,'Interpreter','latex'};
izq_dg = digraph(M(:,:,1)); 
ax1 = subplot(3,1,1,'Parent',fig);
plot(izq_dg,options{:})
xticks(ax1,[])
yticks(ax1,[])
xlim(ax1,[0.5 3.5])
ylim(ax1,[-0.25 0.25])
title('$a: \{ \leftarrow \}$','Interpreter','latex','FontSize',16)
%
der_dg = digraph(M(:,:,2)); 
ax2 = subplot(3,1,2,'Parent',fig);
plot(der_dg,options{:})
xticks(ax2,[])
yticks(ax2,[])
xlim(ax2,[0.5 3.5])
ylim(ax2,[-0.05 0.05])
title('$a: \{ = \}$','Interpreter','latex','FontSize',15)
%
nt_dg = digraph(M(:,:,3)); 
ax3 = subplot(3,1,3,'Parent',fig);
plot(nt_dg,options{:})
xticks(ax3,[])
yticks(ax3,[])
xlim(ax3,[0.5 3.5])
ylim(ax3,[-0.25 0.25])
title('$a: \{\rightarrow\}$','Interpreter','latex','FontSize',15)
%%
end

