# Implementaiton of endsWith.circom
from starkware.cairo.common.math import assert_nn_le

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