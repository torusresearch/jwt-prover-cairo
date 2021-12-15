from starkware.cairo.common.math import assert_le
from starkware.cairo.common.math_cmp import is_le
from utils.exponent import exponent
from starkware.cairo.common.serialize import serialize_word

func num_bytes_in_bits{range_check_ptr}(bytes_in_bits, num_bytes) -> (num):
    assert_le(2, bytes_in_bits)
    
    let (exponent_res) = exponent(2, bytes_in_bits)
    let (is_less_than) = is_le(exponent_res+1, num_bytes)
    if is_less_than == 0:
        return (num=bytes_in_bits)
    end

    return num_bytes_in_bits(bytes_in_bits=bytes_in_bits+1, num_bytes=num_bytes)
end