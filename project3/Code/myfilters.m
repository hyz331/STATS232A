function [F, filters, width, height] = myfilters

count = 0;

count = count + 1;
F{count} = [-1, 1];
count = count + 1;
F{count} = [-1; 1];

for count = 3:5
    F{count} = fspecial('log', (count-2)*2+1, (count-2)/3);
end

for i = 7
    for j = 0:30:150
        [a, b] = gaborfilter(i, j);
        count = count + 1;
        F{count} = a;
        count = count + 1;
        F{count} = b;
    end
end

for i = 1:count
    [m, n] = size(F{i});
    
    F{i} = F{i} - mean(mean(F{i})) * ones(m, n);
    F{i} = F{i} / sum(sum(abs(F{i})));
    
    filters(i, 1:m*n) = reshape(F{i}, 1, m*n);
    height(i) = n;
    width(i) = m;
end