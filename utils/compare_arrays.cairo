# Implementation of matcher.circom

# Given two input arrays, output 1 if they match, and 0 if they do not.
# Example 1:
# - in[0] = [1, 2, 3, 4, 5]
# - in[1] = [1, 2, 3, 4, 5]
# - out = 1

# Example 2:
# - in[0] = [5, 4, 3, 2, 1]
# - in[1] = [1, 2, 3, 4, 5]
# - out = 0

func compare_arrays(
        a_len : felt, a : felt*, b_len : felt, b : felt*) -> (res):
    assert a_len = b_len
    if a_len == 0:
        return (res=1)
    end
    assert a[0] = b[0]
    return compare_arrays(
        a_len=a_len - 1, a=a + 1, b_len=b_len - 1, b=b + 1)
end