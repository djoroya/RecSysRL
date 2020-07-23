function profiles = Historial2MatrixUserItem(Histo)

    
    UserIds = unique(Histo.userId);
    
    profiles = zeros(length(UserIds),24);
%     for iuser = UserIds'
%         profiles(i,:) = mean(table2array(Histo(Histo.userId == iuser,5:end)));
%     end
end

