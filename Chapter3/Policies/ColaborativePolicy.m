function  [at,xt,rt,HistoTest,PriorKnowledge]  = ColaborativePolicy(HistoTest,PriorKnowledge,x0)
    %% Selecionamos las peliculas
    [nrow,~] = size(HistoTest.Accept);
    
    imvs = randsample(1:nrow,2,false);

    at = HistoTest.Accept(imvs,:);
    
    %% Simulamos el comportamiento del usuario
    [maxrat,~] = max(at.rating);
    
    indexlist = [1 2];
    indstate = randsample(indexlist(at.rating == maxrat),1,true);
    %
    indstate = randsample(indexlist,1,true);
    %
    xt = at(indstate,:);
    rt = at(indstate,:).rating;
    
    %% Removemos la pelicula que ha selecionado el usuario
    % para no volveer a recomendarlo
    
    HistoTest.Accept(imvs(indstate),:) = [];
end

