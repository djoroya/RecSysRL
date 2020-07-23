function  [at,xt,rt,HistoTest,PriorKnowledge]  = FoolPolicy(HistoTest,PriorKnowledge,x0)
    %% Selecionamos las peliculas
    
    [~,imvs] = sort(HistoTest.Accept.rating,'ascend');
    imvs = imvs(1:2);

    at = HistoTest.Accept(imvs,:);
    
    %% Simulamos el comportamiento del usuario
    [maxrat,~] = max(at.rating);
    
    indexlist = [1 2];
    indstate = randsample(indexlist(at.rating == maxrat),1,true);
    
    xt = at(indstate,:);
    rt = at(indstate,:).rating;
    
    %% Removemos la pelicula que ha selecionado el usuario
    % para no volveer a recomendarlo
    
    HistoTest.Accept(imvs(indstate),:) = [];
end

