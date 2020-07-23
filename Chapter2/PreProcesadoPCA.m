function  newtable = PreProcesadoPCA(movies,Allgen)

[Nmovies, ~]= size(movies);
%% acornatmos para los nombres para las graficas 
Allgen_short = {};
it = 0;
for igen = Allgen
    it = it + 1;
    
    if length(Allgen{it}) < 5
            Allgen_short{it} = Allgen{it};
    else
        Allgen_short{it} = [Allgen{it}(1:5) '.'];
    end
end
%%
movies_matrix = table2array(movies(:,3:end));
%%
[coeff, score, latent, tsquared, explained, mu] = pca(movies_matrix);

%%
figure(1)
clf
ip=plot(0:20,[0 ;cumsum(explained)],'o-')
yline(90)
xticks(1:2:22)
yticks(0:10:100)
yticklabels([num2str((0:10:100)'),repmat('%',11,1)])
grid on 
ylim([0 100])
xlabel('Componentes Principales')
%ip.Parent.Title.String = 'Variabilidad explicada';

print('../../Tesis/img/varexp.eps','-depsc')
%% Primera Componentes principales
Ncomp = 4;
angle = 90;
figure(1)
clf
%
subplot(Ncomp,1,1)
ip = plot(coeff(:,1),'o-');
ip.Parent.XAxisLocation = 'top';
xticks(1:20);
xticklabels(Allgen_short)
xtickangle(angle)
legend(['CP1'],'Location','southeast')
grid on 
yticks([])

ip.Parent.XAxis.FontSize = 9;
%
for i = 2:Ncomp
    subplot(Ncomp,1,i)
    ip = plot(coeff(:,i),'o-');
    ip.Parent.XAxis.FontSize = 9;
    xticks(1:20)
    xticklabels([])
    yticks([])

    legend(['CP',num2str(i)],'Location','southeast')
    grid on 
end

grid on 
xticks(1:20)
xticklabels(Allgen_short)
xtickangle(angle)
yticks([])
print('../../Tesis/img/firstPCA.eps','-depsc')

%% Veamos 100 peliculas en las dos primeras componentes 
mst = [];
indexmovies = [1 2 7 12 19 41 45 124 127 225 295 419];
%indexmovies = 1:Nmovies;

NN = length(indexmovies);
color = jet(NN);
iter = 0;
for idm =  indexmovies
    iter = iter + 1;
    imv = movies(idm,:);
    title = char(imv.title);
    title = title(1:end-6);
    %title = replace(title,' ',newline);
    mst(iter).title = title;
    x = table2array(imv(:,3:end));
    %
    x1 = dot(x,coeff(:,1));
    x2 = dot(x,coeff(:,2));
    x3 = dot(x,coeff(:,3));
    x4 = dot(x,coeff(:,4));

    % 
    mst(iter).x1 = x1;
    mst(iter).x2 = x2;
    mst(iter).x3 = x3;
    mst(iter).x4 = x4;

end
clf
scatter3([mst.x1],[mst.x2],[mst.x3],[],[mst.x4],'o')
xlabel('PC_1')
ylabel('PC_2')
zlabel('PC_3')
grid on 

newData = [[mst.x1]' [mst.x2]' [mst.x3]' [mst.x4]' ];
%%
itext = text([mst.x1],[mst.x2],[mst.x3],{mst.title},'FontSize',7);

for icolor = 1:NN
    itext(icolor).Color = color(icolor,:);
end

%% Nueva Base de Datos
new_movies_matrix = movies_matrix*coeff(:,1:11);

col_names = [repmat('PC',11,1),num2str((1:11)','%.2d')];
col_names = cellstr(col_names);

PCAtable = array2table(new_movies_matrix,'VariableNames',col_names);

newtable = [movies(:,1:2) PCAtable];
end

