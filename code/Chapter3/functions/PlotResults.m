function PlotResults(results,T,names)
opts = {'Interpreter','latex','FontSize',15};
opts1 = {'Interpreter','latex','FontSize',12};
opts2 = {'Interpreter','latex','FontSize',8};

%% GRAPHS
figure(1)
clf
subplot(2,1,1)
hold on 
itr = 0;
color     = {[1 0.8 0.8],[0.8 0.8 1],[0.8 1.0 0.8],[1 1 0.8]};
colormean = {[1 0.4 0.4],[0.4 0.4 1],[0.4 1.0 0.4],[1 1 0.4]};

for iresult = results
    itr = itr + 1;
    for iexp = iresult.experiments
        cumrt = cumsum([iexp.rt]')./(1:(T-1));
        plot(cumrt,'Color',color{itr})
    end
end
% PLOT MEANS
itr = 0;
for iresult = results
    itr = itr + 1;
    mn = mean([iresult.experiments.rt]');
    cumrt = cumsum(mn)./(1:(T-1));
    lines(itr) = plot(cumrt,'Color',colormean{itr},'LineWidth',2);
end
%
namescell = {results.name};
legend(lines,names{:},'Location','northeastoutside',opts2{:})

xlabel('t',opts1{:})
ylabel('$G^{\pi}_t$',opts{:})
xlim([1 T/2])
ylim([-0.65 1])
title('Recompensa Acumulada',opts1{:})
grid on
%%
subplot(2,1,2)
hold on
itr = 0;
for iresult = results
    itr = itr + 1;
    for iexp = iresult.experiments
        cumrt = [iexp.rt]';
        plot(cumrt,'Color',color{itr})
    end
end
% PLOT MEANS
itr = 0;
for iresult = results
    itr = itr + 1;
    mn = mean([iresult.experiments.rt]');
    lines(itr) = plot(mn,'Color',colormean{itr},'LineWidth',2);
end
namescell = {results.name};
legend(lines,names{:},'Location','northeastoutside',opts2{:})

opts = {'Interpreter','latex','FontSize',15};
xlabel('t',opts1{:})
ylabel('$r^\pi(t)$',opts{:})
xlim([1 T/2])
ylim([-0.65 1])
title('Recompensa',opts1{:})
grid on
end

