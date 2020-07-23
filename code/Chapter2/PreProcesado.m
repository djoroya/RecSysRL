clear 
[ratings] = RatingsData;
movies = MovieData;
%%
% Tomamos todos los generos en una cleda
Allgen = join(cellstr(movies.genres),'|');
Allgen = Allgen{1};
Allgen = strsplit(Allgen,'|');
Allgen = unique(Allgen);


%% Creamos una base de datos con la columnas referentes a cada genero de pelicula
Nmovies = length(movies.movieId);
Ngen    = length(Allgen);

Mmg = zeros(Nmovies,Ngen);
iter = 0;
for imov = 1:Nmovies
    iter = iter + 1;
    Mmg(iter,:) = arrayfun(@(i)contains(movies.genres(imov),Allgen{i}),1:length(Allgen));
end
% normalizacion de vectores
%Mmg = Mmg./sqrt(sum(Mmg,2));
%
Mmg = array2table(Mmg);
Mmg.Properties.VariableNames = Allgen;
%
movies = [movies(:,1:2) Mmg];
%%
%save('ndata/moviesfeatures.csv')
%% Analisis de componentes principales 
movies = PreProcesadoPCA(movies,Allgen);
%% Cruzamos la base de datos movies con la base de datos de ratings
%  Asi tenemos las columnas de generos agregadas a la base de datos
%  original
Nrating = length(ratings.movieId);
indxs = zeros(Nrating,1);
for i = 1:Nrating
    indxs(i) = find(movies.movieId == ratings.movieId(i));
end
moviesratings = movies(indxs,:);
moviesratings = [moviesratings(:,2) ratings(:,1:4) moviesratings(:,3:end)];

%% Ordenamos en el tiempo todas las interaciones de la base de datos moviesratings
[~,indmovie] = sort(moviesratings.timestamp);
moviesratings = moviesratings(indmovie,:);
%% Para cada usuario comprobamos que no tenga instancias con el mismo timestamp. 
% Esto remueve los usuarios que no tengan una trayectoria en el tiempo
% clara. Asi nos evitamos anbiguedad en la base de datos y cogemos un orden
% correcto para cada usuario

mr_user_all =moviesratings([],:);
users = unique(moviesratings.userId);

for iuser = users' 
    mr_user = moviesratings(moviesratings.userId == iuser,:);
    if length(unique(mr_user.timestamp)) == length(mr_user.timestamp)
        % Normalizamos el rating para cada usuario. la peor película tendra
        % una puntacion -1 y la mejor +1
        rmax = max(mr_user.rating);
        rmin = min(mr_user.rating);

        mr_user.rating = 2*(mr_user.rating - rmin)/(rmax-rmin) - 1;
        mr_user_all = [mr_user_all;mr_user];
        
    else
        fprintf(['Existen un problema en la recogida de datos para el usuario:',num2str(iuser),'\n'])
    end
end

%% La base de datos final es mr_user_all
mr_user_all;

%% Ahora Creamos la base de datos de películas que el usuario ha rechazado. 
% Esta es una base de datos ficticia que creamos para recrear el proceso de
% elecion del usuario

% Creamos una película que este en el historial del usuario pero que sea
% peor o igual

mr_user_all_reject = mr_user_all;

[nrow,~] = size(mr_user_all);
for irow = 1:nrow
    % Buscamos el indice de la pelicula que va a rechazar el usuario
    % 
    iuser = mr_user_all.userId(irow);
    
    posibleindexs = ( mr_user_all.userId         ==  iuser              ).* ...
                    ( mr_user_all(irow,:).rating >  mr_user_all.rating );
    
    try
        index = randsample(find(posibleindexs),1,true);
    catch
        index = irow;
    end
    
     mr_user_all_reject(irow,[1 3 4])   = mr_user_all(index,[1 3 4]);
     mr_user_all_reject(irow,6:end) = mr_user_all(index,6:end);
     %
     fprintf(['row: ',num2str(irow),'\n'])

end

%%


movies_accept = mr_user_all;
movies_reject = mr_user_all_reject;

save('ndata/MoviesPreDataSet','movies_accept','movies_reject')

%%

%%

