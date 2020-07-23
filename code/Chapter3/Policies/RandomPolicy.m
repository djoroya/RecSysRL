function  [at,xt,rt,HistoTest,PriorKnowledge]  = RandomPolicy(HistoTest,PriorKnowledge,x0)
    %% Selecionamos las peliculas
    [nrow,~] = size(HistoTest.Accept);
    
    imvs = randsample(1:nrow,2,false);

    at = HistoTest.Accept(imvs,:);
    
    %% Simulamos el comportamiento del usuario
    
    [xt,rt,indstate] = UserSim(at,x0);
    
    %% Removemos la pelicula que ha selecionado el usuario
    % para no volveer a recomendarlo
    
    HistoTest.Accept(imvs(indstate),:) = [];
end

