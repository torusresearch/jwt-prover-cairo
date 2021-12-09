# Implementaiton of endsWith.circom
from starkware.cairo.common.math import assert_nn_le

func array_ends_with{range_check_ptr}(a_len : felt, a : felt*, b_len : felt, b : felt*, from_index : felt) -> (res):
    assert a_len = b_len
    if from_index == a_len:
        return (res=1)
    end

    assert_nn_le(from_index, a_len - 1)

    assert a[from_index] = b[from_index]
    return array_ends_with(
        a_len=a_len, a=a, b_len=b_len, b=b, from_index=from_index+1)
end