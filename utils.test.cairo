%lang starknet
%builtins pedersen range_check
from utils.array_sum import array_sum
from utils.compare_arrays import compare_arrays
from utils.array_ends_with import array_ends_with

@view
func test_array_sum(arr_len : felt, arr : felt*) -> (sum):
    let (sum) = array_sum(arr_len=arr_len, arr=arr)
    return (sum=sum)
end

@view
func test_compare_arrays(
        a_len : felt, a : felt*, b_len : felt, b : felt*) -> (res):
    let (res) = compare_arrays(a_len, a, b_len, b)
    return (res=res)
end

@view 
func test_array_ends_with{range_check_ptr}(
        a_len : felt, a : felt*, b_len : felt, b : felt*, target_len : felt) -> (res):
    let (res) = array_ends_with(a_len, a, b_len, b, target_len)
    return (res=res)
end
