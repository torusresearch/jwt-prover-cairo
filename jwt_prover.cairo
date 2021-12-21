from utils.substring_matcher import substring_matcher
from starkware.cairo.common.alloc import alloc
from email import email_address_prover

func jwt_hidden_email_address_prover{range_check_ptr}(
    pre_image_b64_len: felt, pre_image_b64: felt*, email_substr_b64_len: felt, email_substr_b64: felt*, email_substr_utf8_len: felt, email_substr_utf8: felt*, email_address_len: felt, email_address: felt*, email_substr_bit_index, email_substr_bit_len, email_key_start_pos, email_value_end_pos, num_spaces_before_colon, num_spaces_after_colon, num_email_address_bytes) -> ():
    
    # ------------------------------------------------------------------------
    # 1. Accept and check a shorter array of elements that represent the email
    # substring

    let (res) = substring_matcher(pre_image_b64_len, pre_image_b64, email_substr_b64_len, email_substr_b64)
    assert res = 1

    # ------------------------------------------------------------------------
    # 2. Check the email address
    email_address_prover(email_substr_utf8_len=email_substr_utf8_len, email_substr_utf8=email_substr_utf8, email_address_len=email_address_len, email_address=email_address, num_email_address_bytes=num_email_address_bytes, email_key_start_pos=email_key_start_pos, email_value_end_pos=email_value_end_pos, num_spaces_before_colon=num_spaces_before_colon, num_spaces_after_colon=num_spaces_after_colon)

    # TODO: ------------------------------------------------------------------------
    # 3. Check that the SHA256 hash of the base64url-encoded preimage is
    # correct

    return ()
end