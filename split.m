function bg_split = split(bg, split_sequence)
bg_split = bg;
[m,n] = size(bg);
for i = 1:m
    if split_sequence(i)>0
        for j = 1:n
            if bg_split(i,j) > -1
                if bg_split(split_sequence(i),j) > -1
                    bg_split(split_sequence(i),j) = -1;
                else
                    bg_split(split_sequence(i),j) = bg_split(i,j);
                end
            end
        end
    end
end
end