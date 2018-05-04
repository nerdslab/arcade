function C0 = pad(C0_prev, sphere_sz, improb0_sz, improb1_sz)
%P Summary of this function goes here
%   Detailed explanation goes here
C0 = [];
for i = 1:size(C0_prev,1)
    curr_row = C0_prev(i,:);
    if curr_row(1) > sphere_sz && curr_row(1) < improb0_sz - sphere_sz &&...
            curr_row(2) > sphere_sz && curr_row(2) < improb1_sz - sphere_sz
            C0 = [C0; curr_row;];
    end
end
end

