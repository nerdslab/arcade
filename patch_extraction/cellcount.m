function [cell_counts] = cellcount(patch_mx)
%CELLCOUNT Summary of this function goes here
%   Detailed explanation goes here


patch_mx_updated = [];

for j = 1:length(patch_mx(:,1))
    row = [];
    for i = 1:length(patch_mx(1,:))
        if patch_mx(j,i) > 0
            row = [row 1];
        else
            row = [row 0];
        
        
        end
    end
    patch_mx_updated = [patch_mx_updated; row];
end

cell_counts = [];
for n = 1:length(patch_mx_updated(:,1))
    s = sum(patch_mx_updated(n,:));
    cell_counts = [cell_counts; s];  
    
end


end

