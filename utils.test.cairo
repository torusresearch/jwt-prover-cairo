%lang starknet
%builtins pedersen range_check
from utils.array_sum import array_sum
from utils.compare_arrays import compare_arrays
from utils.array_ends_with import array_ends_with
from utils.exponent import exponent
from utils.num_bytes_in_bits import num_bytes_in_bits
from utils.slicer import slicer
from utils.substring_matcher import substring_matcher

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

@view
func test_exponent{range_check_ptr}(x, n) -> (res):
    let (res) = exponent(x=x, n=n)
    return (res=res)
end

@view 
func test_num_bytes_in_bits{range_check_ptr}(bytes_in_bits, num_bytes) -> (num):
    let (res) = num_bytes_in_bits(bytes_in_bits=bytes_in_bits, num_bytes=num_bytes)
    return (num=res)
end

@view 
func test_slicer{range_check_ptr}(
        arr_len: felt, arr: felt*, len, start_index) -> (arr_len:felt, arr: felt*):

    let (res) = slicer(arr_len=arr_len, arr=arr, len=len, start_index=start_index)
    return (arr_len=arr_len, arr=res)
end

@view
func test_substring_matcher(a_len: felt, a: felt*, b_len: felt, b: felt*) -> (res):
    let (res) = substring_matcher(a_len=a_len, a=a, b_len=b_len, b=b)
    return (res=res)
end