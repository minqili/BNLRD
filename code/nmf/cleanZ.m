function Z = cleanZ( Z )
    Z = Z(:,find(sum(Z)>0));
end


