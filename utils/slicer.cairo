from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.math_cmp import is_le

func slicer{range_check_ptr}(arr_len: felt, arr: felt*, len, start_index) -> (arr: felt*):
    alloc_locals
    #reassign
    local range_check_ptr = range_check_ptr

    # Ensure that len <= arr_len
    assert_le(len, arr_len)

    # Ensure that start_index + len <= arr_len
    assert_le(start_index+len, arr_len)

    let (out) = alloc()

    let (res) = get_slice(in_len=arr_len, in=arr, out=out, i=0, start_index=start_index, len=len)
    return (arr=res)
end

func get_slice{range_check_ptr}(in_len: felt, in: felt*, out: felt*, i, start_index, len) -> (arr: felt*):
    alloc_locals
    #reassign
    local range_check_ptr = range_check_ptr

    if i == in_len:
        return (arr=out)
    end

    # if i < length - len, assign 0 to out[i]
    # otherwise, assign in[i - (in_len - start_index - len)]
    let (is_less_than) = is_le(i, in_len - len - 1)
    if is_less_than == 1:
        assert [out+i] = 0
    else:
        assert [out+i] = in[i - (in_len - start_index - len)]
    end
    
    return get_slice(in_len=in_len, in=in, out=out, i=i+1, start_index=start_index, len=len)
end