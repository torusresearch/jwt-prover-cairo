# Implementation of email.circom
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.math import assert_not_equal
from starkware.cairo.common.math_cmp import is_le
from utils.array_ends_with import array_ends_with
from utils.slicer import slicer

func email_json_field{range_check_ptr}(
        jwt_email_substring: felt*, email_key_start_pos, email_val_end_pos, num_spaces_before_colon, num_spaces_after_colon) -> ():
    alloc_locals
    #reassign
    local range_check_ptr = range_check_ptr
    # ------------------------------------------------------------------------
    # 1. Check that email_val_end_pos is greater than at least
    # num_spaces_before_colon + num_spaces_after_colon + 12
    # i.e. "email" : "foo@bar.com"
    #      ^                     ^
    #       6    n 1 n 1 1 1 1 1

    assert_le(num_spaces_before_colon+num_spaces_before_colon+12, email_val_end_pos)

    # ------------------------------------------------------------------------
    # 2. Check that the 7 bytes starting from jwt_email_substring[email_key_start_pos]
    # match the UTF-8 representation of `"email"`
    assert jwt_email_substring[email_key_start_pos] = 0x22   # "
    assert jwt_email_substring[email_key_start_pos+1] = 0x65 # e
    assert jwt_email_substring[email_key_start_pos+2] = 0x6d # m
    assert jwt_email_substring[email_key_start_pos+3] = 0x61 # a
    assert jwt_email_substring[email_key_start_pos+4] = 0x69 # i
    assert jwt_email_substring[email_key_start_pos+5] = 0x6c # l
    assert jwt_email_substring[email_key_start_pos+6] = 0x22 # "

    # 3. Check that there are num_spaces_before_colon spaces starting from index
    # email_key_start_pos + 7 to email_key_start_pos + 7 + num_spaces_before_colon - 1

    let (spaces) = total_spaces(jwt_email_substring, email_key_start_pos+7, email_key_start_pos + 7 + num_spaces_before_colon - 1, 0)
    assert spaces = num_spaces_before_colon

    # 4. Check that there is a colon at index email_key_start_pos + 6 +
    # num_spaces_before_colon
    #"email"<num_spaces_before_colon>:  ...

    assert jwt_email_substring[email_key_start_pos+7+num_spaces_before_colon] = 0x3a # :

    # 5. Check that there are num_spaces_after_colon spaces starting from index
    # email_key_start_pos + 7 + num_spaces_before_colon + 1
    # to email_key_start_pos + 7 + num_spaces_before_colon + 1 + num_spaces_after_colon - 1

    let (spaces) = total_spaces(
        jwt_email_substring, email_key_start_pos+7+num_spaces_before_colon+1, email_key_start_pos+7+num_spaces_before_colon+1+num_spaces_after_colon-1, 0)
    assert spaces = num_spaces_after_colon

    # 6. Check that the byte at email_val_end_pos matches
    # the UTF-8 representation of ".

    assert jwt_email_substring[email_val_end_pos] = 0x22 # "

    # 7. Check that the 2 bytes before email_val_end_pos are not the UTF-8
    # representation of \\.

    assert_not_equal(jwt_email_substring[email_val_end_pos-2], 0x5c) # \
    assert_not_equal(jwt_email_substring[email_val_end_pos-1], 0x5c) # \

    return ()
end

func total_spaces(
        jwt_email_substring: felt*, start_pos, end_pos, total) -> (res):

    if start_pos == end_pos + 1:
        return (res=total)
    end

    if jwt_email_substring[start_pos] == 0x20:
        return total_spaces(
                jwt_email_substring, start_pos+1, end_pos, total+1)
    end

    return total_spaces(
            jwt_email_substring, start_pos+1, end_pos, total)
end

func email_address_prover{range_check_ptr}(
        jwt_email_substring_len: felt, jwt_email_substring: felt*, email_len: felt, email: felt*, num_email_addr_bytes, email_key_start_pos, email_val_end_pos, num_spaces_before_colon, num_spaces_after_colon) -> ():

        # Prove the email json field
        email_json_field(
                jwt_email_substring, email_key_start_pos, email_val_end_pos, num_spaces_before_colon, num_spaces_after_colon)

        # 2. Check that emailSubstr contains emailAddress
        let (sliced_arr) = slicer(arr_len=jwt_email_substring_len, arr=jwt_email_substring, len=num_email_addr_bytes, start_index=email_val_end_pos - num_email_addr_bytes + 1)

        let (res) = array_ends_with(jwt_email_substring_len, sliced_arr, email_len, email, num_email_addr_bytes)
        assert res = 1

        return ()
end