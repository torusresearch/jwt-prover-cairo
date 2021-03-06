%lang starknet
%builtins pedersen range_check
from email import total_spaces, email_json_field, email_address_prover

@view
func test_total_spaces(
        jwt_email_substring_len: felt, jwt_email_substring: felt*, start_pos, end_pos, total) -> (res):

    let (res) = total_spaces(jwt_email_substring, start_pos, end_pos, 0)
    return (res=res)
end

@view
func test_email_json_field{range_check_ptr}(
        jwt_email_substring_len: felt, jwt_email_substring: felt*, email_key_start_pos, email_val_end_pos, num_spaces_before_colon, num_spaces_after_colon):

    email_json_field(
        jwt_email_substring,
        email_key_start_pos,
        email_val_end_pos,
        num_spaces_before_colon,
        num_spaces_after_colon)
    ret
end

@view
func test_email_address_prover{range_check_ptr}(
        email_substr_utf8_len: felt, email_substr_utf8: felt*, email_address_len: felt, email_address: felt*, num_email_address_bytes, email_key_start_pos, email_value_end_pos, num_spaces_before_colon, num_spaces_after_colon) -> ():

        email_address_prover(email_substr_utf8_len=email_substr_utf8_len, email_substr_utf8=email_substr_utf8, email_address_len=email_address_len, email_address=email_address, num_email_address_bytes=num_email_address_bytes, email_key_start_pos=email_key_start_pos, email_value_end_pos=email_value_end_pos, num_spaces_before_colon=num_spaces_before_colon, num_spaces_after_colon=num_spaces_after_colon)
    return ()
end