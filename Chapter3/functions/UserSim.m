function [xt,rt,indstate] = UserSim(at,x0)

    %
    matat = table2array(at(:,6:end));
    pesos_sim = sum(matat.*x0,2)+1;
    pesos_sim = pesos_sim./sum(pesos_sim);

    pesos_rating = (1+at.rating)/2;
    %
    pesos = pesos_sim+pesos_rating;
    [maxrat,~] = max(pesos);
    
    indexlist = [1 2];
    indstate = randsample(indexlist(pesos == maxrat),1,true);
    %
    xt = at(indstate,:);
    rt = at(indstate,:).rating;
    
end

