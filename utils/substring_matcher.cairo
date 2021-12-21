# Given an input array A and another input array B where len(B)
# < len(A) output 1 if B is a substring of A, and 0 otherwise.
# For example:
# - A = [1, 2, 3, 4, 5]
# - B = [2, 3]
# - out = 1

func substring_matcher(a_len: felt, a: felt*, b_len: felt, b: felt*) -> (res):
    alloc_locals
    let c = a_len - b_len - 1

    let (res) = is_sub_array(a_len, a, b_len, b, 0, 0)
    return (res=res)
end

func is_sub_array(a_len: felt, a: felt*, b_len: felt, b: felt*, i, j) -> (res):

    # if i > a_len && j > b_len
    # iteration complete. no match found
    if i + j == a_len + b_len: 
        return (res=0)
    end

    if [a+i] == [b+j]:
        if j + 1 == b_len:
            return (res=1)
        end

        return is_sub_array(a_len, a, b_len, b, i+1, j+1)
    end
    
    return is_sub_array(a_len, a, b_len, b, i-j+1, 0)
end
