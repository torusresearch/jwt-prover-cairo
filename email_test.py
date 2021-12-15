import os

import pytest
from starkware.starknet.testing.starknet import Starknet
from starkware.starkware_utils.error_handling import StarkException
from main import gen_substring_byte_array, str_to_byte_array

CONTRACT_FILE = os.path.join("", "email.test.cairo")
NUM_BYTES = 320
NUM_EMAIL_SUBSTR_BYTES = 64

@pytest.mark.asyncio
async def test_email_address_prover():
    """Test email_address_prover method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )
    
    plaintext = '{"blah": 123, "email" : "alice@company.xyz", "foo": "bar"}'
    email = '"email" : "alice@company.xyz"'
    p = str_to_byte_array(plaintext, NUM_BYTES)
    email_address = str_to_byte_array('alice@company.xyz"', NUM_EMAIL_SUBSTR_BYTES)
    NUM_EMAIL_ADDRESS_BYTES = len('alice@company.xyz"')

    byte_arr, pos = gen_substring_byte_array(plaintext, email, NUM_BYTES, NUM_EMAIL_SUBSTR_BYTES)
    # byte_arr_in_hex = ''
    # for byte in byte_arr:
    #     byte_arr_in_hex = byte_arr_in_hex + hex(byte).lstrip('0x')

    # print(byte_arr)

    EMAIL_KEY_START_POS = 20
    NUM_SPACES_BEFORE_COLON = 1
    NUM_SPACES_AFTER_COLON = 1
    EMAIL_VAL_END_POS = EMAIL_KEY_START_POS + 7 + NUM_SPACES_BEFORE_COLON + 1 + NUM_SPACES_AFTER_COLON + NUM_EMAIL_ADDRESS_BYTES 

    assert byte_arr[EMAIL_KEY_START_POS] == 34
    assert byte_arr[EMAIL_KEY_START_POS + 6] == 34
    
    await contract.test_email_address_prover(jwt_email_substring=byte_arr, email=email_address, num_email_addr_bytes=NUM_EMAIL_ADDRESS_BYTES, email_key_start_pos=EMAIL_KEY_START_POS, email_val_end_pos=EMAIL_VAL_END_POS, num_spaces_before_colon=NUM_SPACES_BEFORE_COLON, num_spaces_after_colon=NUM_SPACES_AFTER_COLON).call()
