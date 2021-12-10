# Implementation of matcher.circom
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