# Implementation of calculateTotal.circom

# Computes the sum of the memory elements at addresses:
#   arr + 0, arr + 1, ..., arr + (size - 1).
func array_sum(
        arr_len : felt, arr : felt*) -> (sum):
    if arr_len == 0:
        return (sum=0)
    end

    let (sum_of_rest) = array_sum(arr_len=arr_len-1, arr=arr + 1)
    return (sum=[arr] + sum_of_rest)
end