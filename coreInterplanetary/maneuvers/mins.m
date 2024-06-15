function list = mins(A, A_max)
% for 2D arrays
    len1 = size(A, 1);
    len2 = size(A, 2);
    B = Inf(len1 + 2, len2 + 2);
    B(2:end-1, 2:end-1) = A;
    M = (A <= B(3:end, 2:end-1)) & (A <= B(3:end, 3:end)) &...
        (A <= B(2:end-1, 3:end)) & (A <= B(1:end-2, 3:end)) &...
        (A <= B(1:end-2, 2:end-1)) & (A <= B(1:end-2, 1:end-2)) &...
        (A <= B(2:end-1, 1:end-2)) & (A <= B(3:end, 1:end-2));
    list = [];
    for i = 1:len1
        for j = 1:len2
            if M(i,j) && (A(i,j) <= A_max)
                list = [list; i, j];
            end
        end
    end
end