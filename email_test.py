import os

import pytest
from starkware.starknet.testing.starknet import Starknet
from starkware.starkware_utils.error_handling import StarkException
from helpers import genSubstrByteArray, strToByteArray
    
CONTRACT_FILE = os.path.join("", "email.test.cairo")
NUM_BYTES = 320
NUM_EMAIL_SUBSTR_BYTES = 64

@pytest.mark.asyncio
async def testEmailAddressProver():
    """Test email_address_prover method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )
    
    plaintext = '{"blah": 123, "email" : "alice@company.xyz", "foo": "bar"}'
    email = '"email" : "alice@company.xyz"'
    p = strToByteArray(plaintext, NUM_BYTES)
    emailAddress = strToByteArray('alice@company.xyz"', NUM_EMAIL_SUBSTR_BYTES)
    NUM_EMAIL_ADDRESS_BYTES = len('alice@company.xyz"')

    byteArr, pos = genSubstrByteArray(plaintext, email, NUM_BYTES, NUM_EMAIL_SUBSTR_BYTES)
    # byteArrInHex = ''
    # for byte in byteArr:
    #     byteArrInHex = byteArrInHex + hex(byte).lstrip('0x')

    # print(byteArr)

    EMAIL_KEY_START_POS = 20
    NUM_SPACES_BEFORE_COLON = 1
    NUM_SPACES_AFTER_COLON = 1
    EMAIL_VAL_END_POS = EMAIL_KEY_START_POS + 7 + NUM_SPACES_BEFORE_COLON + 1 + NUM_SPACES_AFTER_COLON + NUM_EMAIL_ADDRESS_BYTES 

    assert byteArr[EMAIL_KEY_START_POS] == 34
    assert byteArr[EMAIL_KEY_START_POS + 6] == 34
    
    await contract.test_email_address_prover(email_substr_utf8=byteArr, email_address=emailAddress, num_email_address_bytes=NUM_EMAIL_ADDRESS_BYTES, email_key_start_pos=EMAIL_KEY_START_POS, email_value_end_pos=EMAIL_VAL_END_POS, num_spaces_before_colon=NUM_SPACES_BEFORE_COLON, num_spaces_after_colon=NUM_SPACES_AFTER_COLON).call()
