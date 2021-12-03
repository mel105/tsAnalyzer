function idx = standardizeIndex(idx)
nextID = 1;
reorderIdx = zeros(max(idx), 1);
for ii=1:length(idx)
    if reorderIdx(idx(ii)) == 0
        reorderIdx(idx(ii)) = nextID;
        nextID = nextID+1;
    end
end
idx = reorderIdx(idx);
end
