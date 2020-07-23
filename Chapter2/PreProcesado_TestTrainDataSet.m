load('ndata/MoviesPreDataSet')
[nrows,~] = size(movies_accept);

MAcceptTrain = movies_accept(1:floor(nrows/2.9),:);
MRejectTrain = movies_reject(1:floor(nrows/2.9),:);
%
%
MRejectTest  = movies_reject(1+floor(nrows/2.9):end,:);
MAcceptTest  = movies_accept(1+floor(nrows/2.9):end,:);


save('ndata/MoviesDataSet','MAcceptTrain','MAcceptTest','MRejectTrain','MRejectTest')