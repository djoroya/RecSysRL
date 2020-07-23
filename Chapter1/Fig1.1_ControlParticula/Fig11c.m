%%
clear all
close all

% Denotaremos x_t \in X 
% Denotaremos a_t \in A
%%
% Matrix de MDP
% M una matrix de dimension [ n x n x m ]
%%   
n = 3;

% Control Izquierda <-
M(:,:,1) = [ [1 zeros(1,n-1)]         ;
             eye(n-1)  zeros(n-1,1)]'  ;

% Control = 
M(:,:,2) = eye(n);

% Control Derecha  ->

M(:,:,3) = [ zeros(n-1,1) eye(n-1)  ;
              [zeros(1,n-1) 1]         ]';
        
%%
% Donde n es la dimension de x_t, mientras que m es la dimension a_t
[~ ,n,m] = size(M);         
%% Graphs  
% fig = M2plotdigraphs(M);

%%
fr = @(s,a) 10*(s==2) - 1*(s~=2) -1*(a==1) - 1*(a==3);
%%
T = 10;

s0 = [0 1 0]';
st = zeros(3,T);
rt = zeros(1,T);

st(:,1) = s0;
at = randsample([1 2 3],T,true);
for t = 2:T
    st(:,t) = M(:,:,at(t-1))*st(:,t-1);
    rt(t) = fr(find(st(:,t-1)),at(t-1));
end
%%
st_index = arrayfun(@(it) find(st(:,it)),1:T);
%%
close all
%% Print 1.1
fig = figure(1);
fig = M2plotdigraphs(M);
print(fig,'../../Tesis/img/particula_estocastica_MDP','-depsc')

%% Print 1.2
fig = figure(3);
fig.Units = 'norm';
fig.Position = [0.1 0.1 0.4 0.4];
ax1 = subplot(1,3,1);
ax2 = subplot(1,3,2);
ax3 = subplot(1,3,3);

%
opt_labels = {'Interpreter','latex','FontSize',14};
opt_title  = {'FontWeight','normal','FontName', 'Latin Modern Roman'};
%
set(ax1,'defaultTextInterpreter','latex')
fig.CurrentAxes=ax1;
plot(st_index,0:T-1,'MarkerSize',19,'Marker','.')
xticks([1,2,3])
xlabel('$S_t$',opt_labels{:})
ylabel('$t$',opt_labels{:})
xlim([0.5 3.5])
grid on 
%
fig.CurrentAxes=ax2;
plot(at,1:T,'MarkerSize',19,'Marker','.')
xticks([1,2,3])
xticklabels({'(\leftarrow)','(=)','(\rightarrow)'})
xlabel('$A_t$',opt_labels{:})
ylabel('$t$',opt_labels{:})
xlim([0.5 3.5])
grid on 
%
fig.CurrentAxes=ax3;
plot(rt,1:T,'MarkerSize',19,'Marker','.')
xlim([-5 12])
xlabel('$R_t$',opt_labels{:})
ylabel('$t$',opt_labels{:})
grid on 

print(fig,'../../Tesis/img/MDP_evolution','-depsc')

