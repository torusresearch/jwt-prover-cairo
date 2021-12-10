# Implementaiton of endsWith.circom

# Given an input array and a target array, output 1 if the
# latter matches the former at its tail end, and 0 otherwise.

# For example:
# - input  = [1, 2, 3, 4, 5]
# - target = [0, 0, 0, 4, 5]
# - targetLen = 2
# - output = 1

# Another example:
# - input  = [1, 2, 3, 4, 5]
# - target = [0, 0, 0, 3, 5]
# - targetLen = 2
# - output = 0

func array_ends_with{range_check_ptr}(
        a_len : felt, a : felt*, b_len : felt, b : felt*, target_len : felt) -> (res):
    assert a_len = b_len
    if target_len == 0:
        return (res=1)
    end
    
    assert a[a_len-target_len] = b[b_len-target_len]
    return array_ends_with(
        a_len=a_len, a=a, b_len=b_len, b=b, target_len=target_len-1)
end