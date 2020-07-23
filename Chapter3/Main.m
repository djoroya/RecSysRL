clear 
load('MoviesDataSet.mat')
%%
% Selecion de usuario 
userIds_train = unique(MAcceptTest.userId);
iUserId = userIds_train(1);
%%
% Train Data
iMAcceptTrain = MAcceptTrain( MAcceptTrain.userId  == iUserId , : );
iMRejectTrain = MRejectTrain( MRejectTrain.userId  == iUserId , : );
% Test Data
iMAcceptTest  = MAcceptTest ( MAcceptTest.userId   == iUserId , : );

%clear('MAcceptTest','MAcceptTrain','MRejectTest','MRejectTrain')
%%
%%
HistoTest.Accept = iMAcceptTest;
%
HistoTrain.Accept = iMAcceptTrain;
HistoTrain.Reject = iMRejectTrain;

%%
Historial2MatrixUserItem(MAcceptTest);
%%
PriorKnowledge.HistoTrain = HistoTrain;

%%
%% Test Loop

[T,~] = size(iMAcceptTest);

% Probamos distintas políticas
policies = {@RandomPolicy,@CheaterPolicy,@FoolPolicy};
%
itp = 0;
% Numero de experimentos
Nexp = 20;

%
for ipolicy = policies
    itp = itp + 1;
    % creamos una structura con propiedad name
    results(itp).name = func2str(ipolicy{:});
    % Realizamos varios experimentos
    for iexp = 1:Nexp
        x0 = table2array(iMAcceptTrain(end,6:end));

        % Guardamos el historial para el test
        iHistoTest = HistoTest;
        % inicializamos la trayectoria
        xt = iMAcceptTrain(ones(T-1,1),:);
        at = {};
        rt = zeros(T-1,1);
        for t = 1:T-1
            % El agente seleciona una accion
            [at{t},x,rt(t),iHistoTest,PriorKnowledge] = ipolicy{:}(iHistoTest,PriorKnowledge,x0);
            % Guardamos la trayectoria
            xt(t,:) = x;
            % Actualizamos el estado anterior
            x0 = table2array(x(1,6:end));
        end
        % guardamos los resultados
        results(itp).experiments(iexp).rt = rt;
        results(itp).experiments(iexp).xt = xt;
        results(itp).experiments(iexp).at = at;
    end
    
end

%%
names = {'Aleatoria','Tramposa','Tonta'};
PlotResults(results,T,names)
print('../../Tesis/img/policyref.eps','-depsc')
%% Componente principales


